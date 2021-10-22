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

class _NavigationScreenState extends State<NavigationScreen> {
  final List<Widget> screens = const [
    HomeScreen(),
    MusicScreen(),
    MusicScreen(),
  ];
  late AudioPlayerBloc _audioPlayerBloc;
  int _curIndex = 0;

  @override
  void initState() {
    _audioPlayerBloc = BlocProvider.of<AudioPlayerBloc>(context);

    super.initState();
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

  void _audioPlayerListener(BuildContext context, AudioPlayerState state) {
    if (state is AudioPlayerInitialized) {
      print(state.audioState);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Stack(
            children: screens
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
                  return AudioPlayerBox(
                    onPlayPause: _playPauseAction,
                    progress: state.audioProgress,
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
