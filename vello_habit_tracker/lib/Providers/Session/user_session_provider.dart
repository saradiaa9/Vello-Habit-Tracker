import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vello_habit_tracker/Configurations/constants.dart';
import 'package:vello_habit_tracker/Models/User/user_model.dart';
import 'package:vello_habit_tracker/Providers/GetIt/get_it_provider.dart';

final userSessionProvider = ChangeNotifierProvider<UserSession>(
  (ref) => UserSession(ref),
);

class UserSession extends ChangeNotifier {
  late final Ref ref;

  UserSession(this.ref);

  ValueNotifier<UserState> state = ValueNotifier(UserState.loading);

  UserModel? user;

  bool get isActive => state.value == UserState.active;

  String? token;

  void updateToken(String? newToken) {
    token = newToken;
    notifyListeners();
  }

  void login(UserModel response) {
    user = response;
    state.value = UserState.active;
    notifyListeners();
  }

  void logout() {
    state.value = UserState.none;
    final secureStorage = getIt.get<FlutterSecureStorage>();
    secureStorage.delete(key: usernameConstant);
    secureStorage.delete(key: passwordConstant);
    user = null;
  }

  setState(UserState newState) {
    state.value = newState;
  }
  
}
