

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vello_habit_tracker/Configurations/constants.dart';
import 'package:vello_habit_tracker/Models/Localization/l10.dart';
import 'package:vello_habit_tracker/Providers/GetIt/get_it_provider.dart';
import 'package:vello_habit_tracker/Providers/Hive/hive_provider.dart';
import 'package:vello_habit_tracker/l10n/app_localizations.dart';

class LanguageNotifier extends ChangeNotifier {
  late Locale curLang = L10n.all.first;

  late AppLocalizations locale;

  Ref ref;

  LazyBox get mainBox => getIt.get<LazyBox>(instanceName: HiveProvider.mainBox);

  init(BuildContext context) async {
    locale = AppLocalizations.of(context)!;
    final currentLanguageString = await mainBox.get(languageConstant);
    curLang = getLocale(currentLanguageString);
    notifyListeners();
  }

  LanguageNotifier(this.ref);

  Locale getLocale(String? str) {
    if (str == null) return L10n.all.first;
    return L10n.all.firstWhere(
      (e) => e.languageCode.toLowerCase() == str.toLowerCase(),
      orElse: () => L10n.all.first,
    );
  }

  changeLanguage(String newLang) async {
    try {
      curLang = getLocale(newLang);
      await mainBox.put(languageConstant, curLang.languageCode);
      notifyListeners();
      return true;
    } catch (e, s) {
      print('Failed to changeLanguage $e, $s');
    }
  }
}

final languageProvider = ChangeNotifierProvider<LanguageNotifier>(
  (ref) => LanguageNotifier(ref),
);
