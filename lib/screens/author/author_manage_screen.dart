import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mikami_mobile/model/comic.dart';
import 'package:mikami_mobile/screens/author/chapter_manage_screen.dart';
import 'package:mikami_mobile/services_api/author_service.dart';
import 'package:mikami_mobile/screens/author/add_comic_screen.dart';
import 'package:mikami_mobile/screens/author/update_comic_screen.dart';

class AuthorManage extends StatefulWidget {
  const AuthorManage({Key? key}) : super(key: key);

  @override
  _AuthorManageState createState() => _AuthorManageState();
}

class _AuthorManageState extends State<AuthorManage> {
  final AuthorController authorController = AuthorController();

  @override
  void initState() {
    super.initState();
    authorController.getComics().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Kelola Komik Kamu!',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Colors.amber[300],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.amber[300],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
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
                    child: TabBar(
                      indicatorColor: Colors.red,
                      tabs: [
                        Tab(text: 'Published'),
                        Tab(text: 'Pending'),
                      ],
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 200,
                    child: TabBarView(
                      children: [
                        _buildComicList(),
                        const Center(
                          child: Text('Tidak ada komik yang sedang ditunda'),
                        ),
                      ],
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

  Widget _buildComicList() {
    if (authorController.comics.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
        itemCount: authorController.comics.length,
        itemBuilder: (context, index) {
          Comic comic = authorController.comics[index];
          return GestureDetector(
            onTap: () {
              Get.to(() => ChapterManageScreen(comic: comic));
            },
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              leading: Container(
                width: 70,
                height: 70,
                color: Colors.blue,
              ),
              title: Text(
                comic.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: ListTileSubtitle(
                line1: comic.description,
                line2: 'Author: ${comic.author}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _showConfirmationDialog(context, comic); // Fix here
                    },
                  ),
                  PopupMenuButton<String>(
                    onSelected: (String choice) {
                      if (choice == 'Lihat Daftar Chapter') {
                        Get.to(() => ChapterManageScreen(comic: comic));
                      } else if (choice == 'Hapus Komik') {
                        _deleteComic(comic.id.toString()); 
                      } else if (choice == 'Update Informasi Komik') {
                        Get.to(UpdateComic(comic: comic));
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'Lihat Daftar Chapter',
                        child: Text('Lihat Daftar Chapter'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Update Informasi Komik',
                        child: Text('Update Informasi Komik'),
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
          );
        },
      );
    }
  }

  void _showConfirmationDialog(BuildContext context, Comic comic) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Hapus"),
          content:
              Text("Apakah Anda yakin ingin menghapus komik '${comic.title}'?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                _deleteComic(comic.id.toString());
                Navigator.of(context).pop();
              },
              child: const Text("Hapus"),
            ),
          ],
        );
      },
    );
  }

  void _deleteComic(String comicId) async {
    String response = await authorController.deleteComic(comicId);
    if (response == 'success') {
      // Show success message
      Get.showSnackbar(GetBar(
        title: "Success",
        message: "Comic successfully deleted",
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.green,
      ));

      await authorController.getComics();
    } else {
      Get.showSnackbar(GetBar(
        title: "Error",
        message: "Failed to delete comic",
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.red,
      ));
    }
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