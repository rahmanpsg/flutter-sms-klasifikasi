import 'package:flutter/material.dart';
import 'package:sms_classification/styles/constant.dart';

class ListTentang extends StatelessWidget {
  const ListTentang({
    Key? key,
    required this.icon,
    required this.title,
    required this.teks,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final String teks;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(icon, color: dangerColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: kHeaderStyle,
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          color: bgColor,
          child: Text(teks),
        )
      ],
    );
  }
}
