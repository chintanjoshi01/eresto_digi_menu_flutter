import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

/// Secure AES-256 Encryption Service for protecting sensitive diagnostic reports
class EncryptionService {
  // Secret key seed for diagnostic payload encryption
  static const String _secretSeed = "ErestoDigiMenuDiagReportSecretKey2026!#\$";

  /// Derived 32-byte (256-bit) AES key from secret seed using SHA-256
  static encrypt.Key get _key {
    final bytes = utf8.encode(_secretSeed);
    final digest = sha256.convert(bytes);
    return encrypt.Key(Uint8List.fromList(digest.bytes));
  }

  /// Encrypt a JSON map into a secure Base64 encrypted payload string
  static String encryptJson(Map<String, dynamic> jsonMap) {
    final jsonString = jsonEncode(jsonMap);
    return encryptText(jsonString);
  }

  /// Decrypt a Base64 encrypted payload string back into a JSON map
  static Map<String, dynamic>? decryptJson(String cipherText) {
    try {
      final decryptedText = decryptText(cipherText);
      if (decryptedText.isEmpty) return null;
      return jsonDecode(decryptedText) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// Encrypt plain text using AES-256-CBC with prefixed 16-byte random IV
  static String encryptText(String plainText) {
    if (plainText.isEmpty) return "";
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(_key, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: iv);

    // Combine IV (16 bytes) + CipherText into a single Base64 string
    final combinedBytes = Uint8List(iv.bytes.length + encrypted.bytes.length);
    combinedBytes.setRange(0, iv.bytes.length, iv.bytes);
    combinedBytes.setRange(iv.bytes.length, combinedBytes.length, encrypted.bytes);

    return base64.encode(combinedBytes);
  }

  /// Decrypt Base64 encrypted payload string (IV + CipherText) back to plain text
  static String decryptText(String combinedBase64) {
    try {
      final combinedBytes = base64.decode(combinedBase64.trim());
      if (combinedBytes.length <= 16) return "";

      final ivBytes = combinedBytes.sublist(0, 16);
      final cipherBytes = combinedBytes.sublist(16);

      final iv = encrypt.IV(ivBytes);
      final encrypted = encrypt.Encrypted(cipherBytes);
      final encrypter = encrypt.Encrypter(encrypt.AES(_key, mode: encrypt.AESMode.cbc));

      return encrypter.decrypt(encrypted, iv: iv);
    } catch (e) {
      return "";
    }
  }
}
