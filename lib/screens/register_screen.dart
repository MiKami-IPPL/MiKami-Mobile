import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mikami_mobile/screens/login_screen.dart';
import 'package:mikami_mobile/screens/tamu_screen.dart';
import 'package:mikami_mobile/services_api/register_service.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'package:mikami_mobile/widgets/custom_scaffold.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  RegisterController registerController = Get.put(RegisterController());
  final _formRegisterKey = GlobalKey<FormState>();
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool agree = false;
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        child: Column(children: [
      const Expanded(
        flex: 1,
        child: SizedBox(
          height: 10,
        ),
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
                  Text('Daftar Akun Baru',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: lightColorScheme.primary)),
                  const SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    controller: registerController.name,
                    validator: (value) =>
                        value!.isEmpty ? 'Masukkan nama' : null,
                    decoration: InputDecoration(
                      label: const Text('Nama Lengkap'),
                      hintText: 'Masukkan nama lengkap',
                      hintStyle: const TextStyle(
                        color: Colors.black26,
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black12, // Default border color
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black12, // Default border color
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: registerController.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) =>
                        value!.isEmpty ? 'Masukkan email' : null,
                    decoration: InputDecoration(
                      label: const Text('Email'),
                      hintText: 'Masukkan email',
                      hintStyle: const TextStyle(
                        color: Colors.black26,
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black12, // Default border color
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black12, // Default border color
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: registerController.age,
                    keyboardType: TextInputType.number,

                    // obscureText: true,
                    // obscuringCharacter: "*",
                    validator: (value) =>
                        value!.isEmpty ? 'Masukkan umur' : null,
                    decoration: InputDecoration(
                      label: const Text('Umur'),
                      hintText: 'Masukkan Umur',
                      hintStyle: const TextStyle(
                        color: Colors.black26,
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black12, // Default border color
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black12, // Default border color
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: registerController.password,
                    obscureText: true,
                    obscuringCharacter: "*",
                    validator: (value) =>
                        value!.isEmpty ? 'Masukkan password' : null,
                    decoration: InputDecoration(
                      label: const Text('Password'),
                      hintText: 'Enter Password',
                      hintStyle: const TextStyle(
                        color: Colors.black26,
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black12, // Default border color
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black12, // Default border color
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                              value: agree,
                              onChanged: (bool? value) {
                                setState(() {
                                  agree = value!;
                                });
                              },
                              activeColor: lightColorScheme.primary),
                          const Text('Saya setuju dengan EULA'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formRegisterKey.currentState!.validate() &&
                            agree == true) {
                          registerController.registerWithEmail();
                        } else {
                          registerController.password.clear();
                          Get.snackbar(
                            'Error', 'Isi semua form dan setujui EULA',
                            snackPosition: SnackPosition.BOTTOM,
                            //show snack bar for 3 seconds
                            duration: const Duration(seconds: 3),
                            backgroundColor: lightColorScheme.error,
                            colorText: lightColorScheme.onError,
                          );
                        }
                      },
                      child: const Text('Daftar'),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  GestureDetector(
                    //navigasi ke tamu screen
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (e) => const TamuScreen(),
                        ),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Masuk sebagai tamu'),
                        Icon(
                          Icons.arrow_forward,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  //sudah punya akun
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (e) => const LoginScreen(),
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
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    ]));
  }
}
