import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mikami_mobile/screens/login_screen.dart';
import 'package:mikami_mobile/services_api/login_service.dart';
import 'package:mikami_mobile/services_api/user_service.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  LoginController loginController = Get.put(LoginController());
  UserController userController = Get.put(UserController());
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loginController.isLogin(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == false) {
            return LoginScreen();
          } else {
            return FutureBuilder(
              future: _prefs,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final SharedPreferences prefs =
                      snapshot.data as SharedPreferences;
                  return Scaffold(
                      backgroundColor: lightColorScheme.primary,
                      appBar: AppBar(
                        title: const Text('Search Komik'),
                        iconTheme: const IconThemeData(
                          color: Colors.white,
                        ),
                        titleTextStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        backgroundColor: Colors.amber[300],
                      ),
                      body:
                          //make scrollable
                          SingleChildScrollView(
                        child: Column(
                          children: [
                            //make search bar
                            Container(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller:
                                          userController.searchController,
                                      decoration: InputDecoration(
                                        hintText: 'Search',
                                        hintStyle:
                                            const TextStyle(color: Colors.grey),
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: Colors.white),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                              color: Colors.white),
                                        ),
                                      ),
                                      //if press enter on keyboard do search
                                      onSubmitted: (Null) async {
                                        await userController.searchAllKomik();
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      await userController.searchAllKomik();
                                    },
                                    icon: const Icon(Icons.search),
                                  ),
                                ],
                              ),
                            ),
                            //make list of data
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: prefs.getInt('dataKomik[Max]') ?? 0,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //fix text overflow
                                          Row(
                                            children: [
                                              if (prefs
                                                      .getString(
                                                          'dataKomik[$index][title]')!
                                                      .length <=
                                                  24)
                                                Text(
                                                  '${prefs.getString('dataKomik[$index][title]')}',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              if (prefs
                                                      .getString(
                                                          'dataKomik[$index][title]')!
                                                      .length >
                                                  25)
                                                Text(
                                                  prefs
                                                          .getString(
                                                              'dataKomik[$index][title]')!
                                                          .substring(0, 25) +
                                                      '...',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              // Text(
                                              //   '${prefs.getString('dataKomik[$index][price]')} Koin',
                                              //   style: const TextStyle(
                                              //     fontSize: 1,
                                              //     fontWeight: FontWeight.bold,
                                              //   ),
                                              // ),
                                            ],
                                          ),

                                          if (prefs
                                                  .getString(
                                                      'dataKomik[$index][description]')!
                                                  .length <=
                                              29)
                                            Text(
                                              'Deskripsi: ${prefs.getString('dataKomik[$index][description]'.tr)}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          if (prefs
                                                  .getString(
                                                      'dataKomik[$index][description]')!
                                                  .length >
                                              30)
                                            Text(
                                              'Deskripsi: ${prefs.getString('dataKomik[$index][description]')!.substring(0, 30) + '...'}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          Text(
                                              '${prefs.getString('dataKomik[$index][genres]')}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                              )),
                                        ],
                                      ),
                                      const Spacer(),
                                      //show price
                                      Text(
                                        '${prefs.getString('dataKomik[$index][price]')} Koin',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ));
                } else {
                  return const CircularProgressIndicator();
                }
              },
            );
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
