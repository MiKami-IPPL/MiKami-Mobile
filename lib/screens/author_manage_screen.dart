import 'package:flutter/material.dart';
import 'package:mikami_mobile/model/list_item_data.dart';
import 'package:mikami_mobile/model/list_data_provider.dart';

class ManageScreen extends StatelessWidget {
  const ManageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[300], // Set Scaffold background color
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        backgroundColor: Colors.amber[300], // Set AppBar background color
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.amber[300],
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kelola Komik Kamu!',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Lihat Daftar Komik, Hapus Komik, Tambahkan Komik baru',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            DefaultTabController(
              length: 2, // Number of tabs
              child: Column(
                children: [
                  Container(
                    color: Colors.white, // Set TabBar background color
                    child: TabBar(
                      indicatorColor: Colors.red, // Change the color of the tab indicator here
                      tabs: [
                        Tab(text: 'Published'),
                        Tab(text: 'Pending'),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 200,
                    child: Container(
                      color: Colors.white, // Set TabBarView background color
                      child: TabBarView(
                        children: [
                          ListView.builder(
                            itemCount: ListDataProvider.getPublishedList().length,
                            itemBuilder: (BuildContext context, int index) {
                              ListItemData itemData = ListDataProvider.getPublishedList()[index];
                              return Column(
                                children: [
                                  ListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                    leading: Container(
                                      width: 70,
                                      height: 70,
                                      color: Colors.blue,
                                      child: Image.asset(
                                        itemData.imagePath,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    title: Text(
                                      itemData.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: ListTileSubtitle(
                                      line1: itemData.subtitle,
                                      line2: '',
                                    ),
                                    trailing: PopupMenuButton<String>(
                                      onSelected: (String choice) {
                                        // Handle menu item selection
                                        if (choice == 'Lihat Daftar Chapter') {
                                          // Do something
                                        } else if (choice == 'Hapus Komik') {
                                          // Do something else
                                        }
                                      },
                                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                        const PopupMenuItem<String>(
                                          value: 'Lihat Daftar Chapter',
                                          child: Text('Lihat Daftar Chapter'),
                                        ),
                                        const PopupMenuItem<String>(
                                          value: 'Hapus Komik',
                                          child: Text('Hapus Komik'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(), // Add a Divider
                                ],
                              );
                            },
                          ),
                          // Content for Pending tab
                          Center(
                            child: Text('Tidak ada komik yang sedang ditunda'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add onPressed action here
        },
        shape: StadiumBorder(),
        child: Icon(Icons.add),
        backgroundColor: Colors.amber, // Customize button color
      ),
    );
  }
}

class ListTileSubtitle extends StatelessWidget {
  final String line1;
  final String line2;

  const ListTileSubtitle({required this.line1, required this.line2});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          line1,
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.black54,
          ),
        ),
        Text(
          line2,
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
