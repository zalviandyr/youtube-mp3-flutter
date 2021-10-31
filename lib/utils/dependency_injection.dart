import 'package:get_it/get_it.dart';
import 'package:youtube_mp3/utils/utils.dart';

class DependencyInjection {
  static final GetIt _getIt = GetIt.instance;

  static Future<void> setup() async {
    AppSharedPreferences pref = await AppSharedPreferences.getInstance();
    AppLocalization localization = await AppLocalization.getInstance();

    _getIt.registerLazySingleton<AppSharedPreferences>(() => pref);
    _getIt.registerLazySingleton<AppLocalization>(() => localization);
  }
}
