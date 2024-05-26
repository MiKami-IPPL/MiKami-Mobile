import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mikami_mobile/screens/auth/login_screen.dart';
import 'package:mikami_mobile/services_api/controller/auth_service.dart';
import 'package:mikami_mobile/services_api/controller/profile_service.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  AuthController authcontroller = Get.put(AuthController());
  ProfileController profileController = Get.put(ProfileController());
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: authcontroller.isLogin(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == false) {
            return LoginScreen();
          } else {
            return ProfileWidget();
          }
        } else {
          return CircularProgressIndicator();
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

  Widget UbahPassword() {
    //TODO: Implementasi Ubah Password
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
                backgroundColor: lightColorScheme.primary,
              ),
              body: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(children: [
                        const SizedBox(height: 40),
                        TextFormField(
                          obscureText: true,
                          obscuringCharacter: "*",
                          decoration: InputDecoration(
                            labelText: 'Old Password',
                            prefixIcon: Icon(CupertinoIcons.person),
                            // * Hide password
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            prefixIconConstraints: BoxConstraints(
                              minWidth: 40,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your old password';
                            }
                            if (value != prefs.getString('password')) {
                              return 'Password is incorrect';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: profileController.newPasswordController,
                          obscureText: true,
                          obscuringCharacter: "*",
                          decoration: InputDecoration(
                            labelText: 'New Password',
                            prefixIcon: Icon(CupertinoIcons.lock),
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            prefixIconConstraints: BoxConstraints(
                              minWidth: 40,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (value) => value!.isEmpty
                              ? 'Please enter your new password'
                              : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller:
                              profileController.confirmPasswordController,
                          obscureText: true,
                          obscuringCharacter: "*",
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            prefixIcon: Icon(CupertinoIcons.lock),
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            prefixIconConstraints: BoxConstraints(
                              minWidth: 40,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blue,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (value) => value!.isEmpty
                              ? 'Please enter your confirm password'
                              : null,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await profileController.changePassword();

                                  // Get.back();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(15),
                              ),
                              child: const Text('Save Password')),
                        )
                      ]),
                    )),
              ));
        } else {
          return CircularProgressIndicator();
        }
      },
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
                backgroundColor: lightColorScheme.primary,
              ),
              body: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        //if is not null
                        if (prefs.getString('image') != null)
                          CircleAvatar(
                            radius: 70,
                            backgroundImage:
                                NetworkImage(prefs.getString('image')!),
                          ),
                        //reset state

                        if (prefs.getString('image') == null)
                          CircleAvatar(
                            radius: 70,
                            backgroundImage: const AssetImage(
                                'assets/images/solev_banner.jpg'),
                          ),
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.white),
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (image != null) {
                              prefs.remove('image');
                              await profileController.changeImage(image.path);
                              //reset state
                              setState(() {});
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    if (prefs.getString('name') != 'tamu' &&
                        prefs.getString('role') != 'author')
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(15),
                            ),
                            child: const Text('Upgrade to Author')),
                      ),
                    const SizedBox(height: 20),
                    itemProfile('Name', '${prefs.getString('name')}',
                        CupertinoIcons.person),
                    const SizedBox(height: 10),
                    itemProfile('Age', '${prefs.getInt('age')}',
                        CupertinoIcons.calendar),
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
                    //add button upgrade to author

                    if (prefs.getString('name') != 'tamu')
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              Get.to(() => UbahPassword());
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(15),
                            ),
                            child: const Text('Change Password')),
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
