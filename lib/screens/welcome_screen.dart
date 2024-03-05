import 'package:flutter/material.dart';
import 'package:mikami_mobile/screens/login_screen.dart';
import 'package:mikami_mobile/screens/register_screen.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'package:mikami_mobile/widgets/custom_scaffold.dart';
import 'package:mikami_mobile/widgets/welcome_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              'Selamat Datang!',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const Center(
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
                const Expanded(
                  child: WelcomeButton(
                    buttonText: 'Masuk',
                    onTap: LoginScreen(),
                    color: Colors.transparent,
                    textColor: Colors.white,
                  ),
                ),
                Expanded(
                  child: WelcomeButton(
                    buttonText: 'Daftar',
                    onTap: const RegisterScreen(),
                    color: Colors.white,
                    textColor: lightColorScheme.primary,
                  ),
                ),
              ],
            ),
          )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
