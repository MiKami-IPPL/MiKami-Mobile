import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mikami_mobile/screens/login_screen.dart';
import 'package:mikami_mobile/services_api/login_service.dart';
import 'package:mikami_mobile/services_api/user_service.dart';
import 'package:mikami_mobile/theme/theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  LoginController loginController = Get.put(LoginController());
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
            return SearchWidget();
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

Widget SearchWidget() {
  UserController userController = Get.put(UserController());
  return Scaffold(
    backgroundColor: lightColorScheme.primary,
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
    body: Column(
      children: [
        //search bar and button search
        Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: userController.searchController,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                  ),
                  // if press enter on keyboard will trigger search
                  // onSubmitted: () async {
                  //   //search function
                  // },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  await userController.searchKomik();
                },
                child: const Text('Search'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
        //list of search result
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Data ke $index'),
                textColor: lightColorScheme.onPrimary,
              );
            },
          ),
        ),
      ],
    ),
  );
}
