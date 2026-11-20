import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../core/errors/app_failure.dart';
import '../domain/ai_client.dart';
import '../domain/ai_config.dart';

/// Gemini API (REST) via dio. API key dikirim di header, tidak di URL, dan
/// tidak pernah di-log.
class GeminiClient implements AiClient {
  GeminiClient([Dio? dio, this.thinkingLevel = AiConfig.thinkingLevel])
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: AiConfig.baseUrl,
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: AiConfig.requestTimeout,
              sendTimeout: const Duration(seconds: 15),
              contentType: 'application/json',
            ),
          );

  final Dio _dio;

  /// Tingkat "thinking" model (null = bawaan model).
  final String? thinkingLevel;

  @override
  Future<AiResponse> generateJson({
    required String apiKey,
    required String model,
    required String systemInstruction,
    required String userContent,
    required Map<String, Object?> responseSchema,
  }) async {
    final Response<Map<String, dynamic>> res;
    try {
      res = await _dio.post<Map<String, dynamic>>(
        '/models/$model:generateContent',
        options: Options(headers: {'x-goog-api-key': apiKey}),
        data: {
          'systemInstruction': {
            'parts': [
              {'text': systemInstruction},
            ],
          },
          'contents': [
            {
              'role': 'user',
              'parts': [
                {'text': userContent},
              ],
            },
          ],
          'generationConfig': {
            'temperature': AiConfig.temperature,
            'maxOutputTokens': AiConfig.maxOutputTokens,
            'responseMimeType': 'application/json',
            'responseSchema': responseSchema,
            if (thinkingLevel case final level?) 'thinkingConfig': {'thinkingLevel': level},
          },
        },
      );
    } on DioException catch (e) {
      throw mapError(e);
    }
    return parseResponse(res.data ?? const {});
  }

  @override
  Future<void> verifyKey(String apiKey) async {
    try {
      await _dio.get<Map<String, dynamic>>(
        '/models',
        queryParameters: {'pageSize': 1},
        options: Options(headers: {'x-goog-api-key': apiKey}),
      );
    } on DioException catch (e) {
      throw mapError(e);
    }
  }

  /// Ambil teks (bukan bagian "thought") dari kandidat pertama.
  static AiResponse parseResponse(Map<String, dynamic> body) {
    final candidates = body['candidates'] as List<dynamic>?;
    final first = (candidates?.isNotEmpty ?? false)
        ? candidates!.first as Map<String, dynamic>
        : null;
    final finish = first?['finishReason'] as String?;
    final parts = (first?['content'] as Map<String, dynamic>?)?['parts'] as List<dynamic>? ?? [];
    final text = parts
        .cast<Map<String, dynamic>>()
        .where((p) => p['thought'] != true && p['text'] is String)
        .map((p) => p['text'] as String)
        .join();
    if (text.isEmpty) {
      throw AppFailure(
        finish == 'SAFETY' || finish == 'PROHIBITED_CONTENT'
            ? FailureKind.invalidInput
            : FailureKind.unavailable,
        debugMessage: 'empty-response:${finish ?? 'none'}',
      );
    }
    final usage = body['usageMetadata'] as Map<String, dynamic>?;
    return AiResponse(
      text: text,
      modelVersion: body['modelVersion'] as String?,
      inputTokens: (usage?['promptTokenCount'] as num?)?.toInt(),
      outputTokens:
          ((usage?['candidatesTokenCount'] as num?) ?? 0).toInt() +
          ((usage?['thoughtsTokenCount'] as num?) ?? 0).toInt(),
      finishReason: finish,
    );
  }

  /// Error API → AppFailure stabil (tanpa membawa key/isi request).
  static AppFailure mapError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const AppFailure(FailureKind.timeout, debugMessage: 'gemini-timeout');
      case DioExceptionType.connectionError:
        return const AppFailure(FailureKind.network, debugMessage: 'gemini-network');
      default:
        break;
    }
    final status = e.response?.statusCode;
    String? reason;
    final data = e.response?.data;
    if (data is Map) {
      final err = data['error'];
      if (err is Map) reason = (err['status'] ?? err['code'])?.toString();
    } else if (data is String && data.isNotEmpty) {
      try {
        final err = (jsonDecode(data) as Map<String, dynamic>)['error'] as Map<String, dynamic>?;
        reason = err?['status']?.toString();
      } catch (_) {}
    }
    final msg = 'gemini-$status${reason == null ? '' : ':$reason'}';
    return switch (status) {
      400 when reason == 'INVALID_ARGUMENT' && _isKeyError(data) => AppFailure(
        FailureKind.unauthenticated,
        debugMessage: msg,
      ),
      401 => AppFailure(FailureKind.unauthenticated, debugMessage: msg),
      403 => AppFailure(FailureKind.permissionDenied, debugMessage: msg),
      404 => AppFailure(FailureKind.notFound, debugMessage: msg),
      429 => AppFailure(FailureKind.quotaExceeded, debugMessage: msg),
      400 => AppFailure(FailureKind.invalidInput, debugMessage: msg),
      _ when status != null && status >= 500 => AppFailure(
        FailureKind.unavailable,
        debugMessage: msg,
      ),
      _ => AppFailure(FailureKind.unknown, debugMessage: msg),
    };
  }

  static bool _isKeyError(Object? data) => data.toString().contains('API_KEY');
}
