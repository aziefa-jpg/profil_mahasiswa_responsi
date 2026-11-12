import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _prefix = 'note_content_';

  Future<void> saveContent(String noteId, String content) async {
    await _storage.write(key: '$_prefix$noteId', value: content);
    debugPrint('[SecureStorage] Konten untuk ID $noteId berhasil disimpan.');
  }

  Future<String?> getContent(String noteId) async {
    return await _storage.read(key: '$_prefix$noteId');
  }

  Future<void> deleteContent(String noteId) async {
    await _storage.delete(key: '$_prefix$noteId');
    debugPrint('[SecureStorage] Konten untuk ID $noteId berhasil dihapus.');
  }
}