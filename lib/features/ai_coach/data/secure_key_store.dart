import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../domain/ai_client.dart';

/// API key Gemini di Android Keystore / iOS Keychain (bukan di basis data,
/// APK, atau repo).
class SecureAiKeyStore implements AiKeyStore {
  SecureAiKeyStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  static const _key = 'gemini_api_key';
  static const _modelKey = 'gemini_model';

  @override
  Future<String?> read() => _storage.read(key: _key);

  @override
  Future<void> write(String key) => _storage.write(key: _key, value: key.trim());

  @override
  Future<void> delete() async {
    await _storage.delete(key: _key);
    await _storage.delete(key: _modelKey);
  }

  @override
  Future<String?> readModel() => _storage.read(key: _modelKey);

  @override
  Future<void> writeModel(String model) => _storage.write(key: _modelKey, value: model);
}
