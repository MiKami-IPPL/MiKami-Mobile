import 'package:flutter/material.dart';
import 'package:mikami_mobile/model/list_item_data.dart';
import 'package:mikami_mobile/model/list_data_provider.dart';
import 'chapter_list.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key});

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
                    'Komik Favoritmu!',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.0),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height - 200,
              child: Container(
                // Wrap the ListView with a Container
                color: Colors.white, // Set the background color
                child: ListView.builder(
                  itemCount: ListDataProvider.getFavoriteList().length,
                  itemBuilder: (BuildContext context, int index) {
                    ListItemData itemData =
                        ListDataProvider.getFavoriteList()[index];
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
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
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const ChapterScreen(),
                                  ),
                                );
                              } else if (choice == 'Hapus Dari Favorit') {
                                _showConfirmationDialog(context,
                                    itemData.title); // Show confirmation dialog
                              }
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'Lihat Daftar Chapter',
                                child: Text('Lihat Daftar Chapter'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Hapus Dari Favorit',
                                child: Text('Hapus Dari Favorit'),
                              ),
                            ],
                          ),
                        ),
                        const Divider(), // Add a Divider
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, String comicTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Hapus"),
          content: Text(
              "Apakah Anda yakin ingin menghapus komik '$comicTitle' dari favorit?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                // Perform delete action here
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Hapus"),
            ),
          ],
        );
      },
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
