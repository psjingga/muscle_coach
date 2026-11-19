import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failure_message.dart';
import '../../../../core/utils/context_x.dart';
import '../../../auth/domain/entities/auth_user.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../widgets/delete_account_dialog.dart';

/// Tab Profil. Fase 1: akun (verifikasi email, keluar, hapus akun).
/// Assessment, goal, peralatan, notifikasi & privasi menyusul.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final user = ref.watch(authStateProvider).value;
    final action = ref.watch(authControllerProvider);
    final controller = ref.read(authControllerProvider.notifier);

    Future<void> confirmSignOut() async {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l.signOutConfirmTitle),
          content: Text(l.signOutConfirmMessage),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.signOut)),
          ],
        ),
      );
      if ((ok ?? false) && context.mounted) await _runWithSnack(context, ref, controller.signOut);
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.tabProfile)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (user != null) _AccountCard(user: user, busy: action.isLoading),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: action.isLoading ? null : confirmSignOut,
            icon: const Icon(Icons.logout),
            label: Text(l.signOut),
          ),
          const SizedBox(height: 32),
          Text(l.dangerZone, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
              alignment: Alignment.centerLeft,
            ),
            onPressed: action.isLoading ? null : () => DeleteAccountDialog.show(context),
            icon: const Icon(Icons.delete_forever_outlined),
            label: Text(l.deleteAccount),
          ),
        ],
      ),
    );
  }
}

class _AccountCard extends ConsumerWidget {
  const _AccountCard({required this.user, required this.busy});

  final AuthUser user;
  final bool busy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final controller = ref.read(authControllerProvider.notifier);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.accountSection, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.mail_outline),
                const SizedBox(width: 12),
                Expanded(child: Text(user.email, style: theme.textTheme.bodyLarge)),
              ],
            ),
            const SizedBox(height: 12),
            if (user.emailVerified)
              Chip(
                avatar: Icon(Icons.verified, color: theme.colorScheme.primary),
                label: Text(l.emailVerified),
              )
            else ...[
              Text(l.emailNotVerified, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton(
                    onPressed: busy
                        ? null
                        : () => _runWithSnack(
                            context,
                            ref,
                            controller.sendEmailVerification,
                            success: l.verificationSent,
                          ),
                    child: Text(l.resendVerification),
                  ),
                  TextButton(
                    onPressed: busy
                        ? null
                        : () => _runWithSnack(context, ref, controller.reloadUser),
                    child: Text(l.checkVerification),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Jalankan aksi controller; tampilkan error (atau pesan sukses) di snackbar.
Future<void> _runWithSnack(
  BuildContext context,
  WidgetRef ref,
  Future<bool> Function() action, {
  String? success,
}) async {
  final ok = await action();
  if (!context.mounted) return;
  if (ok) {
    if (success != null) context.showSnack(success);
  } else if (ref.read(authControllerProvider).error case final e?) {
    context.showSnack(failureMessage(context.l10n, e));
  }
}
