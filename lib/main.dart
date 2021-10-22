import 'dart:async';
import 'dart:io';

import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full/return_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_mp3/blocs/blocs.dart';
import 'package:youtube_mp3/views/screens/screens.dart';

// TODO: add home screen tutorial
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
          title: 'Youtube Mp3',
          theme: ThemeData(
            fontFamily: 'JosefinSans',
            scaffoldBackgroundColor: const Color(0xFFF3F2F3),
            colorScheme: const ColorScheme.light(
              // primary: Color(0xFFEE6C4D),
              primary: Color(0xFF09A4DB),
              secondary: Color(0xFF98C1D9),
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
                  borderRadius: BorderRadius.circular(7.0),
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
                borderRadius: BorderRadius.circular(7.0),
              ),
            ),
          ),
          home: const NavigationScreen(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // void _youtubeAction() async {
  //   String path = (await getExternalStorageDirectory())!.path + "/test.mp3";
  //   String pathMetadata =
  //       (await getExternalStorageDirectory())!.path + "/test2.mp3";

  //   print(pathMetadata);
  //   if (await File(pathMetadata).exists()) {
  //     await File(pathMetadata).delete();
  //   }

  //   YoutubeExplode yt = YoutubeExplode();
  //   Video video =
  //       await yt.videos.get('https://www.youtube.com/watch?v=49Bd5_WgRp0');
  //   VideoId id = video.id;
  //   print('get video id');
  //   print('get video thumb: ${video.thumbnails.highResUrl}');

  //   StreamManifest manifest = await yt.videos.streamsClient.getManifest(id);
  //   AudioOnlyStreamInfo audio = manifest.audioOnly.withHighestBitrate();
  //   print('get manifest');

  //   Stream stream = yt.videos.streamsClient.get(audio);
  //   int size = audio.size.totalBytes;
  //   File file = File(path);
  //   IOSink fileStream = file.openWrite(mode: FileMode.writeOnly);

  //   // await stream.pipe(fileStream);
  //   await for (var byteList in stream) {
  //     fileStream.add(byteList);

  //     int progress = ((file.lengthSync() / size) * 100).toInt();
  //     print(progress);
  //   }

  //   print('selesai');
  //   await fileStream.flush();
  //   await fileStream.close();
  //   yt.close();

  //   // set metadata
  //   List<String> arguments = [
  //     '-i $path',
  //     '-i ${video.thumbnails.highResUrl}',
  //     '-map 0 -map 1',
  //     '-c:v:1 png',
  //     '-c:a:0 mp3',
  //     '-disposition:v:1 attached_pic',
  //     '-metadata title="${video.title}"',
  //     pathMetadata
  //   ];

  //   FFmpegKit.executeAsync(
  //     arguments.join(' '),
  //     (session) async {
  //       ReturnCode? code = (await session.getReturnCode());

  //       print(session.getArguments()!.join(' '));
  //       if (ReturnCode.isSuccess(code)) {
  //         print('sukses');
  //         print('create file $pathMetadata');
  //         print('delete file $path');
  //         await File(path).delete();
  //       }
  //     },
  //     (log) {
  //       print(log.getMessage());
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
    );
  }
}
