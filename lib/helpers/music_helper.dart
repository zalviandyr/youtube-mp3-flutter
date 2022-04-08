import 'dart:io';
import 'dart:typed_data';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_mp3/models/models.dart';

class MusicHelper {
  final AssetsAudioPlayer player;
  final List<File> musics = [];
  int _indexToPlay = 0;

  MusicHelper._internal() : player = AssetsAudioPlayer();

  static final MusicHelper _instance = MusicHelper._internal();

  static MusicHelper get instance => _instance;

  int get index => musics
      .indexWhere((elm) => elm.path == player.current.value?.audio.audio.path);

  Future<void> playAtIndex(MusicModel music) async {
    Directory dir = (await getExternalStorageDirectory())!;
    musics.clear();
    musics.addAll(dir.listSync().map((e) => File(e.path)).toList());
    _indexToPlay = musics.indexWhere((elm) => elm.path == music.path);

    await player.stop();
    Playlist playlist = Playlist();
    for (File item in musics) {
      Audio audio = Audio.file(item.path);

      playlist.add(audio);
      await _initMetadata(audio);
    }

    await player.open(
      playlist,
      // showNotification: true,
      loopMode: LoopMode.playlist,
      autoStart: false,
    );

    await player.playlistPlayAtIndex(_indexToPlay);
  }

  Future<void> _initMetadata(Audio audio) async {
    Metadata metadata = await MetadataRetriever.fromFile(File(audio.path));
    String title = metadata.trackName ?? 'no_title'.tr();
    String image = await _writeTempImage(metadata.albumArt, title);

    audio.updateMetas(
      title: title,
      image: MetasImage.file(image),
    );
  }

  Future<String> _writeTempImage(Uint8List? uint8list, String filename) async {
    String tempPath = (await getTemporaryDirectory()).path;
    String path = tempPath + Platform.pathSeparator + filename;
    File file = File(path);

    if (!file.existsSync() && uint8list != null) {
      file.writeAsBytesSync(uint8list);
    }

    return path;
  }
}
