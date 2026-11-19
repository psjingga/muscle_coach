import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/routes.dart';
import '../../../../app/theme/brand.dart';
import '../../../../core/errors/failure_message.dart';
import '../../../../core/utils/context_x.dart';
import '../../../../core/widgets/busy_button.dart';
import '../../domain/validators/auth_validators.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_widgets.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    // Navigasi ke Home ditangani redirect router saat status login berubah.
    await ref.read(authControllerProvider.notifier).signIn(_email.text, _password.text);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final state = ref.watch(authControllerProvider);
    return AuthScaffold(
      title: l.loginTitle(Brand.appName),
      subtitle: l.loginSubtitle,
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
                  validator: (v) => authFieldErrorText(l, AuthValidators.loginPassword(v)),
                  onSubmitted: (_) => _submit(),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => context.push(Routes.forgotPassword),
            child: Text(l.forgotPasswordLink),
          ),
        ),
        const SizedBox(height: 8),
        FormErrorText(state.hasError ? failureMessage(l, state.error!) : null),
        BusyButton(label: l.loginButton, busy: state.isLoading, onPressed: _submit),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: state.isLoading ? null : () => context.push(Routes.register),
          child: Text(l.createAccountButton),
        ),
      ],
    );
  }
}
