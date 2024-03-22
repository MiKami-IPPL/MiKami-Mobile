import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryBox extends StatelessWidget {
  const HistoryBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 70,
      child: Row(
        children: [
          SizedBox(
            width: 50,
          ),
          Text(
            '+ 2000',
            style: GoogleFonts.jua(color: Colors.amber),
          ),
          SizedBox(
            width: 150,
          ),
          Text('11/07/2024', style: GoogleFonts.jua(color: Colors.black45)),
        ],
      ),
    );
  }
}
