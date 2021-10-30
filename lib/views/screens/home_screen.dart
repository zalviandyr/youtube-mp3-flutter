import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_mp3/blocs/blocs.dart';
import 'package:youtube_mp3/models/models.dart';
import 'package:youtube_mp3/views/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  final TextEditingController _linkController = TextEditingController();
  final GlobalKey<SliverAnimatedListState> _listKey = GlobalKey();
  final List<DownloadAudioModel> _listDownloadAudioModel = [];
  late YoutubeLinkBloc _youtubeLinkBloc;
  late DownloadAudioBloc _downloadAudioBloc;
  late MusicBloc _musicBloc;

  @override
  void initState() {
    print('home screen');
    _youtubeLinkBloc = BlocProvider.of<YoutubeLinkBloc>(context);
    _downloadAudioBloc = BlocProvider.of<DownloadAudioBloc>(context);
    _musicBloc = BlocProvider.of<MusicBloc>(context);

    // _setListDownloadAudioModel();

    super.initState();
  }

  @override
  void dispose() {
    _linkController.dispose();

    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  void _setListDownloadAudioModel() {
    DownloadAudioState state = _downloadAudioBloc.state;
    if (state is DownloadAudioProgress) {
      _listDownloadAudioModel.clear();
      _listDownloadAudioModel.addAll(state.listDownloadAudio);
    }
  }

  void _pasteAction() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);

    if (data != null) {
      _linkController.text = data.text ?? '';
    }
  }

  void _searchAction() async {
    FocusScope.of(context).unfocus();

    if (await Permission.storage.request().isGranted) {
      String link = _linkController.text;
      if (link.isNotEmpty) {
        _youtubeLinkBloc.add(YoutubeLinkSearch(link: link));
      }
    }
  }

  void _downloadAction(DownloadAudioModel downloadAudioModel) {
    _linkController.text = '';

    _downloadAudioBloc
        .add(DownloadAudioSubmit(downloadAudioModel: downloadAudioModel));
  }

  void _cancelDownloadAction(DownloadAudioModel downloadAudioModel) {
    showAnimationDialog(
      dialog: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
        content: const Text('Are your sure to want cancel it ?'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();

              _downloadAudioBloc.add(
                  DownloadAudioRemove(downloadAudioModel: downloadAudioModel));
            },
            child: const Text('Yes'),
          ),
          const SizedBox(width: 2.0),
          ElevatedButton(
            onPressed: () => Get.back(),
            child: const Text('No'),
          ),
        ],
      ),
    );
  }

  void _showVideoDescriptionDialog(
      DownloadAudioModel downloadAudioModel, bool showDownloadButton) {
    showAnimationDialog(
      dialog: VideoDescriptionDialog(
        downloadAudioModel: downloadAudioModel,
        downloadAction: _downloadAction,
        showDownloadButton: showDownloadButton,
      ),
    );
  }

  void _youtubeLinkListener(BuildContext context, YoutubeLinkState state) {
    if (state is YoutubeLinkSearchSuccess) {
      _showVideoDescriptionDialog(state.downloadAudioModel, true);
    }

    if (state is YoutubeLinkError) {
      showAnimationDialog(
        dialog: AlertDialog(
          content: const Text('Video cannot be downloaded'),
          actions: [
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('Ok'),
            ),
          ],
        ),
      );
    }
  }

  void _downloadAudioListener(BuildContext context, DownloadAudioState state) {
    if (state is DownloadAudioProgress) {
      _listDownloadAudioModel.clear();
      _listDownloadAudioModel.addAll(state.listDownloadAudio);

      if (state.insertElement != null) {
        _listKey.currentState!.insertItem(
          state.index,
          duration: const Duration(milliseconds: 500),
        );
      }

      if (state.removeElement != null) {
        _listKey.currentState!.removeItem(
          state.index,
          (context, animation) =>
              _buildSlidingItem(context, state.removeElement!, animation),
          duration: const Duration(milliseconds: 500),
        );

        // re-fetch music in playlist screen
        _musicBloc.add(MusicFetch());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<YoutubeLinkBloc, YoutubeLinkState>(
            listener: _youtubeLinkListener),
        BlocListener<DownloadAudioBloc, DownloadAudioState>(
            listener: _downloadAudioListener),
      ],
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: kToolbarHeight, left: 10.0, right: 10.0),
                child: _buildSearchYoutubeBar(),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 22.0, left: 10.0, right: 10.0),
                child: Text('Download progress'),
              ),
            ),
            SliverAnimatedList(
              key: _listKey,
              itemBuilder: (context, index, animation) {
                DownloadAudioModel downloadAudioModel =
                    _listDownloadAudioModel[index];

                return _buildSlidingItem(
                    context, downloadAudioModel, animation);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchYoutubeBar() {
    return BlocBuilder<YoutubeLinkBloc, YoutubeLinkState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 47.0,
                child: TextFormField(
                  controller: _linkController,
                  enabled: state is YoutubeLinkLoading ? false : true,
                  decoration: InputDecoration(
                    prefixIcon: GestureDetector(
                      onTap: _pasteAction,
                      child: const Icon(Icons.link, size: 28.0),
                    ),
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
              child: state is YoutubeLinkLoading
                  ? const SizedBox(
                      height: 24.0,
                      width: 24.0,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : const FaIcon(FontAwesomeIcons.search, size: 21.0),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSlidingItem(BuildContext context,
      DownloadAudioModel downloadAudioModel, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: const Offset(0, 0),
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeIn,
        reverseCurve: Curves.easeOut,
      )),
      child: DownloadItem(
        downloadAudioModel: downloadAudioModel,
        onDetailTap: (downloadAudioModel) =>
            _showVideoDescriptionDialog(downloadAudioModel, false),
        onCancelTap: _cancelDownloadAction,
      ),
    );
  }
}
