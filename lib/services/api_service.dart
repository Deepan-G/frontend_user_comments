import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = "http://192.168.1.129:3000";

class ApiService {
  /// Fetch all comments
  static Future<Map<String, String>> fetchComments() async {
    try {
      final url = Uri.parse("$baseUrl/comment_get");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return {
          for (var item in data)
            item["selected_text"].toString(): item["comment"].toString()
        };
      } else {
        throw Exception("Failed to fetch comments: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching comments: $e");
    }
  }

  /// Add a comment
  static Future<void> addComment(String selectedText, String comment) async {
    try {
      final url = Uri.parse("$baseUrl/comment_post");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "selected_text": selectedText,
          "comment": comment,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to save comment: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error saving comment: $e");
    }
  }
}
