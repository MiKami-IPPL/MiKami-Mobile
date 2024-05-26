import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:mikami_mobile/screens/user/pengaduan_screen.dart';
import 'package:mikami_mobile/screens/user/profile_screen.dart';
import 'package:mikami_mobile/screens/user/search_screen.dart';
import 'package:mikami_mobile/screens/user/topup_screen.dart';
import 'package:mikami_mobile/screens/auth/welcome_screen.dart';
import 'package:mikami_mobile/services_api/controller/auth_service.dart';
import 'package:mikami_mobile/services_api/controller/profile_service.dart';
import 'package:mikami_mobile/services_api/controller/user_service.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../author/menu_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentSlide = 0;
  ProfileController profileController = Get.put(ProfileController());
  AuthController authcontroller = Get.put(AuthController());
  UserController userController = Get.put(UserController());
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    userController.getRecomendedKomik();
    //return route to login screen if user is not logged in
    return FutureBuilder(
      future: authcontroller.isLogin(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == false) {
            // profileController.logout();
            return WelcomeScreen();
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
      backgroundColor: lightColorScheme.primary,
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
                  SizedBox(height: 40),
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
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (prefs.getString('name') != 'tamu')
                                      Text(
                                          '${prefs.getInt('remainingAds')} iklan tersisa',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          )),
                                    if (prefs.getString('name') == 'tamu')
                                      Text('Silahkan Login',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          )),
                                  ],
                                ),
                                if (prefs.getString('image') != null)
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => ProfileScreen());
                                    },
                                    child: CircleAvatar(
                                      radius: 35,
                                      backgroundImage: NetworkImage(
                                          prefs.getString('image')!),
                                    ),
                                  ),
                                if (prefs.getString('image') == null)
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => ProfileScreen());
                                    },
                                    child: CircleAvatar(
                                      radius: 35,
                                      backgroundImage: AssetImage(
                                          'assets/images/solev_banner.jpg'),
                                    ),
                                  ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (prefs.getString('name') != 'tamu')
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(() => TopupScreen());
                                    },
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
                                            Image.asset(
                                              'assets/images/koin_mikami.png',
                                              width: 30,
                                              height: 30,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              prefs.getInt('coin').toString(),
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (prefs.getString('name') != 'tamu')
                                      GestureDetector(
                                          onTap: () =>
                                              profileController.logout(),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 6),
                                            child: Text(
                                              'Logout',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: lightColorScheme.error,
                                              ),
                                            ),
                                          )),
                                    if (prefs.getString('name') == 'tamu')
                                      GestureDetector(
                                          onTap: () =>
                                              profileController.logout(),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 6),
                                            child: Text(
                                              'Login',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: lightColorScheme.primary,
                                              ),
                                            ),
                                          )),
                                  ],
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
                            //when user tap on search bar, navigate to search screen
                            onTap: () async {
                              await userController.searchKomik();
                              userController.searchController.clear();
                              Get.to(() => SearchScreen());
                            },
                            readOnly: true,
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              hintText: 'Isi Judul Komik yang ingin dibaca',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide(
                                  color: Colors
                                      .white, // Set the outline color to white
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2.0),
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
                    color: lightColorScheme.primary, // Set the background color
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        SizedBox(width: 10), // Add some space at the beginning
                        MenuCard(
                          icon: Icons.report,
                          label: 'Pengaduan',
                          onTap: () {
                            Get.to(() => PengaduanScreen());
                          },
                        ),
                        MenuCard(
                          icon: Icons.account_circle,
                          label: 'Profil',
                          onTap: () => Get.to(() => ProfileScreen()),
                        ),
                        if (prefs.getString('role') == 'author')
                          MenuCard(
                            icon: Icons.auto_stories_sharp,
                            label: 'Menu Author',
                            onTap: () {
                              Get.to(() => AuthorScreen());
                            },
                          ),
                        if (prefs.getString('name') != 'tamu')
                          MenuCard(
                            icon: Icons.monetization_on,
                            label: 'Top Up',
                            onTap: () => Get.to(() => TopupScreen()),
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

                              if (prefs.getInt('rekKomik[Max]') == null)
                                FutureBuilder<void>(
                                  future: userController.getRecomendedKomik(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      return SizedBox.shrink();
                                    }
                                  },
                                ),
                              if (prefs.getInt('rekKomik[Max]') != null)
                                if (prefs.getInt('rekKomik[Max]')! > 4)
                                  for (int i = 0; i < 5; i++)
                                    RoundedImageWithText(
                                      imagePath: prefs
                                          .getString('rekKomik[$i][cover]')!,
                                      text: prefs
                                          .getString('rekKomik[$i][title]')!,
                                    )
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
              Icon(icon, size: 30, color: lightColorScheme.primary),
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
            child: Image.network(
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
