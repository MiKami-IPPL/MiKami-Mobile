import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mikami_mobile/screens/user/home_screen.dart';
import 'package:mikami_mobile/screens/auth/welcome_screen.dart';
import 'package:mikami_mobile/services_api/controller/login_service.dart';
import 'package:mikami_mobile/theme/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  LoginController loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: loginController.isLogin() == true ? HomeScreen() : WelcomeScreen(),
      theme: lightMode,
      title: 'Mikami Mobile',
    ); // MaterialApp
  }
}

// class MyApp extends StatefulWidget {
//   MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
//   }
// }
