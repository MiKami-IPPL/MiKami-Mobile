import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mikami_mobile/services_api/controller/profile_service.dart';
import 'package:mikami_mobile/services_api/controller/user_service.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopupScreen extends StatefulWidget {
  @override
  State<TopupScreen> createState() => _TopupScreenState();
}

class _TopupScreenState extends State<TopupScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  UserController usercontroller = Get.put(UserController());
  ProfileController profilecontroller = Get.put(ProfileController());
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _prefs,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final SharedPreferences prefs = snapshot.data as SharedPreferences;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: lightColorScheme.primary,
              iconTheme: const IconThemeData(
                color: Colors.white,
              ),
            ),
            backgroundColor: lightColorScheme.primary,
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
                                    color: lightColorScheme.primary,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Koin Anda:',
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
                                  color: lightColorScheme.onPrimary,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: Row(
                                    children: [
                                      Text(
                                        prefs.getInt('coin').toString(),
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Image.asset(
                                        'assets/images/koin_mikami.png',
                                        width: 30,
                                        height: 30,
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
                              () async {
                                await profilecontroller.getPrice();
                                await usercontroller.topupCoin(
                                    10, prefs.getInt('price')!);
                              },
                            ),
                            _buildMenuButton(
                              'assets/images/koin_mikami.png',
                              "100 Koin",
                              () async {
                                await profilecontroller.getPrice();
                                await usercontroller.topupCoin(
                                    100, prefs.getInt('price')!);
                              },
                            ),
                            _buildMenuButton(
                              'assets/images/koin_mikami.png',
                              "500 Koin",
                              () async {
                                await profilecontroller.getPrice();
                                await usercontroller.topupCoin(
                                    500, prefs.getInt('price')!);
                              },
                            ),
                            _buildMenuButton(
                              'assets/images/koin_mikami.png',
                              "1000 Koin",
                              () async {
                                await profilecontroller.getPrice();
                                await usercontroller.topupCoin(
                                    1000, prefs.getInt('price')!);
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
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
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
