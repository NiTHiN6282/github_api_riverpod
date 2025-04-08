import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/user_model.dart';
import '../../../models/user_search_model.dart';
import '../repository/user_repository.dart';

final userRepositoryProvider = Provider((ref) => UserRepository());

final userControllerProvider =
    StateNotifierProvider<UserController, UserSearchState>((ref) {
  return UserController(ref.watch(userRepositoryProvider));
});

final getUserDataProvider =
    FutureProvider.family<UserModel?, String>((ref, userName) async {
  return ref
      .watch(userControllerProvider.notifier)
      .getUserData(userName: userName);
});

class UserSearchState {
  final List<UserItem> users;
  final bool isLoading;
  final bool hasMore;
  final int currentPage;
  final String query;

  UserSearchState({
    required this.users,
    required this.isLoading,
    required this.hasMore,
    required this.currentPage,
    required this.query,
  });

  UserSearchState copyWith({
    List<UserItem>? users,
    bool? isLoading,
    bool? hasMore,
    int? currentPage,
    String? query,
  }) {
    return UserSearchState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      query: query ?? this.query,
    );
  }

  factory UserSearchState.initial() {
    return UserSearchState(
      users: [],
      isLoading: false,
      hasMore: true,
      currentPage: 1,
      query: '',
    );
  }
}

class UserController extends StateNotifier<UserSearchState> {
  final UserRepository _userRepository;

  UserController(this._userRepository) : super(UserSearchState.initial());

  Future<void> searchUsers(String query, {bool isNewSearch = true}) async {
    if (state.isLoading || (query == state.query && !isNewSearch)) return;

    final int nextPage = isNewSearch ? 1 : state.currentPage + 1;

    state = state.copyWith(isLoading: true, query: query);

    try {
      final result = await _userRepository.searchUsers(
        query: query,
        page: nextPage,
        perPage: 20,
      );

      final updatedUsers = isNewSearch
          ? result?.items ?? []
          : [...state.users, ...?result?.items];

      state = state.copyWith(
        users: updatedUsers,
        isLoading: false,
        currentPage: nextPage,
        hasMore: result?.items.isNotEmpty ?? false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<UserModel?> getUserData({required String userName}) async {
    final result = await _userRepository.getUserData(
      userName: userName,
    );
    return result;
  }

  void resetSearch() {
    state = UserSearchState.initial();
  }
}
