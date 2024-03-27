import 'package:flutter/material.dart';
import 'package:mikami_mobile/screens/main_menu.dart';
import 'package:get/get.dart';
import 'package:mikami_mobile/screens/welcome_screen.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'screens/screen_1.dart';

void main() {
  runApp( MyApp());
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: const WelcomeScreen(),
//       theme: lightMode,
//       title: 'Mikami Mobile',
//     ); // MaterialApp
//   }
// }

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}
