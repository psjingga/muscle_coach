import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failure_message.dart';
import '../../../../core/utils/context_x.dart';
import '../../../../core/widgets/busy_button.dart';
import '../../domain/validators/auth_validators.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_widgets.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final ok = await ref
        .read(authControllerProvider.notifier)
        .register(_email.text, _password.text);
    // Setelah berhasil, redirect router membawa pengguna ke Home.
    if (ok && mounted) context.showSnack(context.l10n.registerSuccess);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final state = ref.watch(authControllerProvider);
    return AuthScaffold(
      title: l.registerTitle,
      subtitle: l.registerSubtitle,
      showBack: true,
      children: [
        Form(
          key: _form,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                EmailField(controller: _email),
                const SizedBox(height: 14),
                PasswordField(
                  controller: _password,
                  label: l.passwordLabel,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.newPassword],
                  validator: (v) => authFieldErrorText(l, AuthValidators.newPassword(v)),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 14),
                  child: Text(
                    l.passwordRule(AuthValidators.minPasswordLength),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                PasswordField(
                  controller: _confirm,
                  label: l.confirmPasswordLabel,
                  autofillHints: const [AutofillHints.newPassword],
                  validator: (v) =>
                      authFieldErrorText(l, AuthValidators.confirmPassword(v, _password.text)),
                  onSubmitted: (_) => _submit(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        FormErrorText(state.hasError ? failureMessage(l, state.error!) : null),
        BusyButton(label: l.registerButton, busy: state.isLoading, onPressed: _submit),
      ],
    );
  }
}
