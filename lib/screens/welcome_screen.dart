import 'package:flutter/material.dart';
import 'package:mikami_mobile/widgets/custom_scaffold.dart';
import 'package:mikami_mobile/widgets/welcome_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Selamat Datang!',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Center(
            child: Text(
              'Silahkan login untuk melanjutkan',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          Flexible(
              child: Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: WelcomeButton(
                    buttonText: 'Masuk',
                  ),
                ),
                Expanded(
                  child: WelcomeButton(
                    buttonText: 'Daftar',
                  ),
                ),
              ],
            ),
          )),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
