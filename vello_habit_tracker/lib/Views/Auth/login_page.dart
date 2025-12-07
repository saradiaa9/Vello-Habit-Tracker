import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vello_habit_tracker/Providers/Api/api_provider.dart';
import 'package:vello_habit_tracker/Providers/Navigation/routes_generator.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Login Page', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final api = ref.read(apiProvider);
                final response = await api.login({
                  'username': 'saradiaa9',
                  'password': 'mypassword123',
                });
                if (response != null) {
                  print(response);
                } else {
                  print('Failed to login');
                }
              },
              child: const Text('Login as saradiaa9'),
            ),
          ],
        ),
      ),
    );
  }
}
