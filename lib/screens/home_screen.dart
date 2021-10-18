import 'package:flutter/material.dart';
import 'package:youtube_mp3/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _searchAction() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: kToolbarHeight, left: 10.0, right: 10.0),
              child: searchYoutubeBar(),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 22.0, left: 10.0, right: 10.0),
              child: Text('Download progress'),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return const DownloadItem();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget searchYoutubeBar() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 47.0,
            child: TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.link, size: 28.0),
              ),
            ),
          ),
        ),
        const SizedBox(width: 17.0),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size.fromHeight(47.0),
          ),
          onPressed: _searchAction,
          child: const Icon(Icons.search, size: 28.0),
        ),
      ],
    );
  }
}
