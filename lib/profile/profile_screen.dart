import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mikami_mobile/profile/component/profile_component.dart';
import 'package:mikami_mobile/profile/list_user.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back),
        title: Text(
          'Profile',
          style: GoogleFonts.jua(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(userList[0]["profileImg"]),
            ),
            const SizedBox(
              height: 5,
              width: double.maxFinite,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '@JinXProAmanda',
                  // userList[0]["username"],
                  style: GoogleFonts.jua(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Icon(Icons.edit),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Up to author',
                  style: GoogleFonts.jua(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '99999',
                  style: GoogleFonts.jua(
                      fontSize: 20,
                      color: Colors.amber[600],
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  '(koin icon)',
                  style: GoogleFonts.jua(fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          '178',
                          style: GoogleFonts.jua(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      'Like',
                      style: GoogleFonts.jua(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(
                  width: 100,
                  child: Center(
                    child: Container(
                      width: 0.4,
                      height: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          '5',
                          style: GoogleFonts.jua(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      'Following',
                      style: GoogleFonts.jua(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              width: double.maxFinite,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ProfileBox(item: 'Arthur Shelby', title: 'Name'),
                    ProfileBox(item: '18', title: 'Age'),
                    ProfileBox(item: 'Peaky@gmail.com', title: 'Email'),
                    ProfileBox(item: '080808080808', title: 'Phone'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
