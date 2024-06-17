import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mikami_mobile/screens/auth/welcome_screen.dart';
import 'package:mikami_mobile/screens/user/search_screen.dart';
import 'package:mikami_mobile/screens/pengaduan_search.dart';
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData && snapshot.data == true) {
          return pengaduanWidget();
        } else {
          return WelcomeScreen();
        }
      },
    );
  }

  Widget pengaduanWidget() {
    return FutureBuilder(
      future: _prefs,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData) {
          final SharedPreferences prefs = snapshot.data as SharedPreferences;
          return Scaffold(
            backgroundColor: lightColorScheme.background,
            appBar: AppBar(
              title: Text('Pengaduan'),
              backgroundColor: lightColorScheme.primary,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (prefs.getInt('selectedID') == null)
                      AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        child: SearchBar(
                          controller: usercontroller.searchController,
                          hintText: 'Search Comic',
                          onSubmitted: (value) async {
                            await usercontroller.searchKomik();
                            await Get.to(() => PengaduanSearch());
                            setState(() {});
                          },
                        ),
                      ),
                    SizedBox(height: 20),
                    Text(
                      'Report Comic:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    if (prefs.getInt('selectedID') != null)
                      Text(
                        prefs.getString('selectedTitle') ?? 'Not selected',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    SizedBox(height: 20),
                    if (prefs.getInt('selectedID') != null)
                      ElevatedButton.icon(
                        icon: Icon(Icons.cancel),
                        label: Text('Cancel Choose'),
                        onPressed: () {
                          usercontroller.searchController.clear();
                          prefs.remove('selectedID');
                          prefs.remove('selectedTitle');
                          usercontroller.reasonController.clear();
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shadowColor: Colors.white,
                        ),
                      ),
                    if (prefs.getInt('selectedID') == null)
                      ElevatedButton.icon(
                        icon: Icon(Icons.refresh),
                        label: Text('Refresh Screen'),
                        onPressed: () {
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: lightColorScheme.primary,
                          shadowColor: Colors.white,
                        ),
                      ),
                    if (prefs.getInt('selectedID') != null) ...[
                      SizedBox(height: 20),
                      TextFormField(
                        controller: usercontroller.reasonController,
                        maxLines: 5,
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
                        ),
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.send),
                          label: Text('Submit Report'),
                          onPressed: () async {
                            await usercontroller.postReportKomik();
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shadowColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: Text('Error loading preferences'),
            ),
          );
        }
      },
    );
  }
}
