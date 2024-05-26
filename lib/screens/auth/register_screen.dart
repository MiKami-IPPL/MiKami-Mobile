import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mikami_mobile/screens/auth/login_screen.dart';
import 'package:mikami_mobile/services_api/controller/auth_service.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'package:mikami_mobile/widgets/custom_scaffold.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  AuthController authcontroller = Get.put(AuthController());
  final _formRegisterKey = GlobalKey<FormState>();
  bool agree = false;

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
          return RegisterWidget();
        } else {
          return LoginScreen();
        }
      },
    );
  }

  Widget RegisterWidget() {
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
                  key: _formRegisterKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Daftar Akun Baru',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: lightColorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 40),
                      buildNameFormField(),
                      const SizedBox(height: 25),
                      buildEmailFormField(),
                      const SizedBox(height: 25),
                      buildAgeFormField(),
                      const SizedBox(height: 25),
                      buildPasswordFormField(),
                      const SizedBox(height: 25),
                      buildAgreeTermsRow(),
                      const SizedBox(height: 25),
                      buildRegisterButton(),
                      const SizedBox(height: 25),
                      buildGuestLogin(),
                      const SizedBox(height: 30),
                      buildLoginLink(),
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

  Widget buildNameFormField() {
    return TextFormField(
      controller: authcontroller.name,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Masukkan nama';
        }
        if (value.length < 3) {
          return 'Nama harus minimal 3 karakter';
        }
        return null;
      },
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
      ],
      decoration: InputDecoration(
        labelText: 'Nama Lengkap',
        hintText: 'Masukkan nama lengkap',
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

  Widget buildEmailFormField() {
    return TextFormField(
      controller: authcontroller.email,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Masukkan email';
        }
        if (!GetUtils.isEmail(value)) {
          return 'Masukkan email yang valid';
        }
        return null;
      },
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
        LowerCaseTextFormatter(),
      ],
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Masukkan email',
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

  Widget buildAgeFormField() {
    return TextFormField(
      controller: authcontroller.age,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Masukkan umur';
        }
        int? age = int.tryParse(value);
        if (age == null || age <= 0) {
          return 'Masukkan umur yang valid';
        }
        return null;
      },
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        labelText: 'Umur',
        hintText: 'Masukkan umur',
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
      controller: authcontroller.password,
      obscureText: true,
      obscuringCharacter: "*",
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Masukkan password';
        }
        if (value.length < 6) {
          return 'Password harus minimal 6 karakter';
        }
        return null;
      },
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      ],
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Masukkan password',
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

  Widget buildAgreeTermsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: agree,
          onChanged: (bool? value) {
            setState(() {
              agree = value!;
            });
          },
          activeColor: lightColorScheme.primary,
        ),
        const Text(
          'Saya setuju dengan EULA',
          style: TextStyle(color: Colors.black45),
        ),
      ],
    );
  }

  Widget buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formRegisterKey.currentState!.validate() && agree) {
            authcontroller.registerWithEmail();
          } else {
            authcontroller.password.clear();
            Get.snackbar(
              'Error',
              'Isi semua form dan setujui EULA',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 3),
              backgroundColor: lightColorScheme.error,
              colorText: lightColorScheme.onError,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Daftar',
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

  Widget buildLoginLink() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      },
      child: RichText(
        text: const TextSpan(
          text: 'Sudah punya akun? ',
          style: TextStyle(color: Colors.black),
          children: <TextSpan>[
            TextSpan(
              text: 'Masuk Disini',
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
