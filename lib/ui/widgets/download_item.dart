import 'package:flutter/material.dart';

class DownloadItem extends StatelessWidget {
  const DownloadItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8.0, left: 10.0, right: 10.0),
      padding: const EdgeInsets.all(10.0),
      height: 90.0,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(7.0),
            child: Image.network(
              'https://dailyspin.id/wp-content/uploads/2020/08/Tips-Omen-Valorant.jpeg',
              width: 100.0,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'this is omen',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10.0),
                const Text('06:00 menit'),
              ],
            ),
          ),
          const Spacer(),
          Column(
            children: const [
              Icon(
                Icons.download,
                color: Color(0xFF293241),
              ),
              Spacer(),
              Text('10 mb'),
            ],
          ),
        ],
      ),
    );
  }
}
