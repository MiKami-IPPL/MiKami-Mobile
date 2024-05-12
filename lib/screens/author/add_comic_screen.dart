import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mikami_mobile/screens/auth/login_screen.dart';
import 'package:mikami_mobile/services_api/controller/author_service.dart';
import 'package:mikami_mobile/services_api/controller/login_service.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

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
  final LoginController loginController = Get.put(LoginController());
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
  final _items = _genres
      .map((genre) => MultiSelectItem<Genre>(genre, genre.name))
      .toList();
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
          if (snapshot.data == false) {
            return LoginScreen();
          } else {
            return AddWidget();
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget AddWidget() {
    return FutureBuilder(
      future: _prefs,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final SharedPreferences prefs = snapshot.data as SharedPreferences;
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
                    Column(
                      children: [
                        TextFormField(
                          controller: authorController.titleController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter title of comic';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Title',
                            hintText: 'Title',
                          ),
                        ),
                        // add preview image when user click on the button
                        if (prefs.getString('cover_image') != null)
                          Image.file(File(prefs.getString('cover_image')!)),
                        ElevatedButton(
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                                source: ImageSource.gallery);
                            if (image != null) {
                              // Save image to shared preferences
                              prefs.setString('cover_image', image.path);
                            }
                          },
                          child: Text('Pick Cover Image'),
                        ),

                        TextFormField(
                          controller: authorController.descriptionController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter description of comic';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Description',
                            hintText: 'Description',
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: authorController.rateController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter rate of comic';
                            } else if (double.tryParse(value) == null) {
                              return 'Rate must be a number';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Rate',
                            hintText: 'Rate',
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: authorController.priceController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter price of comic';
                            } else if (double.tryParse(value) == null) {
                              return 'Price must be a number';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Price',
                            hintText: 'Price',
                          ),
                        ),
                        MultiSelectDialogField(
                          items: _items,
                          searchable: true,
                          title: Text("Genres"),
                          selectedColor: lightColorScheme.primary,
                          decoration: BoxDecoration(
                            color: lightColorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            border: Border.all(
                              color: lightColorScheme.primary,
                              width: 2,
                            ),
                          ),
                          buttonIcon: Icon(
                            Icons.pets,
                            color: lightColorScheme.primary,
                          ),
                          buttonText: Text(
                            "Choose Genre",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          onConfirm: (results) {
                            _selectedGenre = results;
                            List<String> genreId = [];
                            for (var i = 0; i < _selectedGenre.length; i++) {
                              genreId.add(_selectedGenre[i].id.toString());
                            }
                            authorController.genreIdController.text =
                                genreId.join(',');
                          },
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formAddComic.currentState!.validate()) {
                              await authorController.addComic();
                            } else {
                              Get.snackbar('Error', 'Please fill all field');
                            }
                          },
                          child: Text('Submit'),
                        ),
                      ],
                    ),
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
}
