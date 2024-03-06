import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mikami_mobile/screens/login_screen.dart';
import 'package:mikami_mobile/widgets/custom_scaffold.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formRegisterKey = GlobalKey<FormState>();
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
                  const Text('Daftar Akun Baru',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) =>
                        value!.isEmpty ? 'Masukkan nama' : null,
                    decoration: const InputDecoration(
                        label: Text('Nama'),
                        hintText: 'Masukkan nama',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Colors.grey))),
                    style: const TextStyle(color: Colors.grey),
                  ),
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
                            borderRadius: BorderRadius.all(Radius.circular(10)),
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
                          borderRadius: BorderRadius.all(Radius.circular(10)),
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
                          Checkbox(value: false, onChanged: (value) {}),
                          const Text('Saya setuju dengan EULA'),
                        ],
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
                        if (_formRegisterKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')));
                        }
                      },
                      child: const Text('Daftar'),
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
                    child: const Text(
                      'Sudah punya akun? Masuk disini',
                      style: TextStyle(
                        color: Colors.blue,
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
