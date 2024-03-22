import 'package:flutter/material.dart';

class PreviewText extends StatelessWidget {
  final String lable;
  final String content;

  const PreviewText({
    Key? key,
    required this.lable,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 85,
          child: Text(
            lable,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 13,
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 13,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
