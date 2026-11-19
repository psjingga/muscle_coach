/// Jenis kegagalan yang stabil, terlepas dari SDK sumbernya.
/// Teks untuk pengguna dipetakan di `failure_message.dart`.
enum FailureKind {
  network,
  unauthenticated,
  permissionDenied,
  notFound,
  invalidInput,
  quotaExceeded,
  unavailable,
  timeout,
  invalidCredentials,
  emailAlreadyInUse,
  weakPassword,
  tooManyRequests,
  requiresRecentLogin,
  userDisabled,
  unknown,
}

/// Kegagalan aplikasi. Lapisan data mengubah exception SDK menjadi ini;
/// presentation hanya berurusan dengan [FailureKind].
class AppFailure implements Exception {
  const AppFailure(this.kind, {this.debugMessage});

  final FailureKind kind;

  /// Detail teknis untuk log; tidak ditampilkan ke pengguna.
  final String? debugMessage;

  @override
  String toString() => 'AppFailure(${kind.name}${debugMessage == null ? '' : ': $debugMessage'})';
}
