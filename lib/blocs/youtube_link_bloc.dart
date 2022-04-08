import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_mp3/blocs/blocs.dart';
import 'package:youtube_mp3/helpers/string_helper.dart';
import 'package:youtube_mp3/models/models.dart';

class YoutubeLinkBloc extends Bloc<YoutubeLinkEvent, YoutubeLinkState> {
  YoutubeLinkBloc() : super(YoutubeLinkUninitialized()) {
    on<YoutubeLinkSearch>(_onYoutubeLinkSearch);
  }

  Future<void> _onYoutubeLinkSearch(
      YoutubeLinkSearch event, Emitter<YoutubeLinkState> emit) async {
    emit(YoutubeLinkLoading());

    try {
      YoutubeExplode yt = YoutubeExplode();
      Video video = await yt.videos.get(event.link);
      VideoId id = video.id;

      // get video manifest
      StreamManifest manifest = await yt.videos.streamsClient.getManifest(id);
      AudioOnlyStreamInfo audio = manifest.audioOnly.withHighestBitrate();

      yt.close();

      emit(YoutubeLinkSearchSuccess(
        downloadAudioModel: DownloadAudioModel(
          id: video.id.value,
          thumbnails: video.thumbnails,
          title: video.title,
          duration: durationToString(video.duration!),
          size: audio.size.totalMegaBytes.toStringAsFixed(2),
        ),
      ));
    } catch (err, stackTrace) {
      Sentry.captureException(err, stackTrace: stackTrace);

      log(err.toString(), name: 'YoutubeLinkSearch');

      emit(YoutubeLinkError());
    }
  }
}
