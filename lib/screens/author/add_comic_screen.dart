import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mikami_mobile/screens/auth/login_screen.dart';
import 'package:mikami_mobile/services_api/controller/author_service.dart';
import 'package:mikami_mobile/services_api/controller/auth_service.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class AddComic extends StatefulWidget {
  const AddComic({Key? key}) : super(key: key);

  @override
  State<AddComic> createState() => _AddComicState();
}

class Genre {
  final int id;
  final String name;

  Genre({
    required this.id,
    required this.name,
  });
}

class _AddComicState extends State<AddComic> {
  final AuthorController authorController = Get.put(AuthorController());
  final AuthController loginController = Get.put(AuthController());
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static List<Genre> _genres = [
    Genre(id: 1, name: 'Action'),
    Genre(id: 2, name: 'Adventure'),
    Genre(id: 3, name: 'Comedy'),
    Genre(id: 4, name: 'Drama'),
    Genre(id: 5, name: 'Fantasy'),
    Genre(id: 6, name: 'Horror'),
    Genre(id: 7, name: 'Mystery'),
    Genre(id: 8, name: 'Romance'),
    Genre(id: 9, name: 'Science Fiction'),
    Genre(id: 10, name: 'Slice of Life'),
    Genre(id: 11, name: 'Thriller'),
  ];

  final _items = _genres.map((genre) => MultiSelectItem<Genre>(genre, genre.name)).toList();
  List<Genre> _selectedGenre = [];
  final _formAddComic = GlobalKey<FormState>();

  @override
  void initState() {
    _selectedGenre = _genres;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: loginController.isLogin(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data == false ? LoginScreen() : AddWidget();
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget AddWidget() {
    return FutureBuilder<SharedPreferences>(
      future: _prefs,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final SharedPreferences prefs = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text('Upload Komik'),
              backgroundColor: Colors.amber[300],
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formAddComic,
                child: ListView(
                  children: [
                    buildTextFormField(
                      controller: authorController.titleController,
                      label: 'Title',
                      hint: 'Title',
                      validator: (value) => value == null || value.isEmpty ? 'Please enter title of comic' : null,
                    ),
                    buildTextFormField(
                      controller: authorController.descriptionController,
                      label: 'Description',
                      hint: 'Description',
                      validator: (value) => value == null || value.isEmpty ? 'Please enter description of comic' : null,
                    ),
                    buildTextFormField(
                      controller: authorController.rateController,
                      label: 'Rate',
                      hint: 'Rate',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter rate of comic';
                        if (double.tryParse(value) == null) return 'Rate must be a number';
                        return null;
                      },
                    ),
                    buildTextFormField(
                      controller: authorController.priceController,
                      label: 'Price',
                      hint: 'Price',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter price of comic';
                        if (double.tryParse(value) == null) return 'Price must be a number';
                        return null;
                      },
                    ),
                    buildImagePickerButton(prefs),
                    buildGenrePicker(),
                    buildSubmitButton(),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
        ),
      ),
    );
  }

  Widget buildImagePickerButton(SharedPreferences prefs) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: ElevatedButton(
        onPressed: () async {
          final ImagePicker picker = ImagePicker();
          final XFile? image = await picker.pickImage(source: ImageSource.gallery);
          if (image != null) {
            final Directory appDir = await getApplicationDocumentsDirectory();
            final String appPath = appDir.path;
            final String fileName = image.name;
            final String savedImagePath = '$appPath/$fileName';
            final File savedImage = File(savedImagePath);
            await savedImage.writeAsBytes(await image.readAsBytes());

            authorController.coverController.text = savedImagePath;
            prefs.setString('cover_image', savedImagePath);
          }
        },
        child: Text('Pick Cover Image'),
      ),
    );
  }

  Widget buildGenrePicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: MultiSelectDialogField(
        items: _items,
        searchable: true,
        title: Text("Genres"),
        selectedColor: lightColorScheme.primary,
        decoration: BoxDecoration(
          color: lightColorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(40)),
          border: Border.all(color: lightColorScheme.primary, width: 2),
        ),
        buttonIcon: Icon(Icons.pets, color: lightColorScheme.primary),
        buttonText: Text(
          "Choose Genre",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        onConfirm: (results) {
          _selectedGenre = results;
          List<String> genreId = _selectedGenre.map((genre) => genre.id.toString()).toList();
          authorController.genreIdController.text = genreId.join(',');
        },
      ),
    );
  }

  Widget buildSubmitButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_formAddComic.currentState!.validate()) {
          await authorController.addComic();
        } else {
          Get.snackbar('Error', 'Please fill all fields');
        }
      },
      child: Text('Submit'),
    );
  }
}
