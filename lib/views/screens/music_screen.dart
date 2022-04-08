import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youtube_mp3/blocs/blocs.dart';
import 'package:youtube_mp3/helpers/music_helper.dart';
import 'package:youtube_mp3/models/models.dart';
import 'package:youtube_mp3/views/widgets/widgets.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({Key? key}) : super(key: key);

  @override
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen>
    with AutomaticKeepAliveClientMixin<MusicScreen> {
  final MusicHelper _musicHelper = MusicHelper.instance;
  late MusicBloc _musicBloc;
  double _paddingBottom = 10.0;

  @override
  void initState() {
    // bloc
    _musicBloc = BlocProvider.of<MusicBloc>(context);

    MusicState state = _musicBloc.state;
    if (state is! MusicInitialized) {
      _musicBloc.add(MusicFetch());
    }

    _musicHelper.player.current.listen((event) {
      if (event != null) {
        setState(() => _paddingBottom = 100.0);
      }
    });

    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  void _onChangedSearch(String value) {
    _musicBloc.add(MusicSearch(keyword: value));
  }

  void _musicAction(MusicModel music) {
    _musicHelper.playAtIndex(music);
  }

  void _musicListener(BuildContext context, MusicState state) {
    if (state is MusicInitialized) {
      _musicHelper.initPlaylist(state.musics);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocListener<MusicBloc, MusicState>(
      listener: _musicListener,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: kToolbarHeight, left: 10.0, right: 10.0),
                child: _buildSearchBar(),
              ),
            ),
            BlocBuilder<MusicBloc, MusicState>(
              builder: (context, state) {
                return SliverPadding(
                  padding: EdgeInsets.only(top: 10.0, bottom: _paddingBottom),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (state is MusicInitialized) {
                          MusicModel music = state.musics[index];
                          return MusicItem(
                            musicModel: music,
                            onTap: _musicAction,
                          );
                        }

                        return const SizedBox.shrink();
                      },
                      childCount:
                          state is MusicInitialized ? state.musics.length : 0,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SizedBox(
      height: 47.0,
      child: TextFormField(
        onChanged: _onChangedSearch,
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
