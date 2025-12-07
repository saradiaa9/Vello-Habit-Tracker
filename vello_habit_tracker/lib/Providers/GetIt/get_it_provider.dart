import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vello_habit_tracker/Providers/Hive/hive_provider.dart';
import 'package:vello_habit_tracker/Providers/SecureProvider/secure_provider.dart';

final getIt = GetIt.instance;

class GetItProvider {
  static LazyBox get mainStorage =>
      getIt<LazyBox>(instanceName: HiveProvider.mainBox);

      static init() async {
    getIt.registerSingleton<LazyBox>(
      await HiveProvider.generateMainBox(),
      instanceName: HiveProvider.mainBox,
    );

    AndroidOptions getAndroidOptions() =>
        const AndroidOptions(encryptedSharedPreferences: true);

    getIt.registerSingleton<FlutterSecureStorage>(
      FlutterSecureStorage(aOptions: getAndroidOptions()),
    );

    getIt.registerSingleton<SecureProvider>(SecureProvider());

    await getIt.allReady();
  }
}