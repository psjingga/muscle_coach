import 'dart:async';
import 'dart:io';

import 'app_failure.dart';

/// Mengubah exception apa pun menjadi [AppFailure].
abstract final class FailureMapper {
  static AppFailure from(Object error) => switch (error) {
    AppFailure() => error,
    TimeoutException() => const AppFailure(FailureKind.timeout),
    SocketException() || HttpException() => const AppFailure(FailureKind.network),
    _ => AppFailure(FailureKind.unknown, debugMessage: error.runtimeType.toString()),
  };
}
