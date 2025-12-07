final usernameConstant = 'username';
final passwordConstant = 'password';
final tokenConstant = 'token';
final languageConstant = 'language';

enum UserState { none, active, loading }

const baseDomain = '192.168.1.9:3000';

const basePath = '/api';

const apiUrl = 'http://$baseDomain$basePath';

class ApiRoutes {
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String me = '/auth/me';
}
