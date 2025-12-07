import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vello_habit_tracker/Providers/Localization/language_provider.dart';
import 'package:vello_habit_tracker/Providers/Navigation/routes_generator.dart';

class AuthNavigator extends ConsumerStatefulWidget {
  final String? target;
  const AuthNavigator({super.key, this.target});

  @override
  ConsumerState<AuthNavigator> createState() => _AuthNavigatorState();
}

class _AuthNavigatorState extends ConsumerState<AuthNavigator> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(languageProvider).init(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, result) async {
      if (!didPop) {
        authNavigatorKey.currentState!.maybePop();
      }
    },
      child: Navigator(
        key: authNavigatorKey,
        initialRoute: widget.target,
        onGenerateRoute: RoutesGenerator.generateAuthRoutes,
      ),
    );
  }
}