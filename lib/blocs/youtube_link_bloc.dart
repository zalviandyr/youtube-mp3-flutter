import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_mp3/blocs/blocs.dart';
import 'package:youtube_mp3/models/models.dart';

class YoutubeLinkBloc extends Bloc<YoutubeLinkEvent, YoutubeLinkState> {
  YoutubeLinkBloc() : super(YoutubeLinkUninitialized()) {
    on<YoutubeLinkSearch>((event, emit) async {
      emit(YoutubeLinkLoading());

      try {
        YoutubeExplode yt = YoutubeExplode();
        Video video = await yt.videos.get(event.link);
        VideoId id = video.id;

        // get video manifest
        StreamManifest manifest = await yt.videos.streamsClient.getManifest(id);
        AudioOnlyStreamInfo audio = manifest.audioOnly.withHighestBitrate();

        yt.close();

        String twoDigits(int? n) => n?.toString().padLeft(2, '0') ?? '00';
        String minute = twoDigits(video.duration?.inMinutes.remainder(60));
        String second = twoDigits(video.duration?.inSeconds.remainder(60));

        emit(YoutubeLinkSearchSuccess(
          downloadAudio: DownloadAudioModel(
            id: video.id.value,
            thumbnails: video.thumbnails,
            title: video.title,
            duration: minute + ':' + second,
            size: audio.size.totalMegaBytes.toStringAsFixed(2),
          ),
        ));
      } catch (err) {
        log(err.toString(), name: 'YoutubeLinkSearch');

        emit(YoutubeLinkError());
      }
    });
  }
}
