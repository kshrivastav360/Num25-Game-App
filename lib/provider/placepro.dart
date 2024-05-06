import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numberproj/models/placemdl.dart';

class UserNotifier extends StateNotifier<User> {
  UserNotifier() : super(User(uName: ''));

  void addUser(String title) {
    state = User(uName: title);
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User>(
  (ref) => UserNotifier(),
);
