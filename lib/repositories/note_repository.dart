import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../models/note.dart';
import '../services/secure_storage_service.dart';

class NoteRepository {
  static const String _metadataKey = 'notes_metadata';
  final SecureStorageService _secureStorage;

  NoteRepository({SecureStorageService? secureStorage})
      : _secureStorage = secureStorage ?? SecureStorageService();

  Future<List<Note>> getAllNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final rawJson = prefs.getString(_metadataKey);
    if (rawJson == null || rawJson.isEmpty) return [];

    final List decodedList = jsonDecode(rawJson);
    final List<Note> notes = [];

    for (final item in decodedList) {
      final map = Map<String, dynamic>.from(item);
      final id = map['id'].toString();
      final content = await _secureStorage.getContent(id) ?? '';
      notes.add(Note.fromMetadataJson(map, content));
    }
    return notes;
  }

  Future<void> saveNote(Note note) async {
    final prefs = await SharedPreferences.getInstance();
    final currentNotes = await getAllNotes();
    currentNotes.insert(0, note);

    final metadataList = currentNotes.map((n) => n.toMetadataJson()).toList();
    await prefs.setString(_metadataKey, jsonEncode(metadataList));
    await _secureStorage.saveContent(note.id, note.content);
  }

  Future<void> deleteNote(String noteId) async {
    final prefs = await SharedPreferences.getInstance();
    final currentNotes = await getAllNotes();
    currentNotes.removeWhere((n) => n.id == noteId);

    final metadataList = currentNotes.map((n) => n.toMetadataJson()).toList();
    await prefs.setString(_metadataKey, jsonEncode(metadataList));
    await _secureStorage.deleteContent(noteId);
  }

  Future<List> fetchPublicPosts() async {
    final uri = Uri.parse('${AppConfig.baseUrl}/posts?_limit=5');
    try {
      debugPrint('[HTTP] Memulai request GET ke /posts');
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'X-Api-Key': AppConfig.apiKey,
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        debugPrint('[HTTP] Berhasil memuat ${data.length} item referensi.');
        return data.map((e) => Map<String, dynamic>.from(e)).toList();
      } else {
        throw Exception('Gagal memuat data server (Kode: ${response.statusCode})');
      }
    } on SocketException {
      debugPrint('[HTTP Error] Tidak ada koneksi internet.');
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on TimeoutException {
      debugPrint('[HTTP Error] Koneksi timeout.');
      throw Exception('Waktu koneksi habis (Timeout). Silakan coba lagi.');
    } catch (e) {
      debugPrint('[HTTP Error] Terjadi kesalahan tidak terduga.');
      throw Exception('Terjadi kesalahan saat mengambil data: $e');
    }
  }
}
