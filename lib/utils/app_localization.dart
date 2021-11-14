import 'package:flutter/widgets.dart';
import 'package:youtube_mp3/models/models.dart';

class AppLocalization {
  // *To add new language just edit this line and add new .json file to assets/lang/json
  static const List<LanguageModel> availableLanguages = [
    LanguageModel(languageCode: 'en', title: 'English'),
    LanguageModel(languageCode: 'id', title: 'Indonesia')
  ];

  static String get pathLang => 'assets/json/lang';

  static Locale get fallbackLocale {
    return Locale(availableLanguages[0].languageCode);
  }

  static List<Locale> get availableLocales {
    return availableLanguages.map((e) => Locale(e.languageCode)).toList();
  }
}
