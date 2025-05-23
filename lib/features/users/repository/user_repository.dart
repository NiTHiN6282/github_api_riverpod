import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../../models/repository_model.dart';
import '../../../models/user_model.dart';
import '../../../models/user_search_model.dart';

final token = dotenv.env['GITHUB_TOKEN'];

class UserRepository {
  final http.Client _client;
  final String _baseUrl = 'https://api.github.com';

  UserRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<UserSearchModel?> searchUsers({
    required String query,
    int page = 1,
    int perPage = 20,
  }) async {
    final uri = Uri.parse(
        '$_baseUrl/search/users?q=$query&page=$page&per_page=$perPage');

    final response = await _client.get(
      uri,
      headers: {
        'Accept': 'application/vnd.github+json',
        'Authorization': 'Bearer $token', // Add token if needed
        'X-GitHub-Api-Version': '2022-11-28',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserSearchModel.fromJson(data);
    } else {
      throw Exception('Failed to fetch users: ${response.reasonPhrase}');
    }
  }

  Future<UserModel?> getUserData({required String userName}) async {
    final uri = Uri.parse('$_baseUrl/users/$userName');

    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    } else {
      return null;
    }
  }

  Future<List<RepositoryModel>> getRepos({
    required String type,
    required String userName,
    int page = 1,
    int perPage = 20,
  }) async {
    final uri = Uri.parse(
        '$_baseUrl/users/$userName/repos?page=$page&per_page=$perPage');

    final response = await _client.get(
      uri,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List.generate(
          data.length, (index) => RepositoryModel.fromJson(data));
    } else {
      throw Exception('Failed to fetch users: ${response.reasonPhrase}');
    }
  }
}
