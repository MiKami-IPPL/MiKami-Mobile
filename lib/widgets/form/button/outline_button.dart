import 'package:flutter/material.dart';
import 'package:mikami_mobile/theme/theme.dart';

class QOutlineButton extends StatelessWidget {
  const QOutlineButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.width,
  });
  final String label;
  final Function onPressed;
  final double? width;

  get lastTap => null;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width,
      height: 48,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.green,
          side: BorderSide(
            color: lightColorScheme.primary,
            width: 2,
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
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: lightColorScheme.primary,
          ),
        ),
      ),
    );
  }
}
