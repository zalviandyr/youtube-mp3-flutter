import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquee/marquee.dart';
import 'package:youtube_mp3/blocs/blocs.dart';

class AudioPlayerBox extends StatelessWidget {
  final VoidCallback onPlayPause;
  final Stream<double>? progress;

  const AudioPlayerBox({
    Key? key,
    required this.onPlayPause,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(7.0),
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
              BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
                builder: (context, state) {
                  return Expanded(
                    child: SizedBox(
                      height: 30.0,
                      child: Marquee(
                        text: state is AudioPlayerInitialized
                            ? state.music.title
                            : '',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.white),
                        accelerationDuration: const Duration(seconds: 1),
                        fadingEdgeStartFraction: 0.1,
                        fadingEdgeEndFraction: 0.1,
                        blankSpace: 30.0,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 15.0),
              GestureDetector(
                onTap: onPlayPause,
                child: BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
                  builder: (context, state) {
                    if (state is AudioPlayerInitialized) {
                      return FaIcon(
                        state.audioState == AudioStateEnum.playing
                            ? FontAwesomeIcons.solidPauseCircle
                            : FontAwesomeIcons.solidPlayCircle,
                        size: 30.0,
                        color: Colors.white,
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),
          StreamBuilder(
            stream: progress,
            builder: (context, AsyncSnapshot<double> snapshot) {
              return LinearProgressIndicator(
                value: snapshot.data,
                backgroundColor: Theme.of(context).colorScheme.primary,
                color: Colors.white,
              );
            },
          ),
        ],
      ),
    );
  }
}
