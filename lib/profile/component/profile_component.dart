import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileBox extends StatelessWidget {
  final String item;
  final String title;

  const ProfileBox({
    Key? key,
    required this.item,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2, left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              title,
              style:
                  GoogleFonts.jua(fontSize: 13, color: Colors.amber.shade800),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Colors.amber.shade50,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        item,
                        style: GoogleFonts.jua(
                            fontSize: 15,
                            color: Colors.amber.shade700,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
