import 'package:flutter/material.dart';

class TamuScreen extends StatefulWidget {
  const TamuScreen({super.key});

  @override
  State<TamuScreen> createState() => _TamuScreenState();
}

class _TamuScreenState extends State<TamuScreen> {
  @override
  Widget build(BuildContext context) {
    //buatkan homepage untuk tamu yang memiliki navbar bottom dan appbar
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mikami'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Ini homepage untuk tamu'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Cari',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
