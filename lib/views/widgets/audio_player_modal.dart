import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:youtube_mp3/blocs/blocs.dart';
import 'package:youtube_mp3/models/models.dart';

class AudioPlayerModal extends StatelessWidget {
  final BorderRadius borderRadius;
  final MusicModel music;
  final Stream<Map<String, dynamic>>? progress;

  const AudioPlayerModal({
    Key? key,
    required this.borderRadius,
    required this.music,
    required this.progress,
  }) : super(key: key);

  void _playPauseAction() {
    AudioPlayerBloc audioPlayerBloc =
        BlocProvider.of<AudioPlayerBloc>(Get.context!);
    AudioPlayerState state = audioPlayerBloc.state;

    if (state is AudioPlayerInitialized) {
      if (state.audioState == AudioStateEnum.playing) {
        audioPlayerBloc.add(AudioPlayerPause());
      } else if (state.audioState == AudioStateEnum.pausing) {
        audioPlayerBloc.add(const AudioPlayerPlay());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ..._buildBackground(),
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Transform.rotate(
                      angle: 1.5,
                      child: const FaIcon(
                        FontAwesomeIcons.angleRight,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(7.0),
                child: Image.memory(
                  music.thumbnails,
                  width: 250.w,
                  height: 250.0,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                height: 30.0,
                width: double.infinity,
                child: Marquee(
                  text: music.title,
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Colors.white),
                  accelerationDuration: const Duration(seconds: 1),
                  fadingEdgeStartFraction: 0.1,
                  fadingEdgeEndFraction: 0.1,
                  blankSpace: 30.0,
                ),
              ),
              const SizedBox(height: 30.0),
              StreamBuilder(
                stream: progress,
                builder:
                    (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  return Column(
                    children: [
                      LinearProgressIndicator(
                        value: snapshot.data?['progress'],
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            snapshot.data?['totDuration'] ?? '',
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            snapshot.data?['curDuration'] ?? '',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      shadowColor: Colors.transparent,
                      minimumSize: const Size(50, 50),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.backward,
                      color: Colors.white,
                    ),
                  ),
                  BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
                    builder: (context, state) {
                      if (state is AudioPlayerInitialized) {
                        return ElevatedButton(
                          onPressed: _playPauseAction,
                          style: ElevatedButton.styleFrom(
                            primary: Colors.grey.withOpacity(.3),
                            minimumSize: const Size(50, 50),
                          ),
                          child: FaIcon(
                            state.audioState == AudioStateEnum.playing
                                ? FontAwesomeIcons.pause
                                : FontAwesomeIcons.play,
                            color: Colors.white,
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      shadowColor: Colors.transparent,
                      minimumSize: const Size(50, 50),
                    ),
                    child: const FaIcon(
                      FontAwesomeIcons.forward,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildBackground() {
    return [
      Positioned.fill(
        child: ClipRRect(
          borderRadius: borderRadius,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Image.memory(
              music.thumbnails,
              fit: BoxFit.fitHeight,
              color: Colors.grey.withOpacity(.3),
              colorBlendMode: BlendMode.colorBurn,
            ),
          ),
        ),
      ),
      Positioned.fill(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(.7),
              ],
            ),
          ),
        ),
      ),
    ];
  }
}
