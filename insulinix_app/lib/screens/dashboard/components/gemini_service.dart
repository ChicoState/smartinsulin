import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String apiKey = 'AIzaSyAxjXBiauJfJdbESA2fQ7f0KJKR4GdJcM8';

  Future<String> sendMessage(String message) async {
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": message}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text = data['candidates'][0]['content']['parts'][0]['text'];
      return text.trim();
    } else {
      print('❌ Gemini error: ${response.statusCode}');
      print('❌ Body: ${response.body}');
      return "Sorry, I couldn't reach the assistant.";
    }
  }
}
