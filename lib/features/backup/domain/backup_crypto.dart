import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

/// Kata sandi salah atau berkas rusak/diubah (autentikasi AES-GCM gagal).
class BackupPasswordException implements Exception {
  const BackupPasswordException();
}

/// Bukan berkas cadangan Muscle Coach / versi format tidak dikenal.
class BackupFormatException implements Exception {
  const BackupFormatException(this.reason);

  final String reason;

  @override
  String toString() => 'BackupFormatException($reason)';
}

/// Enkripsi berkas cadangan: AES-256-GCM, kunci dari kata sandi lewat
/// PBKDF2-HMAC-SHA256. Header (magic, versi, iterasi, salt, nonce) ikut
/// diautentikasi sebagai AAD sehingga perubahan header terdeteksi.
///
/// Tata letak: `MCBK` | versi(1) | iterasi(u32 BE) | salt(16) | nonce(12) |
/// ciphertext | mac(16).
abstract final class BackupCrypto {
  static final _magic = ascii.encode('MCBK');
  static const formatVersion = 1;
  static const defaultIterations = 210000;
  static const minPasswordLength = 8;
  static const _saltLength = 16;
  static const _nonceLength = 12;
  static const _macLength = 16;
  static const _headerLength = 4 + 1 + 4 + _saltLength + _nonceLength;

  static final _aes = AesGcm.with256bits();

  static Future<SecretKey> _key(String password, List<int> salt, int iterations) => Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: iterations,
    bits: 256,
  ).deriveKeyFromPassword(password: password, nonce: salt);

  static List<int> _random(int n) {
    final r = Random.secure();
    return List<int>.generate(n, (_) => r.nextInt(256));
  }

  /// Apakah [bytes] tampak seperti berkas cadangan (cek magic saja).
  static bool looksLikeBackup(List<int> bytes) =>
      bytes.length > _headerLength + _macLength &&
      List.generate(4, (i) => bytes[i]).join(',') == _magic.join(',');

  static Future<Uint8List> encrypt(
    List<int> plain,
    String password, {
    int iterations = defaultIterations,
  }) async {
    final salt = _random(_saltLength);
    final nonce = _random(_nonceLength);
    final header = BytesBuilder()
      ..add(_magic)
      ..addByte(formatVersion)
      ..add((ByteData(4)..setUint32(0, iterations)).buffer.asUint8List())
      ..add(salt)
      ..add(nonce);
    final headerBytes = header.toBytes();
    final box = await _aes.encrypt(
      plain,
      secretKey: await _key(password, salt, iterations),
      nonce: nonce,
      aad: headerBytes,
    );
    return (BytesBuilder(copy: false)
          ..add(headerBytes)
          ..add(box.cipherText)
          ..add(box.mac.bytes))
        .toBytes();
  }

  /// Melempar [BackupFormatException] atau [BackupPasswordException].
  static Future<Uint8List> decrypt(Uint8List data, String password) async {
    if (!looksLikeBackup(data)) throw const BackupFormatException('magic');
    final version = data[4];
    if (version != formatVersion) throw BackupFormatException('version-$version');
    final iterations = ByteData.sublistView(data, 5, 9).getUint32(0);
    if (iterations < 1000 || iterations > 5000000) {
      throw const BackupFormatException('iterations');
    }
    final salt = data.sublist(9, 9 + _saltLength);
    final nonce = data.sublist(9 + _saltLength, _headerLength);
    final cipher = data.sublist(_headerLength, data.length - _macLength);
    final mac = data.sublist(data.length - _macLength);
    try {
      final plain = await _aes.decrypt(
        SecretBox(cipher, nonce: nonce, mac: Mac(mac)),
        secretKey: await _key(password, salt, iterations),
        aad: data.sublist(0, _headerLength),
      );
      return Uint8List.fromList(plain);
    } on SecretBoxAuthenticationError {
      throw const BackupPasswordException();
    }
  }
}
