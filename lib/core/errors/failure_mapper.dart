import 'dart:async';
import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'app_failure.dart';

/// Mengubah exception apa pun menjadi [AppFailure].
abstract final class FailureMapper {
  static AppFailure from(Object error) => switch (error) {
    AppFailure() => error,
    FirebaseAuthException() => fromAuthCode(error.code, error.message),
    FirebaseFunctionsException() => fromServerCode(error.code, error.message),
    FirebaseException() => fromServerCode(error.code, error.message),
    TimeoutException() => const AppFailure(FailureKind.timeout),
    SocketException() => const AppFailure(FailureKind.network),
    _ => AppFailure(FailureKind.unknown, debugMessage: error.runtimeType.toString()),
  };

  /// Kode Firebase Auth (`invalid-credential`, `email-already-in-use`, …).
  static AppFailure fromAuthCode(String code, [String? message]) {
    final kind = switch (code) {
      'invalid-credential' ||
      'wrong-password' ||
      'user-not-found' ||
      'invalid-email' => FailureKind.invalidCredentials,
      'email-already-in-use' => FailureKind.emailAlreadyInUse,
      'weak-password' => FailureKind.weakPassword,
      'too-many-requests' => FailureKind.tooManyRequests,
      'requires-recent-login' || 'user-token-expired' => FailureKind.requiresRecentLogin,
      'user-disabled' => FailureKind.userDisabled,
      'network-request-failed' => FailureKind.network,
      _ => FailureKind.unknown,
    };
    return AppFailure(kind, debugMessage: 'auth/$code');
  }

  /// Kode gRPC/Callable yang dipakai Firestore dan Cloud Functions.
  static AppFailure fromServerCode(String code, [String? message]) {
    final kind = switch (code) {
      'unauthenticated' => FailureKind.unauthenticated,
      'permission-denied' => FailureKind.permissionDenied,
      'not-found' => FailureKind.notFound,
      'invalid-argument' || 'failed-precondition' || 'out-of-range' => FailureKind.invalidInput,
      'resource-exhausted' => FailureKind.quotaExceeded,
      'unavailable' => FailureKind.unavailable,
      'deadline-exceeded' => FailureKind.timeout,
      _ => FailureKind.unknown,
    };
    return AppFailure(kind, debugMessage: code);
  }
}
