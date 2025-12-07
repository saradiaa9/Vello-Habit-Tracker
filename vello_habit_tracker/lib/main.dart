import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:sizer/sizer.dart';
import 'package:vello_habit_tracker/Models/Localization/l10.dart';
import 'package:vello_habit_tracker/Providers/GetIt/get_it_provider.dart';
import 'package:vello_habit_tracker/Providers/Localization/language_provider.dart';
import 'package:vello_habit_tracker/Views/MiddleView/middle_view.dart';
import 'package:vello_habit_tracker/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await GetItProvider.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {

  @override
  Widget build(BuildContext context) {
    final localization = ref.watch(languageProvider);
    return OverlaySupport.global(
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            title: 'Flutter Demo',
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: L10n.all,
            locale: localization.curLang,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blueGrey[900]!,
              ),
              useMaterial3: true,
            ),
            home: const MiddleView(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

