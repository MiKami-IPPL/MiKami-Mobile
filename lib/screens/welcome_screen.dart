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
        children: [
          Flexible(
              flex: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 40.0,
                ),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'Selamat Datang!\n',
                            style: TextStyle(
                              fontSize: 35.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            )),
                        TextSpan(
                            text:
                                '\nDengan Aplikasi ini anda dapat membuka cakrawala komik\n\n',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              // height: 0,
                            ))
                      ],
                    ),
                  ),
                ),
              )),
          const Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  Expanded(
                    child: WelcomeButton(
                      buttonText: 'Masuk',
                      onTap: LoginScreen(),
                      color: Colors.transparent,
                      textColor: Colors.black,
                    ),
                  ),
                  Expanded(
                    child: WelcomeButton(
                      buttonText: 'Daftar',
                      onTap: RegisterScreen(),
                      color: Color.fromARGB(255, 221, 181, 59),
                      textColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
