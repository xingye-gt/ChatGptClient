import 'dart:convert';
import 'dart:io';
import 'package:chat/dal/openai/model/chat_request.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import 'model/chat_response.dart';

class OpenAiRepository {

  static Dio? _dio;

  static Future<ChatResponse?> makeHttpRequest(ChatRequest request) async {
    const String url = 'https://api.openai.com/v1/chat/completions';

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${request.apiKey}'
    };

    final Map<String, dynamic> body = {
      'model': 'gpt-3.5-turbo',
      'messages': [
        {'role': 'user', 'content': '${request.message}'}
      ],
      'temperature': 0.7
    };
    Dio dio = _getDio();
    dio.options.headers = headers;

    final response = await dio.post(url, data: body);
    if (response.statusCode == 200) {
      ChatResponse chatResponse = ChatResponse.fromJson(response.data);
      return chatResponse;
    } else {
      // Request failed
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }

  static Dio _getDio() {
    if (null != _dio) {
      return _dio!;
    }
    _dio = Dio();
    (_dio!.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      //设置代理
      client.findProxy = (uri) {
        return "PROXY 127.0.0.1:7890";
      };
      //校验证书
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
    };
    return _dio!;
  }
}
