import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mikami_mobile/screens/login_screen.dart';
import 'package:mikami_mobile/services_api/login_service.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  LoginController loginController = Get.put(LoginController());
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loginController.isLogin(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == false) {
            //use return login screen and snackbar if user is not logged in use children
            Get.showSnackbar(GetSnackBar(
              title: 'Peringatan',
              message: 'Anda belum login',
              icon: Icon(Icons.error, color: Colors.white),
              duration: const Duration(seconds: 3),
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: lightColorScheme.error,
            ));
            return LoginScreen();
          } else {
            return ProfileWidget();
          }
        } else {
          return GetSnackBar(
            title: 'Peringatan',
            message: 'Anda belum login',
            icon: Icon(Icons.error, color: Colors.white),
            duration: const Duration(seconds: 3),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: lightColorScheme.error,
          );
          // return CircularProgressIndicator();
        }
      },
    );
  }

  itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 5),
                color: Colors.deepOrange.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 10)
          ]),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(iconData),
        trailing: Icon(Icons.arrow_forward, color: Colors.grey.shade400),
        tileColor: Colors.white,
      ),
    );
  }

  Widget ProfileWidget() {
    return FutureBuilder(
      future: _prefs,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final SharedPreferences prefs = snapshot.data as SharedPreferences;
          return Scaffold(
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
              body: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: AssetImage('assets/images/seulgi.jpg'),
                    ),
                    const SizedBox(height: 20),
                    itemProfile('Name', '${prefs.getString('name')}',
                        CupertinoIcons.person),
                    const SizedBox(height: 10),
                    itemProfile('Role', '${prefs.getString('role')}',
                        CupertinoIcons.lock_shield_fill),
                    const SizedBox(height: 10),
                    if (prefs.getString('name') != 'tamu')
                      itemProfile('Email', '${prefs.getString('email')}',
                          CupertinoIcons.mail),
                    const SizedBox(
                      height: 20,
                    ),
                    if (prefs.getString('name') != 'tamu')
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(15),
                            ),
                            child: const Text('Edit Profile')),
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (prefs.getString('name') != 'tamu')
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(15),
                            ),
                            child: const Text('Ubah Password')),
                      )
                  ],
                ),
              )));
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
