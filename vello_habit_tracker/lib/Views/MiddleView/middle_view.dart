import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vello_habit_tracker/Configurations/constants.dart';
import 'package:vello_habit_tracker/Providers/Api/api_provider.dart';
import 'package:vello_habit_tracker/Providers/GetIt/get_it_provider.dart';
import 'package:vello_habit_tracker/Providers/Hive/hive_provider.dart';
import 'package:vello_habit_tracker/Providers/Localization/language_provider.dart';
import 'package:vello_habit_tracker/Providers/Navigation/Auth/auth_navigator.dart';
import 'package:vello_habit_tracker/Providers/Session/user_session_provider.dart';
import 'package:vello_habit_tracker/Views/NavigationBar/navbar_frame.dart';

class MiddleView extends ConsumerStatefulWidget {
  const MiddleView({super.key});

  @override
  ConsumerState<MiddleView> createState() => _MiddleViewState();
}

class _MiddleViewState extends ConsumerState<MiddleView>
    with AutomaticKeepAliveClientMixin {
  bool initialized = false;
  LazyBox get mainBox => getIt.get<LazyBox>(instanceName: HiveProvider.mainBox);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ref.read(languageProvider).init(context);
      await findOldSession();
      final userSession = ref.read(userSessionProvider);
      print("User Session State: ${userSession.state.value}");
      initialized = true;

      setState(() {});
    });
    super.initState();
  }

  findOldSession() async {
    print("Finding old session");
    final secureStorage = getIt.get<FlutterSecureStorage>();
    final username = await secureStorage.read(key: usernameConstant);
    final password = await secureStorage.read(key: passwordConstant);
    // final currentLanguageString = await mainBox.get(Constants.language);
    final api = ref.read(apiProvider);
    print("Username: $username");
    print("Password: $password");
    if (username != null && password != null) {
      final data = {'username': username, 'password': password};
      final response = await api.login(data);
      if (response == null) {
        ref.read(userSessionProvider).setState(UserState.none);
      } else {
        ref.read(userSessionProvider).setState(UserState.active);
      }
    } else {
      ref.read(userSessionProvider).setState(UserState.none);
    }
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final session = ref.watch(userSessionProvider);
    return ValueListenableBuilder<UserState>(
      valueListenable: session.state,
      builder: (context, state, child) {
        return initialized
            ? AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: state == UserState.active
                    ? NavbarFrame()
                    : state == UserState.none
                    ? AuthNavigator()
                    : const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      ),
              )
            : const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
