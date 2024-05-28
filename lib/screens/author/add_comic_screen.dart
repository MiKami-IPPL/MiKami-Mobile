import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mikami_mobile/screens/auth/login_screen.dart';
import 'package:mikami_mobile/services_api/controller/auth_service.dart';
import 'package:mikami_mobile/services_api/controller/author_service.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final AuthController authcontroller = Get.put(AuthController());
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
      future: authcontroller.isLogin(),
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
              title: Text('Upload Comic'),
              backgroundColor: lightColorScheme.primary,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formAddComic,
                child: ListView(
                  children: [
                    _buildTextField(
                      controller: authorController.titleController,
                      label: 'Title',
                      hint: 'Enter the title of the comic',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the title of the comic';
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^[a-zA-Z0-9\s]+$')),
                      ],
                    ),
                    SizedBox(height: 10),
                    _buildImagePicker(prefs),
                    SizedBox(height: 20),
                    _buildTextField(
                      controller: authorController.descriptionController,
                      label: 'Description',
                      hint: 'Enter the description of the comic',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the description of the comic';
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^[a-zA-Z0-9\s]+$')),
                      ],
                    ),
                    SizedBox(height: 10),
                    _buildTextField(
                      controller: authorController.priceController,
                      label: 'Price',
                      hint: 'Enter the price of the comic',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the price of the comic';
                        } else if (double.tryParse(value) == null) {
                          return 'Price must be a number';
                        }
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                    ),
                    SizedBox(height: 20),
                    _buildGenreSelector(),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formAddComic.currentState!.validate()) {
                          await authorController.addComic();
                        } else {
                          Get.snackbar('Error', 'Please fill all fields');
                        }
                      },
                      child: Text('Submit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: lightColorScheme.primary,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        textStyle: TextStyle(fontSize: 16),
                      ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
    required List<TextInputFormatter> inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildImagePicker(SharedPreferences prefs) {
    return Column(
      children: [
        prefs.getString('cover_image') != null
            ? Image.file(
                File(prefs.getString('cover_image')!),
                height: 200,
              )
            : Container(),
        SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () async {
            final ImagePicker picker = ImagePicker();
            final XFile? image =
                await picker.pickImage(source: ImageSource.gallery);
            if (image != null) {
              prefs.setString('cover_image', image.path);
              setState(() {});
            }
          },
          icon: Icon(Icons.image),
          label: Text('Pick Cover Image'),
          style: ElevatedButton.styleFrom(
            backgroundColor: lightColorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildGenreSelector() {
    return MultiSelectDialogField(
      items: _items,
      searchable: true,
      title: Text("Genres"),
      selectedColor: lightColorScheme.primary,
      decoration: BoxDecoration(
        color: Colors.amber[100],
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: lightColorScheme.primary,
          width: 2,
        ),
      ),
      buttonIcon: Icon(
        Icons.category,
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
        authorController.genreIdController.text = genreId.join(',');
      },
    );
  }
}
