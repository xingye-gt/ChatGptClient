import 'dart:convert';
import 'dart:io';
import 'package:chat/dal/openai/model/general_request.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class OpenAiRepository {

  static Dio? _dio;

  static Future<void> makeHttpRequest(GeneralRequest request) async {
    final String url = 'https://api.openai.com/v1/chat/completions';
    final String google = "https://www.google.com";
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
    Dio dio = _getDio();
    dio.options.headers = headers;

    final response = await dio.post(url, data: body);

    // final response = await ioClient.post(
    //   Uri.parse(google),
    //   headers: headers,
    //   body: json.encode(body),
    // );

    if (response.statusCode == 200) {
      // Request successful, parse response body
      //final responseData = json.decode(response.body);
      print("open ai responseData:$response");
    } else {
      // Request failed
      print('Request failed with status: ${response.statusCode}.');
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
