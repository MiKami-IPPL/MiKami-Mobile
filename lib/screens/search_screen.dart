import 'package:flutter/material.dart';
import 'package:mikami_mobile/theme/theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColorScheme.primary,
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
      body: Column(
        children: [

        ],
      ),
    );
  }
}
