import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquee/marquee.dart';
import 'package:youtube_mp3/helpers/music_helper.dart';
import 'package:youtube_mp3/views/pallette.dart';

class AudioPlayerBox extends StatelessWidget {
  final MusicHelper _musicHelper = MusicHelper.instance;
  final VoidCallback onPlayPause;
  final VoidCallback onDetail;

  AudioPlayerBox({
    Key? key,
    required this.onPlayPause,
    required this.onDetail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDetail,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: Pallette.borderRadius,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2.0,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 30.0,
                    child: PlayerBuilder.current(
                      player: _musicHelper.player,
                      builder: (context, playing) {
                        return Marquee(
                          text: playing.audio.audio.metas.title ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.white),
                          accelerationDuration: const Duration(seconds: 1),
                          fadingEdgeStartFraction: 0.1,
                          fadingEdgeEndFraction: 0.1,
                          blankSpace: 30.0,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 15.0),
                GestureDetector(
                  onTap: onPlayPause,
                  child: PlayerBuilder.playerState(
                    player: _musicHelper.player,
                    builder: (context, state) {
                      return FaIcon(
                        state == PlayerState.play
                            ? FontAwesomeIcons.solidPauseCircle
                            : FontAwesomeIcons.solidPlayCircle,
                        size: 30.0,
                        color: Colors.white,
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            PlayerBuilder.realtimePlayingInfos(
              player: _musicHelper.player,
              builder: (context, info) {
                double progress = info.currentPosition.inSeconds /
                    (info.current?.audio.duration.inSeconds ?? 0);

                return LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  color: Colors.white,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
