import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mikami_mobile/screens/auth/forgot_password_screen.dart';
import 'package:mikami_mobile/screens/user/home_screen.dart';
import 'package:mikami_mobile/screens/auth/register_screen.dart';
import 'package:mikami_mobile/services_api/controller/auth_service.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'package:mikami_mobile/widgets/custom_scaffold.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthController authcontroller = Get.put(AuthController());
  final _formLoginKey = GlobalKey<FormState>();
  bool rememberMe = true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: authcontroller.isLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData && snapshot.data == false) {
          return LoginWidget();
        } else {
          return HomeScreen();
        }
      },
    );
  }

  Widget LoginWidget() {
    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(height: 10),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25, 50, 25, 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formLoginKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Masuk ke Akun Anda',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: lightColorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      buildEmailFormField(),
                      const SizedBox(height: 25),
                      buildPasswordFormField(),
                      const SizedBox(height: 25),
                      buildRememberMeRow(),
                      const SizedBox(height: 25),
                      buildLoginButton(),
                      const SizedBox(height: 25),
                      buildGuestLogin(),
                      const SizedBox(height: 20),
                      buildRegisterLink(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEmailFormField() {
    return TextFormField(
      controller: authcontroller.emailController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Masukkan email';
        } else if (!GetUtils.isEmail(value)) {
          return 'Masukkan email yang valid';
        }
        return null;
      },
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@.]')),
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
        LowerCaseTextFormatter(),
      ],
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Enter Email',
        hintStyle: const TextStyle(color: Colors.black26),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: const TextStyle(color: Colors.grey),
    );
  }

  Widget buildPasswordFormField() {
    return TextFormField(
      controller: authcontroller.passwordController,
      obscureText: true,
      obscuringCharacter: "*",
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Masukkan password';
        } else if (value.length < 6) {
          return 'Password harus minimal 6 karakter';
        }
        return null;
      },
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter Password',
        hintStyle: const TextStyle(color: Colors.black26),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black12),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: const TextStyle(color: Colors.grey),
      onFieldSubmitted: (value) async {
        if (_formLoginKey.currentState!.validate()) {
          await authcontroller.login();
        }
      },
    );
  }

  Widget buildRememberMeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: rememberMe,
              onChanged: (bool? value) {
                setState(() {
                  rememberMe = value!;
                });
              },
              activeColor: lightColorScheme.primary,
            ),
            const Text(
              'Ingat Saya',
              style: TextStyle(color: Colors.black45),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => Get.to(() => ForgotScreen()),
          child: Text(
            'Lupa password?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: lightColorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_formLoginKey.currentState!.validate()) {
            await authcontroller.login();
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Masuk',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget buildGuestLogin() {
    return GestureDetector(
      onTap: () async {
        await authcontroller.loginTamu();
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Masuk sebagai tamu'),
          Icon(Icons.arrow_forward),
        ],
      ),
    );
  }

  Widget buildRegisterLink() {
    return GestureDetector(
      onTap: () {
        Get.to(() => RegisterScreen());
      },
      child: RichText(
        text: const TextSpan(
          text: 'Belum punya akun? ',
          style: TextStyle(color: Colors.black),
          children: <TextSpan>[
            TextSpan(
              text: 'Daftar',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.lightBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}
