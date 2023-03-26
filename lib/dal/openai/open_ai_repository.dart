import 'dart:io';
import 'package:chat/dal/openai/model/chat_request.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import 'model/chat_response.dart';

class OpenAiRepository {
  static Dio? _dio;

  static Future<void> init(String? proxyIp, String? proxyPort) async {
    _dio = _newDio(proxyIp, proxyPort);
    return;
  }

  static Future<void> updateProxy(String? proxyIp, String? proxyPort) async {
    _dio = _newDio(proxyIp, proxyPort);
    return;
  }

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
    Dio dio = _getDio(null, null);
    dio.options.headers = headers;

    final google = await dio.get("https://www.google.com");
    //try catch
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        ChatResponse chatResponse = ChatResponse.fromJson(response.data);
        return chatResponse;
      } else {
        // Request failed
        print('Request failed with status: ${response.statusCode}.');
        return null;
      }
    } catch (e) {
      print("$e");
      return null;
    }
  }

  static Future<bool> checkConnection(String proxyIp, String proxyPort) async {
    Dio dio = _newDio(proxyIp, proxyPort);
    try {
      await dio.get("https://api.openai.com/v1/models");
      return true;
    } on DioError catch (e) {
      if (e.type == DioErrorType.badResponse) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Dio _getDio(String? proxyIp, String? proxyPort) {
    if (null != _dio) {
      return _dio!;
    }
    _dio = _newDio(proxyIp, proxyPort);
    return _dio!;
  }

  ///创建dio对象
  static Dio _newDio(String? proxyIp, String? proxyPort) {
    Dio dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 30);
    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (client) {
      if (null != proxyIp &&
          proxyIp.isNotEmpty &&
          null != proxyPort &&
          proxyPort.isNotEmpty) {
        //设置代理
        client.findProxy = (uri) {
          return "PROXY $proxyIp:$proxyPort";
        };
        //校验证书
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) {
          return true;
        };
      }
    };
    return dio;
  }
}
