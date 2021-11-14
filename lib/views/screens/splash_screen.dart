import 'package:flutter/material.dart';
import 'package:youtube_mp3/views/widgets/widgets.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: AppIcon(),
      ),
    );
  }
}
