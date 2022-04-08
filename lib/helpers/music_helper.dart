import 'dart:io';
import 'dart:typed_data';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_mp3/models/models.dart';

class MusicHelper {
  final AssetsAudioPlayer player;
  final List<MusicModel> musics = [];
  bool canNextPrev = true;
  int _indexToPlay = 0;

  MusicHelper._internal() : player = AssetsAudioPlayer();

  static final MusicHelper _instance = MusicHelper._internal();

  static MusicHelper get instance => _instance;

  int get index => musics
      .indexWhere((elm) => elm.path == player.current.value?.audio.audio.path);

  void initPlaylist(List<MusicModel> musicsModel) {
    musics.clear();
    musics.addAll(musicsModel);
  }

  Future<void> playAtIndex(MusicModel music) async {
    _indexToPlay = musics.indexWhere((elm) => elm.path == music.path);

    await player.stop();
    Playlist playlist = Playlist();
    for (MusicModel item in musics) {
      Audio audio = Audio.file(item.path);

      playlist.add(audio);
      await _initMetadata(item, audio);
    }

    await player.open(
      playlist,
      showNotification: true,
      loopMode: LoopMode.playlist,
      autoStart: false,
      notificationSettings: NotificationSettings(
        stopEnabled: false,
        customNextAction: (player) async {
          await nextAction();
        },
        customPrevAction: (player) async {
          await prevAction();
        },
      ),
    );

    await player.playlistPlayAtIndex(_indexToPlay);
  }

  Future<void> nextAction() async {
    if (canNextPrev) {
      canNextPrev = false;
      await player.next();
      canNextPrev = true;
    }
  }

  Future<void> prevAction() async {
    if (canNextPrev) {
      canNextPrev = false;
      List<Audio>? audios = player.playlist?.audios;

      if (index == 0 && audios != null) {
        int lastIndex = audios.length - 1;
        await player.playlistPlayAtIndex(lastIndex);
      } else {
        await player.previous();
      }
      canNextPrev = true;
    }
  }

  Future<void> _initMetadata(MusicModel music, Audio audio) async {
    String title = music.title;
    String image = await _writeTempImage(music.thumbnails, title);

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
