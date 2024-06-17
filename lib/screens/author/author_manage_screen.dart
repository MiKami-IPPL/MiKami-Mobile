import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mikami_mobile/screens/author/add_comic_screen.dart';
import 'package:mikami_mobile/screens/author/update_comic_screen.dart';
import 'package:mikami_mobile/services_api/controller/author_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthorManage extends StatefulWidget {
  const AuthorManage({Key? key}) : super(key: key);

  @override
  _AuthorManageState createState() => _AuthorManageState();
}

class _AuthorManageState extends State<AuthorManage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  AuthorController authorcontroller = Get.put(AuthorController());

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  Future<void> _refreshList() async {
    await authorcontroller.getAuthorComics();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _prefs,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error'));
        } else {
          SharedPreferences prefs = snapshot.data as SharedPreferences;
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
            body: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _refreshList,
              child: _buildBody(prefs),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                authorcontroller.titleController.clear();
                authorcontroller.descriptionController.clear();
                authorcontroller.priceController.clear();
                prefs.remove('cover_image');
                Get.to(() => AddComic());
              },
              shape: const StadiumBorder(),
              backgroundColor: Colors.amber,
              child: const Icon(Icons.add),
            ),
          );
        }
      },
    );
  }

  Widget _buildBody(SharedPreferences prefs) {
    return SingleChildScrollView(
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
                  height: MediaQuery.of(context).size.height - 220,
                  child: TabBarView(
                    children: [
                      _buildComicList(prefs),
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
    );
  }

  Widget _buildComicList(SharedPreferences prefs) {
    if (prefs.getInt('authKomik[Max]') == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
        itemCount: prefs.getInt('authKomik[Max]')!,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              authorcontroller.getChapters(prefs.getInt('authKomik[$index][id]')!);
            },
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              leading: Container(
                width: 70,
                height: 70,
                color: Colors.blue,
                child: Image.network(
                  prefs.getString('authKomik[$index][cover]') ?? prefs.getString('image')!,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                prefs.getString('authKomik[$index][title]') ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: ListTileSubtitle(
                line1: 'Deskripsi: ${prefs.getString('authKomik[$index][description]') ?? ''}',
                line2: 'Genre: ${prefs.getString('authKomik[$index][genres]') ?? ''}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _showConfirmationDialog(context, prefs.getInt('authKomik[$index][id]')!, prefs.getString('authKomik[$index][title]')!);
                    },
                  ),
                  PopupMenuButton<String>(
                    onSelected: (String choice) async {
                      if (choice == 'Lihat Daftar Chapter') {
                        await authorcontroller.getChapters(prefs.getInt('authKomik[$index][id]')!);
                      } else if (choice == 'Hapus Komik') {
                        await authorcontroller.deleteComic(prefs.getInt('authKomik[$index][id]')!, prefs.getString('authKomik[$index][title]')!);
                        setState(() {});
                      } else if (choice == 'Update Informasi Komik') {
                        Get.to(() => UpdateComic(comicId: prefs.getInt('authKomik[$index][id]')!));
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
                  )
                ],
              ),
            ),
          );
        },
      );
    }
  }

  void _showConfirmationDialog(BuildContext context, int id, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi Hapus"),
          content: Text("Apakah Anda yakin ingin menghapus komik '${title}'?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () async {
                await authorcontroller.deleteComic(id, title);
                Navigator.of(context).pop();
                setState(() {});
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
