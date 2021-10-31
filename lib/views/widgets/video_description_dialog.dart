import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_mp3/models/models.dart';
import 'package:youtube_mp3/utils/utils.dart';
import 'package:youtube_mp3/views/pallette.dart';

class VideoDescriptionDialog extends StatelessWidget {
  final AppLocalization _localization = GetIt.I<AppLocalization>();
  final DownloadAudioModel downloadAudioModel;
  final Function(DownloadAudioModel)? downloadAction;
  final bool showDownloadButton;

  VideoDescriptionDialog({
    Key? key,
    required this.downloadAudioModel,
    required this.downloadAction,
    this.showDownloadButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: Pallette.borderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: downloadAudioModel.thumbnails.maxResUrl,
              imageBuilder: (context, imageProvider) => ClipRRect(
                borderRadius: Pallette.borderRadius,
                child: Image(
                  image: imageProvider,
                  width: 180.0,
                  height: 110.0,
                  fit: BoxFit.cover,
                ),
              ),
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade200,
                child: Container(
                  width: 180.0,
                  height: 110.0,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: Pallette.borderRadius,
                  ),
                ),
              ),
              // handle when maxRes not available
              errorWidget: (context, url, error) => ClipRRect(
                borderRadius: Pallette.borderRadius,
                child: Image.network(
                  downloadAudioModel.thumbnails.mediumResUrl,
                  width: 180.0,
                  height: 110.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              downloadAudioModel.title,
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(_localization.translate('duration')),
                ),
                Expanded(
                  flex: 7,
                  child: Text(downloadAudioModel.duration),
                ),
              ],
            ),
            const SizedBox(height: 7.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(_localization.translate('size')),
                ),
                Expanded(
                  flex: 7,
                  child: Text('${downloadAudioModel.size} mb'),
                ),
              ],
            ),
            if (showDownloadButton) ...[
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Get.back();

                  downloadAction!(downloadAudioModel);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(FontAwesomeIcons.arrowCircleDown, size: 20.0),
                    const SizedBox(width: 10.0),
                    Text(_localization.translate('download_mp3')),
                  ],
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}
