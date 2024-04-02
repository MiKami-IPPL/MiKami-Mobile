import 'package:flutter/material.dart';
import 'package:mikami_mobile/model/list_item_data.dart';
import 'package:mikami_mobile/model/list_data_provider.dart';

class ComicVerify extends StatelessWidget {
  const ComicVerify({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[300], 
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
        child: Column(
          children: [
            Container(
              color: Colors.amber[300],
              padding: const EdgeInsets.all(16.0),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ajukan Verifikasi Komik!',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Dapatkan keuntungan untuk setiap chapter dari Komik yang telah diverifikasi',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Container(
                    color: Colors.white, 
                    child: const TabBar(
                      indicatorColor: Colors.red, 
                      tabs: [
                        Tab(text: 'Verified'),
                        Tab(text: 'Not Verified'),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 200,
                    child: Container(
                      color: Colors.white, 
                      child: TabBarView(
                        children: [
                          ListView.builder(
                            itemCount: ListDataProvider.getVerifiedList().length,
                            itemBuilder: (BuildContext context, int index) {
                              ListItemData itemData = ListDataProvider.getVerifiedList()[index];
                              return Column(
                                children: [
                                  ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
                                      style: const TextStyle(
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
                                  const Divider(), 
                                ],
                              );
                            },
                          ),
                          ListView.builder(
                            itemCount: ListDataProvider.getUnverifiedList().length,
                            itemBuilder: (BuildContext context, int index) {
                              ListItemData itemData = ListDataProvider.getUnverifiedList()[index];
                              return Column(
                                children: [
                                  ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
                                      style: const TextStyle(
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
                                  const Divider(),
                                ],
                              );
                            },
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
          
        },
        shape: const StadiumBorder(),
        child: const Icon(Icons.add),
        backgroundColor: Colors.amber, 
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
          style: const TextStyle(
            fontSize: 14.0,
            color: Colors.black54,
          ),
        ),
        Text(
          line2,
          style: const TextStyle(
            fontSize: 14.0,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
