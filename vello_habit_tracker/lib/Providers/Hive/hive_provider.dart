import 'package:hive_flutter/adapters.dart';

class HiveProvider {
  static const String mainBox = 'mainBox';

  static Future<LazyBox> generateMainBox() async {
    return await Hive.openLazyBox(mainBox);
  }
}
