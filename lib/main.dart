import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mikami_mobile/screens/auth/welcome_screen.dart';
import 'package:mikami_mobile/screens/user/home_screen.dart';
import 'package:mikami_mobile/services_api/controller/auth_service.dart';
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
  // Initialize the AuthController using Get.put
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mikami Mobile',
      theme: lightMode,
      home: authController.isLogin() == true ? HomeScreen() : WelcomeScreen(),
    );
  }
}
