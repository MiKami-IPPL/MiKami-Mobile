import 'package:flutter/material.dart';
import 'package:mikami_mobile/history/history_screen.dart';
import 'package:mikami_mobile/preview/preview_screen.dart';
import 'package:mikami_mobile/profile/profile_screen.dart';
import 'package:mikami_mobile/topup/topup_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mikami',
      home: PreviewScreen(),
    );
  }
}
