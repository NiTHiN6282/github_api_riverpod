import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../core/utils.dart';
import '../../../models/repository_model.dart';
import '../controller/user_controller.dart';

class UserDetails extends StatefulWidget {
  final String userName;
  const UserDetails({super.key, required this.userName});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  // UserModel? userData;
  List<RepositoryModel> repositories = [];
  int currentPage = 1;
  bool isLoading = false; // For repositories
  bool isLoadingUser = true; // For user data
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getRepos();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  getRepos() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    var request = http.Request(
      'GET',
      Uri.parse(
          'https://api.github.com/users/${widget.userName}/repos?page=$currentPage&per_page=20&type=${type ?? "All"}'),
    );

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var jsonData = await response.stream.bytesToString();
      var decodeData = jsonDecode(jsonData);

      List<RepositoryModel> newRepositories = List.generate(
        decodeData.length,
        (index) => RepositoryModel.fromJson(decodeData[index]),
      );

      setState(() {
        repositories.addAll(newRepositories);
        currentPage++;
      });
    } else {
      debugPrint(response.reasonPhrase);
    }

    setState(() {
      isLoading = false;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      getRepos();
    }
  }

  String? type;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "User Details",
              style:
                  GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            bottom: const TabBar(
              tabs: [
                Tab(text: "Profile"),
                Tab(text: "Repositories"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // First Tab: User Details
              Consumer(builder: (context, ref, child) {
                var data = ref.watch(getUserDataProvider(widget.userName));
                return data.when(
                  data: (userData) {
                    return userData == null
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(userData.avatarUrl),
                                    radius: 50,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    userData.name ?? "No Name",
                                    style: GoogleFonts.roboto(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "@${userData.login}",
                                    style: GoogleFonts.roboto(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Card(
                                    elevation: 4,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Repositories: ${userData.publicRepos}",
                                            style: GoogleFonts.roboto(
                                                fontSize: 16),
                                          ),
                                          Text(
                                            "Followers: ${userData.followers}",
                                            style: GoogleFonts.roboto(
                                                fontSize: 16),
                                          ),
                                          Text(
                                            "Following: ${userData.following}",
                                            style: GoogleFonts.roboto(
                                                fontSize: 16),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "Bio: ${userData.bio ?? "No bio available"}",
                                            style: GoogleFonts.roboto(
                                                fontSize: 16),
                                          ),
                                          Text(
                                            "Location: ${userData.location ?? "No location"}",
                                            style: GoogleFonts.roboto(
                                                fontSize: 16),
                                          ),
                                          Text(
                                            "Joined: ${DateFormat("dd-MMM-yyyy").format(userData.createdAt)}",
                                            style: GoogleFonts.roboto(
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                  },
                  error: (error, stackTrace) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  loading: () {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
              }),
              // Second Tab: Repository List with Pagination
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            type = value;
                            currentPage = 1;
                            repositories.clear();
                            getRepos();
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: "All",
                              child: Text("All"),
                            ),
                            const PopupMenuItem(
                              value: "Owner",
                              child: Text("Owner"),
                            ),
                            const PopupMenuItem(
                              value: "Member",
                              child: Text("Member"),
                            ),
                          ],
                          child: Row(
                            children: [
                              Text(
                                type == null ? "Select Type" : type!,
                                style: GoogleFonts.roboto(fontSize: 16),
                              ),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  repositories.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount:
                                repositories.length + (isLoading ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == repositories.length) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              var repository = repositories[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                elevation: 2,
                                child: ListTile(
                                  onTap: () {
                                    launchRepo(repository.htmlUrl);
                                  },
                                  title: Text(
                                    repository.name,
                                    style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        repository.description ?? "",
                                        style: GoogleFonts.roboto(fontSize: 14),
                                      ),
                                      Text(
                                        "Language: ${repository.language ?? "N/A"}",
                                        style: GoogleFonts.roboto(fontSize: 14),
                                      ),
                                      Text(
                                        "Stars: ${repository.stargazersCount}",
                                        style: GoogleFonts.roboto(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Center(
                          child: isLoading
                              ? const CircularProgressIndicator()
                              : Text(
                                  "No repositories found.",
                                  style: GoogleFonts.roboto(fontSize: 16),
                                ),
                        ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
