import 'package:flutter/material.dart';
import 'package:vello_habit_tracker/Providers/Navigation/routes_generator.dart';

class HomeTabNavigator extends StatefulWidget {
  const HomeTabNavigator({super.key});

  @override
  State<HomeTabNavigator> createState() => _HomeTabNavigatorState();
}

class _HomeTabNavigatorState extends State<HomeTabNavigator>  with AutomaticKeepAliveClientMixin  {

  @override
  bool get wantKeepAlive => true;


  @override
  Widget build(BuildContext context) {
     super.build(context);

     return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          homeNavigatorKey.currentState!.maybePop();
        }
      },
      child: HeroControllerScope(
        controller: HeroController(),
        child: Navigator(
          key: homeNavigatorKey,
          initialRoute: Routes.root,
          onGenerateInitialRoutes: (state, initialRoute) {
            return [
              RoutesGenerator.generateMainRoutes(
                  const RouteSettings(name: '/', arguments: Routes.home))
            ];
          },
          onGenerateRoute: RoutesGenerator.generateMainRoutes,
        ),
      ),
    );
  }
}