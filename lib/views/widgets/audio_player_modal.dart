import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';
import 'package:youtube_mp3/blocs/blocs.dart';

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
  late AudioPlayerBloc _audioPlayerBloc;
  late AudioPlayerInitialized _audioState;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    _audioPlayerBloc = BlocProvider.of<AudioPlayerBloc>(context);

    AudioPlayerState state = _audioPlayerBloc.state;
    if (state is AudioPlayerInitialized) {
      _audioState = state;
    }

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_animationController);

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  void _nextAction() {
    _audioPlayerBloc.add(AudioPlayerNext());

    _animationController.forward().then((_) => _animationController.reverse());
  }

  void _prevAction() {
    _audioPlayerBloc.add(AudioPlayerPrev());

    _animationController.forward().then((_) => _animationController.reverse());
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
                  child: FadeTransition(
                    opacity: _animation,
                    child: Image.memory(
                      _audioState.music.thumbnails,
                      width: 250.w,
                      height: 250.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
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
                      onPressed: _prevAction,
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
                      onPressed: _nextAction,
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
