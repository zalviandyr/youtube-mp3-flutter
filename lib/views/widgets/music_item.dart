import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_mp3/models/models.dart';
import 'package:youtube_mp3/views/pallette.dart';

class MusicItem extends StatelessWidget {
  final MusicModel musicModel;
  final ValueSetter<MusicModel> onTap;

  const MusicItem({
    Key? key,
    required this.musicModel,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 10.0, right: 10.0),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: Pallette.borderRadius,
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 2.0,
                  offset: Offset(0, 1),
                )
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: Pallette.borderRadius,
                  child: Image.memory(
                    musicModel.thumbnails,
                    width: 80.0,
                    height: 70.0,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10.0),
                Container(
                  padding: const EdgeInsets.only(top: 7.0),
                  width: 240.w,
                  height: 70.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        musicModel.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      Text(musicModel.duration),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onTap(musicModel),
                borderRadius: Pallette.borderRadius,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
