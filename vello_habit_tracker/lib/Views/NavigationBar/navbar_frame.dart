import 'package:advanced_salomon_bottom_bar/advanced_salomon_bottom_bar.dart';
import 'package:vello_habit_tracker/Core/Theme/app_colors.dart';
import 'package:vello_habit_tracker/Providers/Navigation/Home/home_tab_navigator.dart';
import 'package:vello_habit_tracker/Providers/Navigation/Profile/profile_tab_navigator.dart';
import 'package:vello_habit_tracker/Providers/Navigation/routes_generator.dart';
import 'package:vello_habit_tracker/Providers/Session/user_session_provider.dart';
import 'package:vello_habit_tracker/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

// final mainControllerProvider = Provider<PageController>((ref) {
//   return PageController();
// });

class NavbarFrame extends ConsumerStatefulWidget {
  const NavbarFrame({super.key});

  @override
  ConsumerState<NavbarFrame> createState() => _NavbarFrameState();
}

class _NavbarFrameState extends ConsumerState<NavbarFrame> {
  late final PageController mainController = PageController();
  late List<Widget> pages;
  late List<GlobalKey<NavigatorState>> navKeys;

  final ValueNotifier<int> currentTabIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();

    pages = [HomeTabNavigator(), ProfileTabNavigator()];
    navKeys = [homeNavigatorKey, profileNavigatorKey];

    mainController.addListener(_onPageChangedFromController);
  }

  void _onPageChangedFromController() {
    final page = mainController.page;
    if (page != null) {
      currentTabIndex.value = page.round();
    }
  }

  @override
  void dispose() {
    mainController.removeListener(_onPageChangedFromController);
    mainController.dispose();
    currentTabIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!; // currently unused, but fine
    final userSession = ref.watch(userSessionProvider);

    return Scaffold(
      body: PageView(
        controller: mainController,
        onPageChanged: (index) {
          currentTabIndex.value = index;
        },
        children: pages,
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: currentTabIndex,
        builder: (context, index, child) {
          return AdvancedSalomonBottomBar(
            itemPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1),
            selectedColorOpacity: 0,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(40),
              ),
              color: Theme.of(context).colorScheme.surface,
            ),
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textSecondary,
            currentIndex: index,
            onTap: (value) {
              if (value == index) {
                // Pop to root of current tab
                navKeys[index].currentState!.popUntil((route) => route.isFirst);
              } else {
                mainController.jumpToPage(value);
              }
            },
            items: [

                AdvancedSalomonBottomBarItem(
                  icon: SizedBox(
                    width: 15.w,
                    child: navBarWidget(icon: Icons.home, title: lang.home),
                  ),
                  title: const SizedBox(),
                ),
            
                AdvancedSalomonBottomBarItem(
                  icon: SizedBox(
                    width: 15.w,
                    child: navBarWidget(
                      icon: CupertinoIcons.profile_circled,
                      title: lang.profile,
                    ),
                  ),
                  title: const SizedBox(),
                ),
            ],
          );
        },
      ),
    );
  }

  Column navBarWidget({required IconData icon, required String title}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 4.h),
        SizedBox(height: 1.h),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ],
    );
  }
}
