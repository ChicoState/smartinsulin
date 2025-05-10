import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiApi {
  final String apiKey = 'ADD api key here'; 

  Future<String> sendMessage(String userMessage) async {
    final Uri url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1/models/gemini-1.5-pro:generateContent?key=$apiKey'); 

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "role": "user",
            "parts": [
              {"text": userMessage}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['candidates'][0]['content']['parts'][0]['text'];
      return content.trim();
    } else {
      print('❌ Gemini API error ${response.statusCode}: ${response.body}');
      return "Sorry, I couldn't connect to the assistant.";
    }
  }
}
