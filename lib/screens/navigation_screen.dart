import 'package:flutter/material.dart';
import 'package:youtube_mp3/screens/screens.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final List<Widget> screens = const [
    HomeScreen(),
    PlaylistScreen(),
  ];
  int _curIndex = 0;

  void _navAction(int index) {
    setState(() => _curIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: screens
            .asMap()
            .entries
            .map((e) => Offstage(
                  offstage: e.key != _curIndex,
                  child: e.value,
                ))
            .toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _curIndex,
        onTap: _navAction,
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Playlist',
            icon: Icon(Icons.play_circle),
          ),
        ],
      ),
    );
  }
}
