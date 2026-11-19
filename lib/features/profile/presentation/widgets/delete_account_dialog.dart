import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failure_message.dart';
import '../../../../core/utils/context_x.dart';
import '../../../auth/domain/validators/auth_validators.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/presentation/widgets/auth_widgets.dart';

/// Konfirmasi hapus akun: jelaskan dampaknya, minta kata sandi
/// (login ulang), lalu hapus seluruh data di server.
class DeleteAccountDialog extends ConsumerStatefulWidget {
  const DeleteAccountDialog({super.key});

  static Future<void> show(BuildContext context) => showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const DeleteAccountDialog(),
  );

  @override
  ConsumerState<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends ConsumerState<DeleteAccountDialog> {
  final _form = GlobalKey<FormState>();
  final _password = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    if (!_form.currentState!.validate()) return;
    final ok = await ref.read(authControllerProvider.notifier).deleteAccount(_password.text);
    if (!ok || !mounted) return;
    // Router bisa sudah mengganti tumpukan halaman (data profil terhapus →
    // redirect). Lepaskan hanya route dialog ini, jangan pop halaman lain.
    final route = ModalRoute.of(context);
    if (route != null && route.isActive) Navigator.of(context).removeRoute(route);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final state = ref.watch(authControllerProvider);
    final error = Theme.of(context).colorScheme.error;
    return AlertDialog(
      icon: Icon(Icons.warning_amber_rounded, color: error),
      title: Text(l.deleteAccountTitle),
      content: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.deleteAccountMessage),
              const SizedBox(height: 16),
              PasswordField(
                controller: _password,
                label: l.deleteAccountPasswordLabel,
                validator: (v) => authFieldErrorText(l, AuthValidators.loginPassword(v)),
                onSubmitted: (_) => _delete(),
              ),
              if (state.hasError && !state.isLoading) ...[
                const SizedBox(height: 12),
                Text(failureMessage(l, state.error!), style: TextStyle(color: error)),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: state.isLoading ? null : () => Navigator.pop(context),
          child: Text(l.cancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: error, minimumSize: const Size(0, 48)),
          onPressed: state.isLoading ? null : _delete,
          child: state.isLoading
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l.deleteAccountConfirm),
        ),
      ],
    );
  }
}
