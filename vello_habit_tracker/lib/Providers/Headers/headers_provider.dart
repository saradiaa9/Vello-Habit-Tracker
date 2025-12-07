import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vello_habit_tracker/Providers/Session/user_session_provider.dart';

final headersProvider = Provider<HeadersProvider>(
  (ref) => HeadersProvider(ref),
);

class HeadersProvider {
  late final Ref ref;

  HeadersProvider(this.ref);

  Map<String, String> basic = {
    'accept': 'application/json',
    "Content-Type": "application/json",
  };

  Future<Map<String, String>> get token async {
    final token = ref.read(userSessionProvider).token;

    return {
      'accept': 'application/json',
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }
}