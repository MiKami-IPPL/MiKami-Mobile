import 'package:flutter/material.dart';
import 'package:mikami_mobile/history/component/history_box.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.arrow_back,
        ),
        title: const Text('Histori Koin'),
      ),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (BuildContext context, index) {
          return Column(
            children: [
              const HistoryBox(),
              Container(
                width: double.maxFinite,
                height: 0.3,
                color: Colors.black45,
              )
            ],
          );
        },
      ),
    );
  }
}
