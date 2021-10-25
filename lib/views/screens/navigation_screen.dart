import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youtube_mp3/blocs/blocs.dart';
import 'package:youtube_mp3/views/screens/screens.dart';
import 'package:youtube_mp3/views/widgets/widgets.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen>
    with SingleTickerProviderStateMixin {
  final List<Widget> _screens = const [
    HomeScreen(),
    MusicScreen(),
    MusicScreen(),
  ];
  late AnimationController _animationController;
  late AudioPlayerBloc _audioPlayerBloc;
  int _curIndex = 0;

  @override
  void initState() {
    // bloc
    _audioPlayerBloc = BlocProvider.of<AudioPlayerBloc>(context);

    // animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  void _navAction(int index) {
    setState(() => _curIndex = index);
  }

  void _playPauseAction() {
    AudioPlayerState state = _audioPlayerBloc.state;
    if (state is AudioPlayerInitialized) {
      if (state.audioState == AudioStateEnum.playing) {
        _audioPlayerBloc.add(AudioPlayerPause());
      } else if (state.audioState == AudioStateEnum.pausing) {
        _audioPlayerBloc.add(const AudioPlayerPlay());
      }
    }
  }

  void _toAudioPlayerAction() {
    BorderRadius borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(10.0),
      topRight: Radius.circular(10.0),
    );

    AudioPlayerState state = _audioPlayerBloc.state;
    if (state is AudioPlayerInitialized) {
      showModalBottomSheet(
        context: context,
        constraints: const BoxConstraints(maxHeight: 550),
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
        builder: (context) {
          return AudioPlayerModal(
            borderRadius: borderRadius,
            music: state.music,
            progress: state.audioProgress,
          );
        },
      );
    }
  }

  void _audioPlayerListener(BuildContext context, AudioPlayerState state) {
    if (state is AudioPlayerInitialized) {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Stack(
            children: _screens
                .asMap()
                .entries
                .map((e) => Offstage(
                      offstage: e.key != _curIndex,
                      child: e.value,
                    ))
                .toList(),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: BlocConsumer<AudioPlayerBloc, AudioPlayerState>(
              listener: _audioPlayerListener,
              builder: (context, state) {
                if (state is AudioPlayerInitialized) {
                  return AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return ScaleTransition(
                        scale: CurvedAnimation(
                          parent: _animationController,
                          curve: Curves.easeInOut,
                        ),
                        child: child,
                      );
                    },
                    child: AudioPlayerBox(
                      onPlayPause: _playPauseAction,
                      onDetail: _toAudioPlayerAction,
                      progress: state.audioProgress,
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _curIndex,
        onTap: _navAction,
        elevation: 20.0,
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: FaIcon(
              FontAwesomeIcons.home,
              size: 20.0,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Music',
            icon: FaIcon(
              FontAwesomeIcons.music,
              size: 20.0,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: FaIcon(
              FontAwesomeIcons.solidUser,
              size: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}
