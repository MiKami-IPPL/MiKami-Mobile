import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:mikami_mobile/screens/login_screen.dart';
import 'package:mikami_mobile/screens/profile_screen.dart';
import 'package:mikami_mobile/screens/topup_screen.dart';
import 'package:mikami_mobile/services_api/login_service.dart';
import 'package:mikami_mobile/services_api/profile_service.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'comic_favorite_screen.dart';
import 'author_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentSlide = 0;
  ProfileController profileController = Get.put(ProfileController());
  LoginController loginController = Get.put(LoginController());
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    //return route to login screen if user is not logged in
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
            return HomeWidget();
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget HomeWidget() {
    return Scaffold(
      backgroundColor: Colors.amber[300],
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _prefs,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final SharedPreferences prefs =
                  snapshot.data as SharedPreferences;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Halo, ${prefs.getString('name')}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Anda memiliki ${prefs.getInt('remainingAds')} iklan tersisa',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () => Get.to(ProfileScreen()),
                                  child: CircleAvatar(
                                    radius: 35,
                                    backgroundImage:
                                        AssetImage('assets/images/seulgi.jpg'),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () => profileController.logout(),
                                  child: Text(
                                    'logout',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: lightColorScheme.secondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            // baris coin
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
                                      'Koin anda:',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () => Get.to(TopupScreen()),
                                  child: Container(
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
                                              fontSize: 20,
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
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 40,
                          child: TextFormField(
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              hintText: 'Isi Judul Komik yang ingin dibaca',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 2.0),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Jelajahi Komik Yang Sedang Hangat!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 200.0,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      pauseAutoPlayOnTouch: true,
                      viewportFraction: 1.0,
                      enlargeCenterPage: false,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentSlide = index;
                        });
                      },
                    ),
                    items: [
                      'assets/images/maxlevel_banner.jpg',
                      'assets/images/secondlife_banner.png',
                      'assets/images/solev_banner.jpg',
                    ].map((String imagePath) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8.0),
                              image: DecorationImage(
                                image: AssetImage(imagePath),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < 3; i++)
                        IndicatorDot(isActive: i == _currentSlide),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 100, // Adjust the height of the menu row
                    color: Colors.amber[600], // Set the background color
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        SizedBox(width: 10), // Add some space at the beginning
                        MenuCard(
                          icon: Icons.favorite,
                          label: 'Komik Favorit',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ComicFavorite()),
                            );
                          },
                        ),
                        MenuCard(
                          icon: Icons.monetization_on,
                          label: 'Top Up',
                          onTap: () => Get.to(TopupScreen()),
                        ),
                        MenuCard(
                          icon: Icons.account_circle,
                          label: 'Profil',
                          onTap: () => Get.to(ProfileScreen()),
                        ),
                        if (prefs.getString('role') == 'author')
                          MenuCard(
                            icon: Icons.auto_stories_sharp,
                            label: 'Menu Author',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AuthorScreen()),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rekomendasi Untukmu',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          height: 200, // Adjust the height of the row
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              SizedBox(
                                  width: 10), // Add some space at the beginning
                              RoundedImageWithText(
                                imagePath: 'assets/images/solev_poster.png',
                                text: 'Solo Leveling',
                              ),
                              RoundedImageWithText(
                                imagePath: 'assets/images/maxlevel_poster.jpg',
                                text: 'Max Level Hero',
                              ),
                              RoundedImageWithText(
                                imagePath:
                                    'assets/images/secondlife_poster.jpg',
                                text: 'Second Life Ranker',
                              ),
                              RoundedImageWithText(
                                imagePath: 'assets/images/beginning_poster.jpg',
                                text: 'The Beginning After The End',
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Penuh Aksi',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          height: 200,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              SizedBox(width: 10),
                              RoundedImageWithText(
                                imagePath: 'assets/images/solev_poster.png',
                                text: 'Solo Leveling',
                              ),
                              RoundedImageWithText(
                                imagePath: 'assets/images/maxlevel_poster.jpg',
                                text: 'Max Level Hero',
                              ),
                              RoundedImageWithText(
                                imagePath:
                                    'assets/images/secondlife_poster.jpg',
                                text: 'Second Life Ranker',
                              ),
                              RoundedImageWithText(
                                imagePath: 'assets/images/beginning_poster.jpg',
                                text: 'The Beginning After the End',
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Promo Hari Ini',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5, left: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.asset(
                              'assets/images/menuBanner.png',
                              width: 400,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const MenuCard({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Navigate to the desired screen when tapped
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
          width: 120, // Adjust the width of each card
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: Colors.amber),
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoundedImageWithText extends StatelessWidget {
  final String imagePath;
  final String text;

  const RoundedImageWithText({required this.imagePath, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(
              imagePath,
              height: 150,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 5),
        Container(
          width: 100,
          height: 40, // Adjust the height as needed
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class IndicatorDot extends StatelessWidget {
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;

  const IndicatorDot(
      {required this.isActive,
      this.activeColor = Colors.white,
      this.inactiveColor = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      width: 8.0,
      height: 8.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? activeColor : inactiveColor,
      ),
    );
  }
}
