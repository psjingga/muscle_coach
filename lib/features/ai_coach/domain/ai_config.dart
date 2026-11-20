/// Konfigurasi integrasi Gemini (dipanggil langsung dari aplikasi dengan API
/// key milik pengguna yang disimpan terenkripsi di perangkat).
abstract final class AiConfig {
  static const baseUrl = 'https://generativelanguage.googleapis.com/v1beta';

  /// Model default & pilihan di Pengaturan. Uji live (19 Nov 2026, prompt
  /// workout_plan.v1): flash-lite valid 4/4 dalam 5–12 dtk; 3.5-flash (thinking)
  /// lebih lambat — 35 dtk s.d. timeout 120 dtk / 503 saat sibuk.
  static const defaultModel = 'gemini-3.5-flash-lite';
  static const models = ['gemini-3.5-flash-lite', 'gemini-3.5-flash', 'gemini-flash-lite-latest'];

  static const requestTimeout = Duration(seconds: 120);

  /// Tingkat penalaran model (null = bawaan). Dipilih dari uji latensi live.
  static const String? thinkingLevel = null;
  static const maxOutputTokens = 16384;
  static const temperature = 0.4;

  /// Maksimal 1 retry terkontrol bila output tidak valid.
  static const maxAttempts = 2;

  /// Kuota lokal untuk menahan biaya.
  static const dailyGenerationLimit = 10;

  /// Versi teks persetujuan pemrosesan data oleh AI. v2 (20 Nov 2026): mencakup
  /// menu harian & ringkasan mingguan → pengguna diminta menyetujui ulang.
  static const consentVersion = '2026-11-v2';
  static const consentId = 'ai_processing';
}
