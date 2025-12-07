import 'package:flutter/material.dart';
import 'package:vello_habit_tracker/Providers/Navigation/routes_generator.dart';

class ProfileTabNavigator extends StatefulWidget {
  const ProfileTabNavigator({super.key});

  @override
  State<ProfileTabNavigator> createState() => _ProfileTabNavigatorState();
}

class _ProfileTabNavigatorState extends State<ProfileTabNavigator> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;


  @override
  Widget build(BuildContext context) {
    super.build(context);

     return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          profileNavigatorKey.currentState!.maybePop();
        }
      },
      child: HeroControllerScope(
        controller: HeroController(),
        child: Navigator(
          key: profileNavigatorKey,
          initialRoute: Routes.root,
          onGenerateInitialRoutes: (state, initialRoute) {
            return [
              RoutesGenerator.generateMainRoutes(
                  const RouteSettings(name: '/', arguments: Routes.profile))
            ];
          },
          onGenerateRoute: RoutesGenerator.generateMainRoutes,
        ),
      ),
    );
  }
}