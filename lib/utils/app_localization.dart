import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

class AppLocalization {
  static final String _countryCode = Platform.localeName.split('_')[0];
  static AppLocalization? _appLocalization;
  late Map<String, String> _languages;

  AppLocalization._internal();

  static Future<AppLocalization> getInstance() async {
    _appLocalization ??= AppLocalization._internal();

    await _appLocalization!.setLanguages(_countryCode);

    return _appLocalization!;
  }

  Future<void> setLanguages(String countryCode) async {
    String txt = '';
    try {
      txt = await rootBundle.loadString('assets/json/lang/$countryCode.json');
    } catch (err) {
      await rootBundle.loadString('assets/json/lang/en.json');
    }

    _languages = Map<String, String>.from(jsonDecode(txt));
  }

  String translate(String key) {
    return _languages[key] ?? 'unset';
  }
}
