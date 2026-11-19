import '../../l10n/gen/app_localizations.dart';
import 'app_failure.dart';
import 'failure_mapper.dart';

/// Teks ramah pengguna untuk sebuah error (tanpa detail teknis).
String failureMessage(AppLocalizations l, Object error) {
  final failure = FailureMapper.from(error);
  return switch (failure.kind) {
    FailureKind.network => l.errorNetwork,
    FailureKind.unauthenticated => l.errorUnauthenticated,
    FailureKind.permissionDenied => l.errorPermissionDenied,
    FailureKind.notFound => l.errorNotFound,
    FailureKind.invalidInput => l.errorInvalidInput,
    FailureKind.quotaExceeded => l.errorQuotaExceeded,
    FailureKind.unavailable => l.errorUnavailable,
    FailureKind.timeout => l.errorTimeout,
    FailureKind.unknown => l.errorUnknown,
  };
}
