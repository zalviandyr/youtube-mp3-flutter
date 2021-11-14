import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_mp3/models/models.dart';
import 'package:youtube_mp3/utils/utils.dart';

class LanguageModal extends StatefulWidget {
  const LanguageModal({Key? key}) : super(key: key);

  @override
  State<LanguageModal> createState() => _LanguageModalState();
}

class _LanguageModalState extends State<LanguageModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      child: ListView.builder(
        itemCount: AppLocalization.availableLanguages.length,
        itemBuilder: (context, index) {
          LanguageModel lang = AppLocalization.availableLanguages[index];

          return RadioListTile<String>(
            value: lang.languageCode,
            groupValue: context.locale.languageCode,
            onChanged: (selectedLang) {
              Locale selected = Locale(selectedLang!);
              context
                  .setLocale(selected)
                  .then((_) => Get.updateLocale(selected));
            },
            title: Text(lang.title),
          );
        },
      ),
    );
  }
}
