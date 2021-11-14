import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youtube_mp3/blocs/blocs.dart';
import 'package:youtube_mp3/views/pallette.dart';
import 'package:youtube_mp3/views/screens/screens.dart';
import 'package:youtube_mp3/views/widgets/widgets.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final PageController _pageController = PageController();
  final List<Widget> _screens = const [
    HomeScreen(),
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
    _pageController.dispose();

    super.dispose();
  }

  void _navAction(int index) {
    if (index < 2) {
      _pageController.animateToPage(
        index,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 200),
      );
    } else {
      _key.currentState!.openEndDrawer();
    }
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

  void _showAudioPlayerAction() {
    showModalBottomSheet(
      context: context,
      constraints: const BoxConstraints(maxHeight: 550),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: Pallette.modalBorderRadius,
      ),
      builder: (context) {
        return AudioPlayerModal(
          borderRadius: Pallette.modalBorderRadius,
          playPauseAction: _playPauseAction,
        );
      },
    );
  }

  void _languageSettingAction() {
    showModalBottomSheet(
      context: context,
      constraints:
          const BoxConstraints(minHeight: 550, minWidth: double.infinity),
      // backgroundColor: Colors.transparent,
      // isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: Pallette.modalBorderRadius,
      ),
      builder: (context) {
        return const LanguageModal();
      },
    );
  }

  void _audioPlayerListener(BuildContext context, AudioPlayerState state) {
    if (state is AudioPlayerInitialized) {
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: _screens,
            onPageChanged: (index) => setState(() => _curIndex = index),
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
                      onDetail: _showAudioPlayerAction,
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
      endDrawer: AppDrawer(
        onLanguageSetting: _languageSettingAction,
      ),
      endDrawerEnableOpenDragGesture: false,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _curIndex,
        onTap: _navAction,
        elevation: 20.0,
        items: [
          BottomNavigationBarItem(
            label: 'home'.tr(),
            icon: const FaIcon(
              FontAwesomeIcons.home,
              size: 20.0,
            ),
          ),
          BottomNavigationBarItem(
            label: 'music'.tr(),
            icon: const FaIcon(
              FontAwesomeIcons.music,
              size: 20.0,
            ),
          ),
          BottomNavigationBarItem(
            label: 'more'.tr(),
            icon: const FaIcon(
              FontAwesomeIcons.ellipsisH,
              size: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}
