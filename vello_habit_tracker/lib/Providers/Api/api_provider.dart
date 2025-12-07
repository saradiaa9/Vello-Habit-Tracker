import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:vello_habit_tracker/Configurations/constants.dart';
import 'package:vello_habit_tracker/Models/User/user_model.dart';
import 'package:vello_habit_tracker/Providers/GetIt/get_it_provider.dart';
import 'package:vello_habit_tracker/Providers/Headers/headers_provider.dart';
import 'package:vello_habit_tracker/Providers/Session/user_session_provider.dart';

final apiProvider = Provider<ApiProvider>((ref) => ApiProvider(ref));

class ApiProvider {
  final Ref ref;

  ApiProvider(this.ref);

  HeadersProvider get headers => ref.read(headersProvider);

  final secureStorage = getIt.get<FlutterSecureStorage>();

  Future<UserModel?> login(Map<String, dynamic> data) async {
    try {
      final response = await basePostQuery(ApiRoutes.login, body: data);
      print(response);
      if (response != null && response['user'] != null) {
        print(response['user']);
        final user = UserModel.fromJson(response['user']);
        print(user);
        secureStorage.write(key: usernameConstant, value: user.username);
        secureStorage.write(key: passwordConstant, value: data['password']);
        secureStorage.write(key: tokenConstant, value: data['token']);
        final userSession = ref.read(userSessionProvider);
        userSession.login(user);
        userSession.updateToken(data['token']);

        print("Logged in successfully");
        return user;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<UserModel?> register(Map<String, dynamic> data) async {
    try {
      final response = await basePostQuery(ApiRoutes.register, body: data);
      if (response != null) {
        final user = UserModel.fromJson(response);
        secureStorage.write(key: usernameConstant, value: user.username);
        secureStorage.write(key: passwordConstant, value: data['password']);
        secureStorage.write(key: tokenConstant, value: data['token']);
        final userSession = ref.read(userSessionProvider);
        userSession.login(user);
        userSession.updateToken(data['token']);

        print("Registered successfully");
        return user;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<UserModel?> getMe() async {
    try {
      final response = await baseGetQuery(ApiRoutes.me);
      if (response != null) {
        final user = UserModel.fromJson(response);
        return user;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> baseGetQuery(
    String route, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    body ??= {};
    try {
      final HeadersProvider hprov = ref.read(headersProvider);
      final Map<String, String> basic = hprov.basic;

      final user = ref.read(userSessionProvider);
      final initialUserState = user.state.value;
      final logout = user.logout;

      Map<String, String>? computedHeaders = (headers ?? basic);

      final uri = Uri.http(baseDomain, basePath + route, body);

      final response = await http.get(uri, headers: computedHeaders);

      final statusOk = response.statusCode == 200;
      final Map<String, dynamic> responseBody =
          jsonDecode(response.body) as Map<String, dynamic>;
      final isUnauth =
          responseBody['message']?.toString().contains('Unauthenticated') ==
          true;

      if (isUnauth && initialUserState != UserState.none) {
        logout();
        return null;
      }

      return statusOk ? responseBody : null;
    } catch (e, s) {
      print('$e, $s');
      return null;
    }
  }

  Future<Map<String, dynamic>?> basePostQuery(
    String route, {
    required Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    body ??= {};
    try {
      final HeadersProvider hprov = ref.read(headersProvider);
      final Map<String, String> basic = hprov.basic;

      final user = ref.read(userSessionProvider);
      final initialUserState = user.state.value;
      final logout = user.logout;

      Map<String, String>? computedHeaders = (headers ?? basic);

      final res = await http.post(
        Uri.parse(apiUrl + route),
        body: jsonEncode(body),
        headers: computedHeaders,
      );

      final Map<String, dynamic> map = res.body.isNotEmpty
          ? jsonDecode(res.body) as Map<String, dynamic>
          : {};

      final isUnauth =
          map['message']?.toString().contains('Unauthenticated') == true;

      if (isUnauth && initialUserState != UserState.none) {
        logout();
        return null;
      }

      return map.isNotEmpty ? map : null;
    } catch (e, s) {
      print('$e, $s');
      return null;
    }
  }
}
