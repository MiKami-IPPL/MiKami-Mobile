import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        backgroundColor: Colors.amber[300],
      ),
    );
  }
}