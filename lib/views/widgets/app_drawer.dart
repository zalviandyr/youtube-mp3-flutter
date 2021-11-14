import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youtube_mp3/views/widgets/widgets.dart';

class AppDrawer extends StatelessWidget {
  final VoidCallback onLanguageSetting;
  const AppDrawer({Key? key, required this.onLanguageSetting})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: const EdgeInsets.only(top: kToolbarHeight),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              child: AppIcon.dense(),
            ),
            const SizedBox(height: 50.0),
            MaterialButton(
              onPressed: onLanguageSetting,
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Row(
                children: [
                  const FaIcon(
                    FontAwesomeIcons.globe,
                    size: 25.0,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 10.0),
                  const Text('language_setting').tr(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
