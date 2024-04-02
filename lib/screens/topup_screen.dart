import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'payment_screen.dart';

class TopupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[300],
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.amber[300],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.monetization_on,
                              color: Colors.amber,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Your Coins:',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.amber,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: Row(
                              children: [
                                Text(
                                  '100',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Image.asset(
                                  'assets/images/koin_mikami.png',
                                  width: 20,
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Paket Koin',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      // List of menu buttons
                      _buildMenuButton(
                        'assets/images/koin_mikami.png',
                        "10 Koin",
                        () {
                          Get.to(() => TopupScreen());
                        },
                      ),
                      _buildMenuButton(
                        'assets/images/koin_mikami.png',
                        "100 Koin",
                        () {
                          Get.to(() => TopupScreen());
                        },
                      ),
                      _buildMenuButton(
                        'assets/images/koin_mikami.png',
                        "500 Koin",
                        () {
                          Get.to(() => TopupScreen());
                        },
                      ),
                      _buildMenuButton(
                        'assets/images/koin_mikami.png',
                        "1000 Koin",
                        () {
                          Get.to(() => TopupScreen());
                        },
                      ),
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

  Widget _buildMenuButton(String imagePath, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 50,
              height: 50,
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
