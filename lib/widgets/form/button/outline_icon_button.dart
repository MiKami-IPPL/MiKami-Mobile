import 'package:flutter/material.dart';

class QOutlineIconButton extends StatelessWidget {
  const QOutlineIconButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    super.key,
    this.width,
  });
  final String label;
  final IconData icon;
  final Function onPressed;
  final double? width;

  get lastTap => null;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width,
      height: 48,
      child: OutlinedButton.icon(
        icon: Icon(
          icon,
          color: const Color(0xff434d48),
        ),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xff434d48),
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.green,
          side: const BorderSide(
            color: Color(0xffd9dbd9),
          ),
        ),
        onPressed: () {
          if (
              //tapProtected
              DateTime.now()
                      .difference(lastTap ?? DateTime.now())
                      .inMilliseconds <
                  500) return;
          onPressed();
        },
      ),
    );
  }
}
