import 'package:flutter/material.dart';

Widget FloatingAction({
  required Function onPressed,
}) {
  return FloatingActionButton(
    heroTag: UniqueKey(),
    onPressed: () {
      var lastTap = null;
      if (
          //tapProtected
          DateTime.now().difference(lastTap ?? DateTime.now()).inMilliseconds <
              500) return;
      onPressed();
    },
    child: const Icon(Icons.add),
  );
}
