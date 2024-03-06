import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mikami_mobile/screens/register_screen.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'package:mikami_mobile/widgets/custom_scaffold.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formLoginKey = GlobalKey<FormState>();
  bool rememberMe = false;
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
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
                  key: _formLoginKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Masuk ke Akun Anda',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) =>
                            value!.isEmpty ? 'Masukkan email' : null,
                        decoration: const InputDecoration(
                            label: Text('Email'),
                            hintText: 'Masukkan email',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.grey))),
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        obscureText: true,
                        obscuringCharacter: "*",
                        validator: (value) =>
                            value!.isEmpty ? 'Masukkan password' : null,
                        decoration: const InputDecoration(
                            label: Text('Password'),
                            hintText: 'Masukkan password',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(color: Colors.grey),
                            )),
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
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
                                  }),
                              const Text('Ingat Saya')
                            ],
                          ),
                          //lupa password
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Chat admin untuk lupa password?')));
                            },
                            child: const Text(
                              'Lupa password?',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formLoginKey.currentState!.validate() &&
                                rememberMe) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Processing Data')));
                            }
                          },
                          child: const Text('Masuk'),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Masuk sebagai tamu'),
                          Icon(
                            Icons.arrow_forward,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (e) => const RegisterScreen()));
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
        ],
      ),
    );
  }
}
