import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mikami_mobile/model/list_item_data.dart';
import 'package:mikami_mobile/model/list_data_provider.dart';
import 'package:mikami_mobile/screens/author/add_comic_screen.dart';
import 'package:mikami_mobile/screens/chapter_manage_screen.dart';
import 'package:mikami_mobile/services_api/controller/author_service.dart';

class AuthorManage extends StatefulWidget {
  const AuthorManage({super.key});

  @override
  State<AuthorManage> createState() => _AuthorManageState();
}

class _AuthorManageState extends State<AuthorManage> {
  AuthorController authorController = Get.put(AuthorController());
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
              length: 2,
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: const TabBar(
                      indicatorColor: Colors.red,
                      tabs: [
                        Tab(text: 'Published'),
                        Tab(text: 'Pending'),
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
                            itemCount:
                                ListDataProvider.getPublishedList().length,
                            itemBuilder: (BuildContext context, int index) {
                              ListItemData itemData =
                                  ListDataProvider.getPublishedList()[index];
                              return GestureDetector(
                                onTap: () {
                                  Get.to(ChapterManageScreen());
                                },
                                child: Column(
                                  children: [
                                    ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
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
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () {
                                              _showConfirmationDialog(
                                                  context, itemData.title);
                                            },
                                          ),
                                          PopupMenuButton<String>(
                                            onSelected: (String choice) {
                                              if (choice ==
                                                  'Lihat Daftar Chapter') {
                                                Get.to(ChapterManageScreen());
                                              } else if (choice ==
                                                  'Hapus Komik') {
                                                _showConfirmationDialog(
                                                    context, itemData.title);
                                              }
                                            },
                                            itemBuilder:
                                                (BuildContext context) =>
                                                    <PopupMenuEntry<String>>[
                                              const PopupMenuItem<String>(
                                                value: 'Lihat Daftar Chapter',
                                                child: Text(
                                                    'Lihat Daftar Chapter'),
                                              ),
                                              const PopupMenuItem<String>(
                                                value: 'Hapus Komik',
                                                child: Text('Hapus Komik'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              );
                            },
                          ),
                          const Center(
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
          Get.to(() => AddComic());
        },
        shape: const StadiumBorder(),
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, String comicTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Hapus"),
          content:
              Text("Apakah Anda yakin ingin menghapus komik '$comicTitle'?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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