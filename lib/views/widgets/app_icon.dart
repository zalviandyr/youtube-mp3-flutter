import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_mp3/views/pallette.dart';

class AppIcon extends StatelessWidget {
  final bool _isDense;

  const AppIcon({Key? key})
      : _isDense = false,
        super(key: key);

  const AppIcon.dense({Key? key})
      : _isDense = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Youtube',
            style: _isDense
                ? Theme.of(context).textTheme.headline3
                : Theme.of(context).textTheme.headline2,
          ),
          const SizedBox(height: 5.0),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: _isDense
                  ? const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 15.0,
                    )
                  : const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 20.0,
                    ),
              decoration: BoxDecoration(
                borderRadius: Pallette.borderRadius,
                color: Colors.red,
              ),
              child: Text(
                'Mp3',
                style: _isDense
                    ? Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white)
                    : Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
