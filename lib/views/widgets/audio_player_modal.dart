import 'dart:io';
import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:youtube_mp3/helpers/music_helper.dart';
import 'package:youtube_mp3/helpers/string_helper.dart';
import 'package:youtube_mp3/views/pallette.dart';

class AudioPlayerModal extends StatefulWidget {
  final BorderRadius borderRadius;
  final VoidCallback playPauseAction;

  const AudioPlayerModal({
    Key? key,
    required this.borderRadius,
    required this.playPauseAction,
  }) : super(key: key);

  @override
  State<AudioPlayerModal> createState() => _AudioPlayerModalState();
}

class _AudioPlayerModalState extends State<AudioPlayerModal>
    with SingleTickerProviderStateMixin {
  final CarouselController _carouselController = CarouselController();
  final MusicHelper _musicHelper = MusicHelper.instance;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late int _initialPage;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation =
        Tween<double>(begin: 1.0, end: 0.5).animate(_animationController);

    _initialPage = _musicHelper.index;

    _musicHelper.player.current.listen(_currentListen);

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  /// Handle carousel when audio finish or next
  void _currentListen(Playing? playing) {
    int index = _musicHelper.index;
    if (index != _initialPage &&
        _carouselController.pageController.positions.isNotEmpty) {
      _carouselController.nextPage();
    }

    _initialPage = index;
  }

  Future<void> _nextAction({bool animateCarousel = false}) async {
    if (_musicHelper.canNextPrev) {
      // handle skip twice when user tap next button
      bool isLastIndex = _musicHelper.index == _musicHelper.musics.length - 1;

      if (isLastIndex) {
        _initialPage = 0;
      } else {
        _initialPage++;
      }

      if (animateCarousel) {
        await _carouselController.nextPage();
      }

      await _musicHelper.nextAction();

      await _animationController.forward();
      await _animationController.reverse();
    }
  }

  Future<void> _prevAction({bool animateCarousel = false}) async {
    if (_musicHelper.canNextPrev) {
      // handle skip twice when user tap prev button
      bool isFirstIndex = _musicHelper.index == 0;

      if (isFirstIndex) {
        _initialPage = _musicHelper.musics.length - 1;
      } else {
        _initialPage--;
      }

      if (animateCarousel) {
        await _carouselController.previousPage();
      }

      await _musicHelper.prevAction();

      await _animationController.forward();
      await _animationController.reverse();
    }
  }

  Future<void> _onCarouselNext(CarouselPageChangedReason reason) async {
    if (reason == CarouselPageChangedReason.manual) {
      await _nextAction();
    }
  }

  Future<void> _onCarouselPrev(CarouselPageChangedReason reason) async {
    if (reason == CarouselPageChangedReason.manual) {
      await _prevAction();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ..._buildBackground(),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: GestureDetector(
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
            ),
            const SizedBox(height: 10.0),
            CarouselSlider.builder(
              carouselController: _carouselController,
              itemCount: _musicHelper.musics.length,
              itemBuilder: (context, itemIndex, pageViewIndex) {
                String? image = _musicHelper
                    .player.playlist?.audios[itemIndex].metas.image?.path;

                return ClipRRect(
                  borderRadius: Pallette.borderRadius,
                  child: Image.file(
                    File(image!),
                    width: 250.w,
                    height: 250.0,
                    fit: BoxFit.cover,
                  ),
                );
              },
              options: CarouselOptions(
                initialPage: _initialPage,
                onCarouselNext: _onCarouselNext,
                onCarouselPrev: _onCarouselPrev,
                viewportFraction: 0.75,
                enlargeCenterPage: true,
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 30.0,
                    width: double.infinity,
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
                  const SizedBox(height: 30.0),
                  PlayerBuilder.realtimePlayingInfos(
                    player: _musicHelper.player,
                    builder: (context, info) {
                      double progress = info.currentPosition.inSeconds /
                          info.duration.inSeconds;

                      return Column(
                        children: [
                          Slider(
                            value: progress,
                            inactiveColor: Colors.white,
                            onChanged: (value) {
                              double duration = value * info.duration.inSeconds;
                              _musicHelper.player
                                  .seek(Duration(seconds: duration.toInt()));
                            },
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                durationToString(info.duration),
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                durationToString(info.currentPosition),
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
                        onPressed: () => _prevAction(animateCarousel: true),
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
                      ElevatedButton(
                        onPressed: widget.playPauseAction,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey.withOpacity(.3),
                          minimumSize: const Size(50, 50),
                        ),
                        child: PlayerBuilder.realtimePlayingInfos(
                          player: _musicHelper.player,
                          builder: (context, info) {
                            return FaIcon(
                              info.isPlaying
                                  ? FontAwesomeIcons.pause
                                  : FontAwesomeIcons.play,
                              color: Colors.white,
                            );
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _nextAction(animateCarousel: true),
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
        ),
      ],
    );
  }

  List<Widget> _buildBackground() {
    return [
      Positioned.fill(
        child: ClipRRect(
          borderRadius: widget.borderRadius,
          child: FadeTransition(
            opacity: _animation,
            child: PlayerBuilder.current(
                player: _musicHelper.player,
                builder: (context, playing) {
                  String? image = playing.audio.audio.metas.image?.path;

                  return ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Image.file(
                      File(image!),
                      fit: BoxFit.fitHeight,
                      color: Colors.grey.withOpacity(.3),
                      colorBlendMode: BlendMode.colorBurn,
                    ),
                  );
                }),
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
