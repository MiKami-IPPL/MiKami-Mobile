import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mikami_mobile/screens/auth/login_screen.dart';
import 'package:mikami_mobile/services_api/controller/auth_service.dart';
import 'package:mikami_mobile/services_api/controller/profile_service.dart';
import 'package:mikami_mobile/services_api/controller/user_service.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  AuthController authcontroller = Get.put(AuthController());
  ProfileController profileController = Get.put(ProfileController());
  UserController userController = Get.put(UserController());
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

  itemProfile(Widget widget, String title, String subtitle, IconData iconData) {
    return GestureDetector(
      onTap: () async {
        await Get.to(() => widget);
        setState(() {});
      },
      child: Container(
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
      ),
    );
  }

  Widget upgradeWidget(SharedPreferences prefs) {
    //TODO: Implementasi Upgrade to Author form
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    _buildImageRow(
                      prefs,
                      'Identity Card',
                      'identity',
                      'Upload Your Identity Card',
                      'Identity',
                    ),
                    const SizedBox(height: 20),
                    _buildImageRow(
                      prefs,
                      'Certificate Card',
                      'certificate',
                      'Upload Your Certificate Card',
                      'Certificate',
                    ),
                    const SizedBox(height: 20),
                    _buildImageRow(
                      prefs,
                      'Your Selfie',
                      'selfie',
                      'Upload Your Selfie',
                      'Selfie',
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: profileController.bankNameController,
                      labelText: 'Bank Name',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your bank';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: profileController.accountNumberController,
                      labelText: 'Bank Account Number',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your bank number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          prefs.remove('identity');
                          prefs.remove('certificate');
                          prefs.remove('selfie');
                          profileController.bankNameController.clear();
                          profileController.accountNumberController.clear();
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(15),
                        ),
                        child: const Text('Reset'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (prefs.getString('currentLocation') == '' ||
                              prefs.getString('currentLocation') == null) {
                            await userController.handleLocationPermission();
                          }
                          await profileController.upgradeAuthor();
                          Get.to(() => ProfileScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(15),
                        ),
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(Icons.account_balance),
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
      validator: validator,
    );
  }

  Widget _buildImageRow(SharedPreferences prefs, String title, String prefsKey,
      String placeholder, String buttonText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        prefs.getString(prefsKey) != null
            ? Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              )
            : Container(),
        Row(
          children: [
            prefs.getString(prefsKey) != null
                ? Image.file(
                    File(prefs.getString(prefsKey)!),
                    height: 100,
                  )
                : Text(
                    placeholder,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            const SizedBox(width: 20),
            if (prefs.getString(prefsKey) == null)
              ElevatedButton(
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    await prefs.setString(prefsKey, image.path);
                    // //reset state
                    // setState(() {});
                  }
                },
                child: Text(buttonText),
              ),
          ],
        ),
      ],
    );
  }

  Widget EmailWidget(SharedPreferences prefs) {
    return Form(
      key: _formKey,
      child: Scaffold(
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
                TextFormField(
                  controller: profileController.emailController = prefs
                              .getString('email') ==
                          null
                      ? TextEditingController()
                      : TextEditingController(text: prefs.getString('email')),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(CupertinoIcons.mail),
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
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await profileController.changeEmail();
                        Get.back();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                    ),
                    child: const Text('Save Email'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget AgeWidget(SharedPreferences prefs) {
    return Form(
      key: _formKey,
      child: Scaffold(
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
                TextFormField(
                  controller: profileController.ageController =
                      prefs.getInt('age') != null
                          ? TextEditingController(
                              text: prefs.getInt('age').toString())
                          : TextEditingController(),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    labelText: 'Age',
                    prefixIcon: Icon(CupertinoIcons.calendar),
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
                      return 'Please enter your age';
                    }
                    if (value.length > 2) {
                      return 'Age must be 2 digits or less';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await profileController.changeAge();
                          Get.back();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15),
                      ),
                      child: const Text('Save Age')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget UsernameWidget(SharedPreferences prefs) {
    return Form(
      key: _formKey,
      child: Scaffold(
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
                TextFormField(
                  controller: profileController.usernameController = prefs
                              .getString('name') ==
                          null
                      ? TextEditingController()
                      : TextEditingController(text: prefs.getString('name')),
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(CupertinoIcons.person),
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
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await profileController.changeUsername();
                          Get.back();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15),
                      ),
                      child: const Text('Save Username')),
                )
              ],
            ),
          ),
        ),
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
                    const SizedBox(height: 20),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        //if is not null
                        if (prefs.getString('image') != '' &&
                            prefs.getString('image') != null)
                          CircleAvatar(
                            radius: 70,
                            backgroundImage:
                                NetworkImage(prefs.getString('image')!),
                          ),
                        //reset state

                        if (prefs.getString('image') == '')
                          CircleAvatar(
                            radius: 70,
                            backgroundImage: const AssetImage(
                                'assets/images/solev_banner.jpg'),
                          ),
                        if (prefs.getString('name') != 'tamu')
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
                            onPressed: () {
                              Get.to(() => upgradeWidget(prefs));
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(15),
                            ),
                            child: const Text('Upgrade to Author')),
                      ),
                    const SizedBox(height: 20),
                    ListTile(
                      leading: Icon(CupertinoIcons.lock_shield_fill),
                      title: Text('Role'),
                      subtitle: Text(prefs.getString('role') ?? ''),
                    ),
                    const SizedBox(height: 10),
                    if (prefs.getString('name') != 'tamu')
                      itemProfile(UsernameWidget(prefs), 'Username',
                          '${prefs.getString('name')}', CupertinoIcons.person),
                    if (prefs.getString('name') == 'tamu')
                      ListTile(
                        leading: Icon(CupertinoIcons.person),
                        title: Text('Username'),
                        subtitle: Text(prefs.getString('name') ?? ''),
                      ),
                    const SizedBox(height: 10),
                    if (prefs.getString('name') != 'tamu')
                      itemProfile(AgeWidget(prefs), 'Age',
                          '${prefs.getInt('age')}', CupertinoIcons.calendar),
                    if (prefs.getString('name') == 'tamu')
                      ListTile(
                        leading: Icon(CupertinoIcons.calendar),
                        title: Text('Age'),
                        subtitle: Text(prefs.getInt('age').toString() ?? ''),
                      ),
                    const SizedBox(height: 10),

                    if (prefs.getString('name') != 'tamu')
                      itemProfile(EmailWidget(prefs), 'Email',
                          '${prefs.getString('email')}', CupertinoIcons.mail),
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
