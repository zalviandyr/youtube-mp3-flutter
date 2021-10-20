import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:youtube_mp3/blocs/blocs.dart';
import 'package:youtube_mp3/models/models.dart';
import 'package:youtube_mp3/ui/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _linkController = TextEditingController();
  final GlobalKey<SliverAnimatedListState> _listKey = GlobalKey();
  late YoutubeLinkBloc _youtubeLinkBloc;
  late DownloadAudioBloc _downloadAudioBloc;

  @override
  void initState() {
    _youtubeLinkBloc = BlocProvider.of<YoutubeLinkBloc>(context);
    _downloadAudioBloc = BlocProvider.of<DownloadAudioBloc>(context);

    super.initState();
  }

  @override
  void dispose() {
    _linkController.dispose();

    super.dispose();
  }

  void _pasteAction() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);

    if (data != null) {
      _linkController.text = data.text ?? '';
    }
  }

  void _searchAction() {
    FocusScope.of(context).unfocus();

    String link = _linkController.text;
    if (link.isNotEmpty) {
      _youtubeLinkBloc.add(YoutubeLinkSearch(link: link));
    }
  }

  void _downloadAction(DownloadAudioModel downloadAudioModel) {
    _linkController.text = '';

    _downloadAudioBloc
        .add(DownloadAudioSubmit(downloadAudioModel: downloadAudioModel));
  }

  void _cancelDownloadAction(DownloadAudioModel downloadAudioModel) {
    showGeneralDialog(
      context: context,
      barrierLabel: 'CancelDownloadDialog',
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 200),
      transitionBuilder: (context, a1, a2, widget) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: a1,
            curve: Curves.easeInOut,
          ),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7.0),
            ),
            content: const Text('Are your sure to want cancel it ?'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();

                  _downloadAudioBloc.add(DownloadAudioCancel(
                      downloadAudioModel: downloadAudioModel));
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
      },
      pageBuilder: (context, a1, a2) => const SizedBox.shrink(),
    );
  }

  void _showVideoDescriptionDialog(
      DownloadAudioModel downloadAudioModel, bool showDownloadButton) {
    showGeneralDialog(
      context: context,
      barrierLabel: 'VideoDescriptionDialog',
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 200),
      transitionBuilder: (context, a1, a2, widget) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: a1,
            curve: Curves.easeInOut,
          ),
          child: VideoDescriptionDialog(
            downloadAudioModel: downloadAudioModel,
            downloadAction: _downloadAction,
            showDownloadButton: showDownloadButton,
          ),
        );
      },
      pageBuilder: (context, a1, a2) => const SizedBox.shrink(),
    );
  }

  void _youtubeLinkListener(BuildContext context, YoutubeLinkState state) {
    if (state is YoutubeLinkSearchSuccess) {
      _showVideoDescriptionDialog(state.downloadAudioModel, true);
    }
  }

  void _downloadAudioListener(BuildContext context, DownloadAudioState state) {
    if (state is DownloadAudioProgress) {
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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            BlocBuilder<DownloadAudioBloc, DownloadAudioState>(
              builder: (context, state) {
                return SliverAnimatedList(
                  key: _listKey,
                  itemBuilder: (context, index, animation) {
                    if (state is DownloadAudioProgress) {
                      DownloadAudioModel downloadAudioModel =
                          state.listDownloadAudio[index];

                      return _buildSlidingItem(
                          context, downloadAudioModel, animation);
                    }

                    return const SizedBox.shrink();
                  },
                );
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
