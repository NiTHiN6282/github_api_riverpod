import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/user_controller.dart';
import 'user_details.dart';

class SearchUser extends ConsumerStatefulWidget {
  const SearchUser({super.key});

  @override
  ConsumerState<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends ConsumerState<SearchUser> {
  final TextEditingController controller = TextEditingController();
  Timer? _debounce;
  bool isLoading = false;

  void onSearchChanged(String query) {
    isLoading = true;
    setState(() {});
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref
          .read(userControllerProvider.notifier)
          .searchUsers(query)
          .then((value) {
        isLoading = false;
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userControllerProvider);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search GitHub Users'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: controller,
                onChanged: (value) {
                  ref.read(userControllerProvider.notifier).resetSearch();
                  onSearchChanged(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search users...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 20),
              if (state.users.isNotEmpty)
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (scrollInfo) {
                      if (!state.isLoading &&
                          state.hasMore &&
                          scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
                        ref
                            .read(userControllerProvider.notifier)
                            .searchUsers(controller.text, isNewSearch: false);
                      }
                      return false;
                    },
                    child: ListView.builder(
                      itemCount: state.users.length + (state.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (state.isLoading && index == state.users.length) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        if (index == state.users.length) {
                          return const SizedBox();
                        }

                        final user = state.users[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UserDetails(userName: user.login),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                title: Text(
                                  user.login,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    user.avatarUrl,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              else
                Expanded(
                  child: Center(
                    child: state.isLoading || isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                            controller.text.isEmpty
                                ? 'Start typing to search...'
                                : 'No users found',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
