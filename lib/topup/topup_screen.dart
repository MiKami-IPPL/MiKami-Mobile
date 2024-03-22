import 'package:flutter/material.dart';
import 'package:mikami_mobile/profile/list_user.dart';
import 'package:mikami_mobile/topup/component/topup_box.dart';
import 'package:mikami_mobile/topup/list_harga.dart';

class TopUpScreen extends StatelessWidget {
  const TopUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Up'),
        leading: const Icon(Icons.arrow_back),
      ),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: hargaList.length,
          itemBuilder: (BuildContext context, int index) {
            return const TopUpBox();
          }),
    );
  }
}
