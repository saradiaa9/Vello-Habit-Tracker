import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vello_habit_tracker/Providers/Navigation/Auth/auth_navigator.dart';
import 'package:vello_habit_tracker/Views/Auth/login_page.dart';
import 'package:vello_habit_tracker/Views/Auth/registeration_page.dart';
import 'package:vello_habit_tracker/Views/Home/home_page.dart';
import 'package:vello_habit_tracker/Views/Profile/profile_page.dart';

GlobalKey<NavigatorState> homeNavigatorKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> profileNavigatorKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> authNavigatorKey = GlobalKey<NavigatorState>();

class Routes {
  static const String root = '/';
  static const String login = '/login';
  static const String registeration = '/registeration';
  static const String profile = '/profile';
  static const String home = '/home';
  static const String changeLanguage = '/changeLanguage';
}

_navigateInitialRoute(String? route) {
  switch (route) {
    case Routes.home:
      return CupertinoPageRoute(builder: (_) => const HomePage());
    case Routes.profile:
      return CupertinoPageRoute(builder: (_) => const ProfilePage());

    default:
      return CupertinoPageRoute(builder: (_) => const Text('Error 404'));
  }
}

class RoutesGenerator {
  static Route<dynamic> generateAuthRoutes(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.root:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );
      case Routes.registeration:
        return MaterialPageRoute(
          builder: (_) => const RegisterationPage(),
          settings: settings,
        );
      case Routes.login:
        return MaterialPageRoute(
          builder: (_) => const AuthNavigator(),
          settings: settings,
        );
      default:
        return _errorRoute();
    }
  }

  static Route generateMainRoutes(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.root:
        return _navigateInitialRoute(settings.arguments as dynamic);
      case Routes.home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
          settings: settings,
        );
      case Routes.profile:
        return MaterialPageRoute(
          builder: (_) => const ProfilePage(),
          settings: settings,
        );
      case Routes.changeLanguage:
        // return MaterialPageRoute(
        //   builder: (_) => LanguagePage(),
        //   settings: settings,
        // );
      default:
        return _errorRoute();
    }
  }
}

_errorRoute() {
  return MaterialPageRoute(
    builder: (_) => Scaffold(
      appBar: AppBar(title: const Text('Error 404')),
      body: const Center(child: Text('Error 404')),
    ),
  );
}
