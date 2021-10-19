import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_mp3/models/models.dart';

class VideoDescriptionDialog extends StatelessWidget {
  final DownloadAudio downloadAudio;
  final Function(DownloadAudio) downloadAction;

  const VideoDescriptionDialog({
    Key? key,
    required this.downloadAudio,
    required this.downloadAction,
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
            ClipRRect(
              borderRadius: BorderRadius.circular(7.0),
              child: CachedNetworkImage(
                width: 130.0,
                height: 100.0,
                imageUrl: downloadAudio.thumb,
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade200,
                    child: Container(
                      width: 130.0,
                      height: 100.0,
                      color: Colors.grey.shade300,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              downloadAudio.title,
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
                  child: Text(downloadAudio.duration),
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
                  child: Text('${downloadAudio.size} mb'),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Get.back();

                downloadAction(downloadAudio);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  FaIcon(FontAwesomeIcons.arrowCircleDown, size: 20.0),
                  SizedBox(width: 10.0),
                  Text('Download Mp3'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
