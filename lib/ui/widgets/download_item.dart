import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_mp3/models/models.dart';

class DownloadItem extends StatelessWidget {
  final DownloadAudioModel downloadAudioModel;

  const DownloadItem({
    Key? key,
    required this.downloadAudioModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8.0, left: 10.0, right: 10.0),
      height: 113.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 2.0,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: downloadAudioModel.thumbnails.maxResUrl,
                  imageBuilder: (context, imageProvider) => ClipRRect(
                    borderRadius: BorderRadius.circular(7.0),
                    child: Image(
                      image: imageProvider,
                      width: 100.0,
                      height: 90.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  placeholder: (context, url) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade200,
                      child: Container(
                        width: 100.0,
                        height: 90.0,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                      ),
                    );
                  },
                  // handle when maxRes not available
                  errorWidget: (context, url, error) => ClipRRect(
                    borderRadius: BorderRadius.circular(7.0),
                    child: Image.network(
                      downloadAudioModel.thumbnails.mediumResUrl,
                      width: 100.0,
                      height: 90.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                Container(
                  padding: const EdgeInsets.only(top: 7.0),
                  width: 220.w,
                  height: 90.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        downloadAudioModel.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Text(downloadAudioModel.duration),
                          const Spacer(),
                          Text('${downloadAudioModel.size} mb')
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const LinearProgressIndicator(),
        ],
      ),
    );
  }
}
