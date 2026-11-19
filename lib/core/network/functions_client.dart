import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

import '../errors/failure_mapper.dart';
import '../logging/app_logger.dart';

/// Pembungkus Cloud Functions callable. SDK otomatis menyertakan token
/// Firebase Auth (dan App Check bila aktif). Error dipetakan ke
/// `AppFailure` dengan kode stabil.
class FunctionsClient {
  FunctionsClient(this._functions);

  final FirebaseFunctions _functions;

  static const defaultTimeout = Duration(seconds: 30);

  Future<Map<String, Object?>> call(
    String name, {
    Map<String, Object?>? data,
    Duration timeout = defaultTimeout,
  }) async {
    try {
      final result = await _functions
          .httpsCallable(name, options: HttpsCallableOptions(timeout: timeout))
          .call<Object?>(data);
      return normalizeMap(result.data);
    } catch (e) {
      final failure = FailureMapper.from(e);
      // Detail mentah hanya di debug; jangan log payload (bisa berisi data kesehatan).
      final detail = kDebugMode && e is FirebaseFunctionsException ? ' (${e.message})' : '';
      appLogger.w('Callable $name gagal: ${failure.debugMessage ?? failure.kind.name}$detail');
      throw failure;
    }
  }

  /// Data callable berupa `Map<Object?, Object?>` bersarang; ubah menjadi
  /// `Map<String, Object?>` agar mudah di-parse model JSON.
  static Map<String, Object?> normalizeMap(Object? value) {
    if (value is! Map) return const {};
    return {for (final e in value.entries) e.key.toString(): _normalize(e.value)};
  }

  static Object? _normalize(Object? value) => switch (value) {
    Map() => normalizeMap(value),
    List() => [for (final v in value) _normalize(v)],
    _ => value,
  };
}
