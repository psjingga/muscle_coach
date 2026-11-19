/// Jenis kegagalan yang stabil, terlepas dari sumbernya.
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
  unknown,
}

/// Kegagalan aplikasi. Lapisan data mengubah exception menjadi ini;
/// presentation hanya berurusan dengan [FailureKind].
class AppFailure implements Exception {
  const AppFailure(this.kind, {this.debugMessage});

  final FailureKind kind;

  /// Detail teknis untuk log; tidak ditampilkan ke pengguna.
  final String? debugMessage;

  @override
  String toString() => 'AppFailure(${kind.name}${debugMessage == null ? '' : ': $debugMessage'})';
}
