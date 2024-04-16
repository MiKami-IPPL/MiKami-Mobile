import 'package:flutter/material.dart';
import 'package:mikami_mobile/theme/theme.dart';

class QStatistic extends StatelessWidget {
  const QStatistic({
    required this.label,
    required this.value,
    required this.icon,
    super.key,
    this.color,
  });
  final String label;
  final num value;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    '$value',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color ?? lightColorScheme.primary,
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    8,
                  ),
                ),
              ),
              child: Icon(
                icon,
                size: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
