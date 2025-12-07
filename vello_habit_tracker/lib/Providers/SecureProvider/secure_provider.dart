import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vello_habit_tracker/Configurations/constants.dart';
import 'package:vello_habit_tracker/Providers/GetIt/get_it_provider.dart';

class SecureProvider {

  FlutterSecureStorage get _secure => getIt<FlutterSecureStorage>();

  Future<(String?, String?)> getCredentials() async {
    final username = await _secure.read(key: usernameConstant);
    final password = await _secure.read(key: passwordConstant);
    return (username, password);
  }

  Future<void> saveCredentials(String username, String password) async {
    _secure.write(key: usernameConstant, value: username);
    _secure.write(key: passwordConstant, value: password);
  }

  
}