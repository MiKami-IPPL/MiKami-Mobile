import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mikami_mobile/model/comic.dart';
import 'package:mikami_mobile/services_api/author_service.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class UpdateComic extends StatefulWidget {
  final Comic comic;

  UpdateComic({required this.comic});

  @override
  State<UpdateComic> createState() => _UpdateComicState();
}

class Genre {
  final int id;
  final String name;

  Genre({
    required this.id,
    required this.name,
  });
}

class _UpdateComicState extends State<UpdateComic> {
  final AuthorController authorController =
      Get.put<AuthorController>(AuthorController());
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  List<Genre> _selectedGenres = [];

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

  @override
  void initState() {
    // Set initial selected genres
    _selectedGenres = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Comic'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  controller: authorController.titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    hintText: 'Title',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter title of comic';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  controller: authorController.descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'Description',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter description of comic';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: authorController.rateController,
                  validator: (value) {
                    print('Rate Value: $value');
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
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: authorController.priceController,
                  validator: (value) {
                    print('Price Value: $value');
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
              ),
              // Cover picker
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (image != null) {
                      authorController.coverController.text = image.path;
                    }
                  },
                  child: Text('Pick Cover Image'),
                ),
              ),

              // Genre picker
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: MultiSelectDialogField(
                  items: _genres
                      .map((genre) => MultiSelectItem<Genre>(genre, genre.name))
                      .toList(),
                  initialValue: _selectedGenres,
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
                    setState(() {
                      _selectedGenres = results!;
                    });
                  },
                ),
              ),
              // Submit button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Call update comic method
                    Map<String, dynamic> updatedData = {
                      'title': authorController.titleController.text,
                      'description':
                          authorController.descriptionController.text,
                      'rate': authorController.rateController.text,
                      'price': authorController.priceController.text,
                      'cover': authorController.coverController.text,
                      'genres_id':
                          _selectedGenres.map((genre) => genre.id).toList(),
                    };
                    await authorController.updateComic(
                        widget.comic.id, updatedData);
                  }
                },
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
