import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'package:chat/dal/openai/model/general_request.dart';
import 'package:http/http.dart' as http;

class OpenAiRepository {
  static Future<void> makeHttpRequest(GeneralRequest request) async {
    final String url = 'https://api.openai.com/v1/chat/completions';
    final String apiKey = 'YOUR_OPENAI_API_KEY';

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${request.apiKey}'
    };

    final Map<String, dynamic> body = {
      'model': 'gpt-3.5-turbo',
      'messages': [
        {'role': 'user', 'content': 'Say this is a test!'}
      ],
      'temperature': 0.7
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      // Request successful, parse response body
      final responseData = json.decode(response.body);
      print("open ai responseData:$responseData");
    } else {
      // Request failed
      print('Request failed with status: ${response.statusCode}.');
    }
  }
}
