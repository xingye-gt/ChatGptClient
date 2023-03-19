import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const String keyOpenAiToken = "openAiToken";

  //instance
  static final SecureStorage _instance = SecureStorage._internal();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  //private constructor
  SecureStorage._internal();

  //factory
  factory SecureStorage() {
    return _instance;
  }

  static Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  static Future<String> read(String key) async {
    return await _storage.read(key: key) ?? '';
  }

  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }
}
