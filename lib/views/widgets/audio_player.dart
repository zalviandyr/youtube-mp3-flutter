import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AudioPlayer extends StatelessWidget {
  final VoidCallback onPlay;

  const AudioPlayer({
    Key? key,
    required this.onPlay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(7.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 2.0,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'asdasdasda ',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 15.0),
              const Text(
                '00:30',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: onPlay,
            child: const FaIcon(
              FontAwesomeIcons.solidPlayCircle,
              size: 33.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
