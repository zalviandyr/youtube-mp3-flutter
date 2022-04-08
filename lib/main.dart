import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:youtube_mp3/blocs/blocs.dart';
import 'package:youtube_mp3/constants/string_const.dart';
import 'package:youtube_mp3/utils/app_localization.dart';
import 'package:youtube_mp3/utils/utils.dart';
import 'package:youtube_mp3/views/pallette.dart';
import 'package:youtube_mp3/views/screens/screens.dart';

// TODO: add home screen tutorial
// TODO: search action
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  runApp(EasyLocalization(
    supportedLocales: AppLocalization.availableLocales,
    path: AppLocalization.pathLang,
    fallbackLocale: AppLocalization.fallbackLocale,
    saveLocale: true,
    useOnlyLangCode: true,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  final Future _futureSplash = Future.delayed(const Duration(seconds: 3));

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: () => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => YoutubeLinkBloc()),
          BlocProvider(create: (_) => DownloadAudioBloc()),
          BlocProvider(create: (_) => MusicBloc()),
        ],
        child: GetMaterialApp(
          title: StringConst.appName,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: ThemeData(
            fontFamily: 'JosefinSans',
            scaffoldBackgroundColor: Pallette.scaffoldBackground,
            colorScheme: const ColorScheme.light(
              primary: Pallette.primaryColor,
              secondary: Pallette.secondaryColor,
            ),
            textTheme: TextTheme(
              headline2: TextStyle(
                fontSize: 60.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              headline3: TextStyle(
                fontSize: 48.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              headline6: TextStyle(fontSize: 20.sp),
              // TextForm style
              subtitle1: TextStyle(fontSize: 16.sp),
              bodyText1: TextStyle(fontSize: 16.sp),
              bodyText2: TextStyle(fontSize: 14.sp),
              button: TextStyle(fontSize: 14.sp),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: Pallette.borderRadius,
                ),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 13.0,
                horizontal: 7.0,
              ),
              filled: true,
              fillColor: Colors.grey.shade200,
              border: OutlineInputBorder(
                borderRadius: Pallette.borderRadius,
              ),
            ),
          ),
          // home: const NavigationScreen(),
          home: FutureBuilder(
            future: _futureSplash,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return const NavigationScreen();
              }

              return const SplashScreen();
            },
          ),
        ),
      ),
    );
  }
}
