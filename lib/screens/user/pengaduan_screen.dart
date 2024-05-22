//buat statefull widget pengaduanScreen
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mikami_mobile/screens/auth/welcome_screen.dart';
import 'package:mikami_mobile/screens/user/search_screen.dart';
import 'package:mikami_mobile/services_api/controller/auth_service.dart';
import 'package:mikami_mobile/services_api/controller/user_service.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PengaduanScreen extends StatefulWidget {
  @override
  _PengaduanScreenState createState() => _PengaduanScreenState();
}

class _PengaduanScreenState extends State<PengaduanScreen> {
  UserController usercontroller = Get.put(UserController());
  AuthController authcontroller = Get.put(AuthController());
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: authcontroller.isLogin(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == false) {
            // profileController.logout();
            return WelcomeScreen();
          } else {
            return pengaduanWidget();
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  //buat statefull widget pengaduanScreen
  Widget pengaduanWidget() {
    return FutureBuilder(
        future: _prefs,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final SharedPreferences prefs = snapshot.data as SharedPreferences;
            return Scaffold(
              backgroundColor: lightColorScheme.primary,
              appBar: AppBar(
                title: Text('Pengaduan'),
              ),
              body: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    // add search bar with animation
                    SearchBar(
                      controller: usercontroller.searchController,
                      hintText: 'Search Comic',
                      onSubmitted: (Null) async {
                        await usercontroller.searchKomik();
                        Get.to(() => SearchScreen());
                        //reset state
                      },
                    ),

                    // Add SizedBox widget to give space between the search bar and the list
                    SizedBox(height: 20),
                    // add text widget
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Report Comic :',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        if (prefs.getInt('selectedID') != null)
                          Text(
                            prefs.getString('selectedTitle') ?? 'not selected',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: 20),
                    if (prefs.getInt('selectedID') != null)
                      ElevatedButton(
                        onPressed: () {
                          usercontroller.searchController.clear();
                          prefs.remove('selectedID');
                          prefs.remove('selectedTitle');
                          //reset state
                          setState(() {});
                        },
                        child: Text('Cancel Choose'),
                      ),
                    SizedBox(height: 20),
                    if (prefs.getInt('selectedID') == null)
                      //make refresh screen button
                      ElevatedButton(
                        onPressed: () {
                          setState(() {});
                        },
                        child: Text('Refresh Screen'),
                      ),
                    SizedBox(height: 20),
                    if (prefs.getInt('selectedID') != null)
                      //make textfield for reason with animation
                      TextFormField(
                        onFieldSubmitted: (Null) async {
                          await usercontroller.postReportKomik();
                          //reset state
                          setState(() {});
                        },
                        controller: usercontroller.reasonController,
                        decoration: InputDecoration(
                          labelText: 'Reason',
                          labelStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}