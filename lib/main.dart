import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:youtube_mp3/blocs/blocs.dart';
import 'package:youtube_mp3/utils/utils.dart';
import 'package:youtube_mp3/views/pallette.dart';
import 'package:youtube_mp3/views/screens/screens.dart';

// TODO: add home screen tutorial
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DependencyInjection.setup();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppLocalization _localization = GetIt.I<AppLocalization>();
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: () => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => YoutubeLinkBloc()),
          BlocProvider(create: (_) => DownloadAudioBloc()),
          BlocProvider(create: (_) => MusicBloc()),
          BlocProvider(create: (_) => AudioPlayerBloc()),
        ],
        child: GetMaterialApp(
          title: _localization.translate('app_name'),
          theme: ThemeData(
            fontFamily: 'JosefinSans',
            scaffoldBackgroundColor: Pallette.scaffoldBackground,
            colorScheme: const ColorScheme.light(
              primary: Pallette.primaryColor,
              secondary: Pallette.secondaryColor,
            ),
            textTheme: TextTheme(
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
          home: const NavigationScreen(),
        ),
      ),
    );
  }
}
