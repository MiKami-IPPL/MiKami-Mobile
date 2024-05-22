import 'dart:convert';
import 'package:http/http.dart' as http;

class ChapterUploadService {
  Future<bool> uploadChapter({
    required String title,
    required String subtitle,
    required List<String> imagePaths,
  }) async {
    // Construct the chapter data payload
    Map<String, dynamic> chapterData = {
      'title': title,
      'subtitle': subtitle,
      'images': imagePaths,
      // Add more fields as needed
    };

    // Example API endpoint for uploading chapters
    String apiUrl = 'https://your-api-url.com/upload-chapter';

    try {
      // Send POST request to API endpoint with chapter data
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(chapterData),
      );

      // Check response status code
      if (response.statusCode == 200) {
        // Chapter upload successful
        return true;
      } else {
        // Chapter upload failed
        print('Failed to upload chapter: ${response.body}');
        return false;
      }
    } catch (e) {
      // Exception occurred during API request
      print('Error uploading chapter: $e');
      return false;
    }
  }
}