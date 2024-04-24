import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:mikami_mobile/screens/login_screen.dart';
import 'package:mikami_mobile/services_api/author_service.dart';
import 'package:mikami_mobile/services_api/login_service.dart';
import 'package:mikami_mobile/theme/theme.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddComic extends StatefulWidget {
  const AddComic({super.key});

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
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  LoginController loginController = Get.put(LoginController());
  AuthorController authorController = Get.put(AuthorController());
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
  final _items =
      _genres.map((genre) => MultiSelectItem(genre, genre.name)).toList();
  List<Genre> _selectGenre5 = [];
  final _multiSelectKey = GlobalKey<FormFieldState>();
  final _formAddComic = GlobalKey<FormState>();
  @override
  void initState() {
    _selectGenre5 = _genres;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loginController.isLogin(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == false) {
            return LoginScreen();
          } else {
            return AddWidget();
          }
        } else {
          return CircularProgressIndicator();
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
                title: Text('Add Comic'),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    //make formfield
                    Form(
                      key: _formAddComic,
                      child: Column(
                        children: [
                          //add textfield for title
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
                          TextFormField(
                            controller: authorController.coverController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter cover of comic';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Cover',
                              hintText: 'Cover',
                            ),
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
                          //add textfield for genre
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: authorController.rateController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter rate of comic';
                              }
                              //make else if rate is not number
                              else if (double.tryParse(value) == null) {
                                return 'Rate must be a number';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Rate',
                              hintText: 'Rate',
                            ),
                          ),
                          //add textfield for author
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: authorController.priceController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter price of comic';
                              }
                              //make else if price is not number
                              else if (double.tryParse(value) == null) {
                                return 'Price must be a number';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Price',
                              hintText: 'Price',
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: authorController.genreIdController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter genre id of comic';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Genre Id',
                              hintText: 'Genre Id',
                            ),
                          ),

                          // MultiSelectChipField(
                          //   items: prefs.getInt('genre[Max]') == null
                          //       ? _items
                          //       : _items.sublist(
                          //           0, prefs.getInt('genre[name]')),
                          //   initialValue: [_genres[7], _genres[9]],
                          //   title: Text("Genres"),
                          //   headerColor: Colors.blue.withOpacity(0.5),
                          //   decoration: BoxDecoration(
                          //     border: Border.all(
                          //         color: lightColorScheme.onBackground,
                          //         width: 1.8),
                          //   ),
                          //   selectedChipColor: Colors.blue.withOpacity(0.5),
                          //   selectedTextStyle:
                          //       TextStyle(color: Colors.blue[800]),
                          //   onTap: (values) {
                          //     //_selectedAnimals4 = values;
                          //   },
                          // ),

                          //add button for submit
                          ElevatedButton(
                            onPressed: () async {
                              if (_formAddComic.currentState!.validate()) {
                                await authorController.addComic();
                              }
                            },
                            child: Text('Submit'),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
