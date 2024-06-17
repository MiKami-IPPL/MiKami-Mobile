import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:mikami_mobile/services_api/controller/user_service.dart';
import 'dart:convert';
import 'dart:async';

class ReadScreen extends StatefulWidget {
  const ReadScreen({Key? key}) : super(key: key);

  @override
  _ReadScreenState createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen> {
  late Future<void> _chapterDetailFuture;
  List<String> comicImages = [];
  String chapterTitle = 'Chapter Title';

  @override
  void initState() {
    super.initState();
    _chapterDetailFuture = _fetchChapterDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[300],
        title: Text(chapterTitle),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(), 
          child: Column(
            children: comicImages.map((image) {
              return FutureBuilder<Size>(
                future: _getImageSize(image),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final imageSize = snapshot.data!;
                    final screenWidth = MediaQuery.of(context).size.width;
                    final imageHeight = (screenWidth / imageSize.width) * imageSize.height;

                    return Container(
                      width: screenWidth,
                      height: imageHeight,
                      child: Image.network(
                        image,
                        fit: BoxFit.contain,
                      ),
                    );
                  } else {
                    return Container(
                      width: double.infinity,
                      height: 300,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Future<void> _fetchChapterDetail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? comicId = prefs.getInt('comic_id');
    final int? chapterId = prefs.getInt('chapter_id');
    final String? chapterTitle = prefs.getString('chapter_title'); 

    if (chapterTitle != null) {
      setState(() {
        this.chapterTitle = chapterTitle;
      });
    }

    if (comicId != null && chapterId != null) {
      final UserController userService = Get.find<UserController>(); 
      await userService.getChapterDetail(comicId, chapterId);

      
      final String? chapterDetail = prefs.getString('chapterDetail');
      if (chapterDetail != null) {
       
        List<dynamic> details = jsonDecode(chapterDetail);
        setState(() {
          comicImages = details.map((item) => item['image'] as String).toList();
        });
        print('Chapter Detail: $chapterDetail');
      } else {
        print('Chapter Detail is missing');
      }
    } else {
      print('Comic ID or Chapter ID is missing');
    }
  }

  Future<void> _refreshData() async {
    
    await _fetchChapterDetail();
  }

  Future<Size> _getImageSize(String imageUrl) async {
    Completer<Size> completer = Completer();
    Image image = Image.network(imageUrl);
    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        var myImage = info.image;
        completer.complete(Size(myImage.width.toDouble(), myImage.height.toDouble()));
      }),
    );
    return completer.future;
  }
}
