import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_mp3/models/models.dart';

class VideoDescriptionDialog extends StatelessWidget {
  final DownloadAudioModel downloadAudioModel;
  final Function(DownloadAudioModel)? downloadAction;
  final bool showDownloadButton;

  const VideoDescriptionDialog({
    Key? key,
    required this.downloadAudioModel,
    required this.downloadAction,
    this.showDownloadButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0),
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
                borderRadius: BorderRadius.circular(7.0),
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
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                ),
              ),
              // handle when maxRes not available
              errorWidget: (context, url, error) => ClipRRect(
                borderRadius: BorderRadius.circular(7.0),
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
                const Expanded(
                  flex: 3,
                  child: Text('Duration'),
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
                const Expanded(
                  flex: 3,
                  child: Text('Size'),
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
                  children: const [
                    FaIcon(FontAwesomeIcons.arrowCircleDown, size: 20.0),
                    SizedBox(width: 10.0),
                    Text('Download Mp3'),
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
