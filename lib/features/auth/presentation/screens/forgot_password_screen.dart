import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failure_message.dart';
import '../../../../core/utils/context_x.dart';
import '../../../../core/widgets/busy_button.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_widgets.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final ok = await ref.read(authControllerProvider.notifier).sendPasswordReset(_email.text);
    if (ok && mounted) setState(() => _sent = true);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final state = ref.watch(authControllerProvider);
    return AuthScaffold(
      title: l.forgotPasswordTitle,
      // Pesan sama untuk email terdaftar/tidak, agar tidak membocorkan akun.
      subtitle: _sent ? l.forgotPasswordSent : l.forgotPasswordSubtitle,
      showBack: true,
      children: [
        Form(
          key: _form,
          child: EmailField(controller: _email, textInputAction: TextInputAction.done),
        ),
        const SizedBox(height: 20),
        FormErrorText(state.hasError ? failureMessage(l, state.error!) : null),
        BusyButton(
          label: _sent ? l.forgotPasswordResend : l.forgotPasswordButton,
          busy: state.isLoading,
          onPressed: _submit,
        ),
      ],
    );
  }
}
