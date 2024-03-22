import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mikami_mobile/topup/list_harga.dart';

class TopUpBox extends StatelessWidget {
  const TopUpBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              hargaList[0]["coin"],
              style: GoogleFonts.jua(
                  fontSize: 25,
                  color: Colors.amber.shade600,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Rp',
                  style: TextStyle(fontSize: 15, color: Colors.black38),
                ),
                Text(
                  hargaList[0]["harga"].toString(),
                  style: const TextStyle(fontSize: 15, color: Colors.black38),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
