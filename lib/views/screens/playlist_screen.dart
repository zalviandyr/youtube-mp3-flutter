import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youtube_mp3/blocs/blocs.dart';
import 'package:youtube_mp3/models/models.dart';
import 'package:youtube_mp3/views/widgets/widgets.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({Key? key}) : super(key: key);

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  final TextEditingController _searchController = TextEditingController();
  late MusicBloc _musicBloc;

  @override
  void initState() {
    _musicBloc = BlocProvider.of<MusicBloc>(context);

    _musicBloc.add(MusicFetch());

    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  void _searchAction(String value) {
    FocusScope.of(context).unfocus();

    if (value.isNotEmpty) {
      print(value);
    }
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
              child: _buildSearchBar(),
            ),
          ),
          BlocBuilder<MusicBloc, MusicState>(builder: (context, state) {
            return SliverPadding(
              padding: const EdgeInsets.only(top: 10.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (state is MusicInitialized) {
                      MusicModel music = state.musics[index];
                      return MusicItem(musicModel: music);
                    }

                    return const SizedBox.shrink();
                  },
                  childCount:
                      state is MusicInitialized ? state.musics.length : 0,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return SizedBox(
      height: 47.0,
      child: TextFormField(
        controller: _searchController,
        onFieldSubmitted: _searchAction,
        decoration: const InputDecoration(
          prefixIcon: Padding(
            padding: EdgeInsets.all(12.0),
            child: FaIcon(FontAwesomeIcons.search, size: 21.0),
          ),
        ),
      ),
    );
  }
}
