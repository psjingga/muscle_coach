/// Hasil satu pemanggilan model: teks JSON + metadata untuk log.
class AiResponse {
  const AiResponse({
    required this.text,
    this.modelVersion,
    this.inputTokens,
    this.outputTokens,
    this.finishReason,
  });

  final String text;
  final String? modelVersion;
  final int? inputTokens;
  final int? outputTokens;
  final String? finishReason;
}

/// Gambar yang ikut dikirim ke model (mis. foto makanan).
class AiImage {
  const AiImage({required this.bytes, required this.mimeType});

  final List<int> bytes;

  /// `image/jpeg`, `image/png`, …
  final String mimeType;
}

/// Abstraksi model generatif (diganti fake di test).
abstract interface class AiClient {
  /// Minta output JSON sesuai [responseSchema]. Melempar `AppFailure`.
  Future<AiResponse> generateJson({
    required String apiKey,
    required String model,
    required String systemInstruction,
    required String userContent,
    required Map<String, Object?> responseSchema,

    /// Gambar pendukung (opsional), dikirim sebelum teks.
    List<AiImage> images = const [],
  });

  /// Cek API key (daftar model). Melempar `AppFailure` bila tidak valid.
  Future<void> verifyKey(String apiKey);
}

/// Penyimpanan API key (terenkripsi) & pilihan model di perangkat.
abstract interface class AiKeyStore {
  Future<String?> read();
  Future<void> write(String key);

  /// Hapus key & pilihan model.
  Future<void> delete();

  Future<String?> readModel();
  Future<void> writeModel(String model);
}
