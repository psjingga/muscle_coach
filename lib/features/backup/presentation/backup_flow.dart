import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/app_restart.dart';
import '../../../app/theme/app_palette.dart';
import '../../../core/database/database_providers.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/utils/context_x.dart';
import '../../../core/utils/formatters.dart';
import '../data/backup_service.dart';
import '../domain/backup_crypto.dart';
import 'backup_providers.dart';

/// Dialog progres tak-bisa-ditutup; kembalikan fungsi penutupnya.
VoidCallback _progress(BuildContext context, String text) {
  final navigator = Navigator.of(context, rootNavigator: true);
  unawaited(
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Expanded(child: Text(text)),
            ],
          ),
        ),
      ),
    ),
  );
  return navigator.pop;
}

Future<void> _message(BuildContext context, String title, String body) => showDialog<void>(
  context: context,
  builder: (ctx) => AlertDialog(
    title: Text(title),
    content: Text(body),
    actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text(ctx.l10n.close))],
  ),
);

/// Ekspor: kata sandi (2×) → buat berkas terenkripsi → lembar bagikan sistem.
Future<void> exportBackup(BuildContext context, WidgetRef ref) async {
  final l = context.l10n;
  final password = await showBackupPasswordSheet(context, confirm: true);
  if (password == null || !context.mounted) return;
  final close = _progress(context, l.backupCreating);
  final File? file;
  try {
    file = await ref.read(backupServiceProvider).export(password);
  } catch (e) {
    appLogger.w('Cadangan gagal: ${e.runtimeType}');
    close();
    if (context.mounted) await _message(context, l.backupExport, l.backupFailed);
    return;
  }
  close();
  if (!context.mounted) return;
  final box = context.findRenderObject() as RenderBox?;
  final result = await SharePlus.instance.share(
    ShareParams(
      files: [XFile(file.path, mimeType: 'application/octet-stream')],
      subject: l.backupShareSubject,
      sharePositionOrigin: box == null ? null : box.localToGlobal(Offset.zero) & box.size,
    ),
  );
  if (!context.mounted) return;
  context.showSnack(
    result.status == ShareResultStatus.dismissed ? l.backupNotShared : l.backupShared,
  );
}

/// Impor: peringatan → pilih berkas → kata sandi → periksa → konfirmasi →
/// tutup basis data, pasang cadangan, muat ulang aplikasi.
Future<void> restoreBackup(BuildContext context, WidgetRef ref) async {
  final l = context.l10n;
  final go = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      icon: const Icon(Icons.settings_backup_restore_rounded),
      title: Text(l.backupRestoreWarnTitle),
      content: Text(l.backupRestoreWarnBody),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.backupChooseFile)),
      ],
    ),
  );
  if (!(go ?? false) || !context.mounted) return;

  final picked = await FilePicker.pickFile(type: FileType.any);
  if (picked == null || !context.mounted) return;
  final bytes = await picked.xFile.readAsBytes();
  if (!context.mounted) return;
  if (!BackupCrypto.looksLikeBackup(bytes)) {
    await _message(context, l.backupRestore, l.backupNotBackup);
    return;
  }

  final service = ref.read(backupServiceProvider);
  RestorePlan? plan;
  while (plan == null) {
    if (!context.mounted) return;
    final password = await showBackupPasswordSheet(context, confirm: false);
    if (password == null || !context.mounted) return;
    final close = _progress(context, l.backupChecking);
    try {
      plan = await service.prepareRestore(bytes, password);
      close();
    } on BackupPasswordException {
      close();
      if (!context.mounted) return;
      context.showSnack(l.backupWrongPassword);
    } on BackupFormatException catch (e) {
      close();
      if (context.mounted) {
        await _message(
          context,
          l.backupRestore,
          e.reason == 'newer' ? l.backupNewer : l.backupInvalid,
        );
      }
      return;
    } catch (e) {
      close();
      appLogger.w('Periksa cadangan gagal: ${e.runtimeType}');
      if (context.mounted) await _message(context, l.backupRestore, l.backupInvalid);
      return;
    }
  }
  if (!context.mounted) return;

  final m = plan.manifest;
  final sure = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l.backupConfirmTitle),
      content: Text(l.backupConfirmBody(Fmt.date(m.createdAt), m.photoCount)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
        FilledButton(
          key: const Key('backup-restore-confirm'),
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(l.backupRestoreAction),
        ),
      ],
    ),
  );
  if (!(sure ?? false) || !context.mounted) return;

  // Lepas seluruh aplikasi dulu agar tidak ada pendengar data yang aktif,
  // baru tutup basis data, ganti berkasnya, lalu bangun ulang aplikasi.
  final db = ref.read(appDatabaseProvider);
  final ready = plan;
  await AppRestartScope.restartWith(context, () async {
    await db.close().timeout(const Duration(seconds: 10));
    await service.applyRestore(ready);
  });
}

/// Lembar kata sandi cadangan. [confirm] = minta ulangi (saat ekspor).
Future<String?> showBackupPasswordSheet(BuildContext context, {required bool confirm}) =>
    showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _PasswordSheet(confirm: confirm),
    );

class _PasswordSheet extends StatefulWidget {
  const _PasswordSheet({required this.confirm});

  final bool confirm;

  @override
  State<_PasswordSheet> createState() => _PasswordSheetState();
}

class _PasswordSheetState extends State<_PasswordSheet> {
  final _a = TextEditingController();
  final _b = TextEditingController();
  bool _show = false;
  bool _submitted = false;

  @override
  void dispose() {
    _a.dispose();
    _b.dispose();
    super.dispose();
  }

  String? get _errorA =>
      _a.text.length < BackupCrypto.minPasswordLength ? context.l10n.backupPasswordTooShort : null;
  String? get _errorB =>
      widget.confirm && _b.text != _a.text ? context.l10n.backupPasswordMismatch : null;

  void _submit() {
    setState(() => _submitted = true);
    if (_errorA == null && _errorB == null) Navigator.pop(context, _a.text);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final eye = IconButton(
      tooltip: l.backupPasswordLabel,
      icon: Icon(_show ? Icons.visibility_off_outlined : Icons.visibility_outlined),
      onPressed: () => setState(() => _show = !_show),
    );
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.lock_outline_rounded, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(l.backupPasswordTitle, style: theme.textTheme.titleLarge),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.confirm ? l.backupPasswordBodyExport : l.backupPasswordBodyRestore,
                style: TextStyle(fontSize: 13, color: context.palette.muted),
              ),
              const SizedBox(height: 16),
              TextField(
                key: const Key('backup-password'),
                controller: _a,
                autofocus: true,
                obscureText: !_show,
                autocorrect: false,
                enableSuggestions: false,
                decoration: InputDecoration(
                  labelText: l.backupPasswordLabel,
                  errorText: _submitted ? _errorA : null,
                  suffixIcon: eye,
                ),
                onChanged: (_) => setState(() {}),
                onSubmitted: (_) => widget.confirm ? null : _submit(),
              ),
              if (widget.confirm) ...[
                const SizedBox(height: 12),
                TextField(
                  key: const Key('backup-password-confirm'),
                  controller: _b,
                  obscureText: !_show,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                    labelText: l.backupPasswordConfirm,
                    errorText: _submitted ? _errorB : null,
                  ),
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => _submit(),
                ),
              ],
              const SizedBox(height: 16),
              FilledButton(
                key: const Key('backup-password-submit'),
                onPressed: _submit,
                child: Text(l.backupContinue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
