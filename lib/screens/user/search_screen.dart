import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mikami_mobile/screens/auth/login_screen.dart';
import 'package:mikami_mobile/services_api/controller/auth_service.dart';
import 'package:mikami_mobile/services_api/controller/user_service.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  AuthController authcontroller = Get.put(AuthController());
  UserController usercontroller = Get.put(UserController());
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
          return searchScreenContent();
        } else {
          return LoginScreen();
        }
      },
    );
  }

  Widget searchScreenContent() {
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
            backgroundColor: lightColorScheme.primary,
            appBar: AppBar(
              title: const Text('Search Komik'),
              iconTheme: const IconThemeData(color: Colors.white),
              titleTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              backgroundColor: lightColorScheme.primary,
              elevation: 0,
              flexibleSpace: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                color: lightColorScheme.primary,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  buildSearchBar(),
                  const SizedBox(height: 20),
                  Expanded(
                    child: prefs.getInt('dataKomik[Max]') != 0
                        ? listData(prefs)
                        : buildNoDataFound(),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: const Text('Error loading preferences'),
            ),
          );
        }
      },
    );
  }

  Widget buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SearchBar(
              controller: usercontroller.searchController,
              hintText: 'Search',
              onSubmitted: (value) async {
                await usercontroller.searchKomik();
                setState(() {});
              },
            ),
          ),
        ),
        IconButton(
          onPressed: () async {
            await usercontroller.searchKomik();
            setState(() {});
          },
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }

  Widget buildNoDataFound() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text(
          'Data not found',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget listData(SharedPreferences prefs) {
    return ListView.builder(
      itemCount: prefs.getInt('dataKomik[Max]') ?? 0,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            prefs.remove('selectedID');
            prefs.remove('selectedTitle');
            prefs.setInt('selectedID', prefs.getInt('dataKomik[$index][id]')!);
            prefs.setString(
                'selectedTitle', prefs.getString('dataKomik[$index][title]')!);
            Get.back();
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            padding: const EdgeInsets.all(10.0),
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
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      prefs.getString('dataKomik[$index][cover]')!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prefs.getString('dataKomik[$index][title]') ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Deskripsi: ${prefs.getString('dataKomik[$index][description]') ?? ''}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        prefs.getString('dataKomik[$index][genres]') ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${prefs.getInt('dataKomik[$index][price]') ?? 0} Koin',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}