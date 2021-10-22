import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  int _curIndex = 0;

  void _navAction(int index) {
    setState(() => _curIndex = index);
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
            child: AudioPlayer(
              onPlay: () {
                showSnackbar('ddasdasd');
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
