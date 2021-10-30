import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:youtube_mp3/blocs/blocs.dart';
import 'package:youtube_mp3/models/models.dart';

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
  late AudioPlayerBloc _audioPlayerBloc;
  late AudioPlayerInitialized _audioState;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late int _initialPage;
  late double _initialOffset;

  @override
  void initState() {
    _audioPlayerBloc = BlocProvider.of<AudioPlayerBloc>(context);

    AudioPlayerState state = _audioPlayerBloc.state;
    if (state is AudioPlayerInitialized) {
      _audioState = state;

      _initialPage = state.musics.indexWhere((elm) => elm == state.music);
      _initialOffset = 10000.0 + _initialPage;
    }

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation =
        Tween<double>(begin: 1.0, end: 0.5).animate(_animationController);

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  void _nextAction({bool animateCarousel = false}) {
    if (animateCarousel) {
      _carouselController.nextPage();
    }

    _audioPlayerBloc.add(AudioPlayerNext());

    _animationController.forward().then((_) => _animationController.reverse());
  }

  void _prevAction({bool animateCarousel = false}) {
    if (animateCarousel) {
      _carouselController.previousPage();
    }

    _audioPlayerBloc.add(AudioPlayerPrev());

    _animationController.forward().then((_) => _animationController.reverse());
  }

  void _onCarouselPageChange(int index, CarouselPageChangedReason reason) {
    double? offsetNextPrev = _carouselController.pageController.page;

    if (offsetNextPrev != null) {
      if (reason == CarouselPageChangedReason.manual) {
        if (_initialOffset > offsetNextPrev) {
          _prevAction();
        } else if (_initialOffset < offsetNextPrev) {
          _nextAction();
        }
      }

      _initialOffset = offsetNextPrev;
    }
  }

  void _audioListener(BuildContext context, AudioPlayerState state) {
    if (state is AudioPlayerInitialized) {
      setState(() => _audioState = state);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AudioPlayerBloc, AudioPlayerState>(
      listener: _audioListener,
      child: Stack(
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
                itemCount: _audioState.musics.length,
                itemBuilder: (context, itemIndex, pageViewIndex) {
                  MusicModel music = _audioState.musics[itemIndex];

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(7.0),
                    child: Image.memory(
                      music.thumbnails,
                      width: 250.w,
                      height: 250.0,
                      fit: BoxFit.cover,
                    ),
                  );
                },
                options: CarouselOptions(
                  initialPage: _initialPage,
                  onPageChanged: _onCarouselPageChange,
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
                      child: Marquee(
                        text: _audioState.music.title,
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
                      stream: _audioState.audioProgress,
                      builder: (context,
                          AsyncSnapshot<Map<String, dynamic>> snapshot) {
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
                          child: FaIcon(
                            _audioState.audioState == AudioStateEnum.playing
                                ? FontAwesomeIcons.pause
                                : FontAwesomeIcons.play,
                            color: Colors.white,
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
      ),
    );
  }

  List<Widget> _buildBackground() {
    return [
      Positioned.fill(
        child: ClipRRect(
          borderRadius: widget.borderRadius,
          child: FadeTransition(
            opacity: _animation,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Image.memory(
                _audioState.music.thumbnails,
                fit: BoxFit.fitHeight,
                color: Colors.grey.withOpacity(.3),
                colorBlendMode: BlendMode.colorBurn,
              ),
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
