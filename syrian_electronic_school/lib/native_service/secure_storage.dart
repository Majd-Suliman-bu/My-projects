import 'dart:core';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Securestorage {
  // Create storage
  final storage = new FlutterSecureStorage();

  // Write value
  Future<void> save(String key, String value) async {
    await storage.write(key: key, value: value);
  }

  // Read value
  Future<String?> read(String key) async {
    return await storage.read(key: key);
  }

  // Delete value
  Future<void> delete(String key) async {
    await storage.delete(key: key);
  }
}
