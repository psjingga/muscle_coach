import 'dart:async';
import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musclecoach/core/errors/app_failure.dart';
import 'package:musclecoach/core/errors/failure_mapper.dart';
import 'package:musclecoach/core/network/functions_client.dart';

void main() {
  group('FailureMapper', () {
    test('kode Firebase Auth', () {
      expect(
        FailureMapper.from(FirebaseAuthException(code: 'invalid-credential')).kind,
        FailureKind.invalidCredentials,
      );
      expect(
        FailureMapper.from(FirebaseAuthException(code: 'email-already-in-use')).kind,
        FailureKind.emailAlreadyInUse,
      );
      expect(
        FailureMapper.from(FirebaseAuthException(code: 'requires-recent-login')).kind,
        FailureKind.requiresRecentLogin,
      );
      expect(
        FailureMapper.from(FirebaseAuthException(code: 'network-request-failed')).kind,
        FailureKind.network,
      );
    });

    test('kode Cloud Functions', () {
      FailureKind kindOf(String code) =>
          FailureMapper.from(FirebaseFunctionsException(code: code, message: 'x')).kind;
      expect(kindOf('unauthenticated'), FailureKind.unauthenticated);
      expect(kindOf('invalid-argument'), FailureKind.invalidInput);
      expect(kindOf('resource-exhausted'), FailureKind.quotaExceeded);
      expect(kindOf('unavailable'), FailureKind.unavailable);
      expect(kindOf('internal'), FailureKind.unknown);
    });

    test('exception umum', () {
      expect(FailureMapper.from(TimeoutException('t')).kind, FailureKind.timeout);
      expect(FailureMapper.from(const SocketException('s')).kind, FailureKind.network);
      expect(FailureMapper.from(StateError('x')).kind, FailureKind.unknown);
    });

    test('AppFailure diteruskan apa adanya', () {
      const f = AppFailure(FailureKind.notFound);
      expect(identical(FailureMapper.from(f), f), isTrue);
    });
  });

  test('FunctionsClient.normalizeMap mengubah map bersarang', () {
    final raw = <Object?, Object?>{
      'a': 1,
      'b': <Object?, Object?>{'c': 'x'},
      'd': [
        <Object?, Object?>{'e': true},
      ],
    };
    expect(FunctionsClient.normalizeMap(raw), {
      'a': 1,
      'b': {'c': 'x'},
      'd': [
        {'e': true},
      ],
    });
    expect(FunctionsClient.normalizeMap(null), isEmpty);
    expect(FunctionsClient.normalizeMap('x'), isEmpty);
  });
}
