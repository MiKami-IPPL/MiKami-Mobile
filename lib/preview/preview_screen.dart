import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mikami_mobile/preview/component/preview_text.dart';
import 'package:mikami_mobile/preview/sinopsis.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.transparent,
        leading: const Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    height: 295,
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.maxFinite,
                          height: 160,
                          child: Image.network(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT9VaPkZpU3l2qBxoMf4-dMydWeskZgLJ2eY0maRp64xx1FUSNxV9ioY5fCHvnFR3Yp134&usqp=CAU',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          height: 135,
                          color: Colors.white,
                          width: double.maxFinite,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 135, right: 30, top: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 180,
                                      child: Text(
                                        'the seven deadly sins'.toUpperCase(),
                                        style: GoogleFonts.jua(fontSize: 15),
                                        maxLines: 2,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      child: Icon(
                                        Icons.report,
                                        color: Colors.red,
                                      ),
                                    )
                                  ],
                                ),
                                PreviewText(
                                    lable: 'Genre', content: 'ini isi genre'),
                                PreviewText(lable: 'Chapter', content: '23'),
                                PreviewText(
                                    lable: 'Penulis', content: 'Arthur Shelby'),
                                PreviewText(
                                    lable: 'Rating Usia', content: '13+'),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 140, left: 15),
                    child: Container(
                      height: 135,
                      width: 105,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            'https://e1.pxfuel.com/desktop-wallpaper/94/896/desktop-wallpaper-the-seven-deadly-sins-grand-cross-captain-seven-deadly-sins.jpg',
                          ),
                        ),
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 0.3, color: Colors.black38),
                    bottom: BorderSide(width: 3, color: Colors.black26),
                  ),
                ),
                padding: const EdgeInsets.all(10),
                width: double.maxFinite,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '8.4',
                      style: GoogleFonts.jua(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(
                      Icons.star,
                      size: 30,
                      color: Colors.amber,
                    ),
                    const Icon(
                      Icons.star,
                      size: 30,
                      color: Colors.amber,
                    ),
                    const Icon(
                      Icons.star,
                      size: 30,
                      color: Colors.amber,
                    ),
                    const Icon(
                      Icons.star,
                      size: 30,
                      color: Colors.amber,
                    ),
                    const Icon(
                      Icons.star,
                      size: 30,
                      color: Colors.black54,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: 1,
                      height: 50,
                      color: Colors.black54,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.favorite_border_outlined,
                          size: 30,
                          color: Colors.red,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Fav',
                          style: GoogleFonts.jua(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 15, right: 15),
                child: Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Text(
                          'Sinopsis'.toUpperCase(),
                          style: GoogleFonts.jua(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 10, left: 10, right: 10),
                        child: Text(
                          // textAlign: TextAlign.center,
                          sinList[0]['sinopsis'].toUpperCase(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.jua(fontSize: 13),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.amber.shade400,
                      borderRadius:
                          const BorderRadius.all(Radius.elliptical(15, 15))),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8, bottom: 8, left: 10, right: 10),
                    child: Text(
                      'buka'.toUpperCase(),
                      style: GoogleFonts.jua(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
