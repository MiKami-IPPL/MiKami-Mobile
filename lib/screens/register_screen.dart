import 'package:flutter/material.dart';
import 'package:mikami_mobile/widgets/custom_scaffold.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      child: Text('Berhasil daftar'),
    );
  }
}
