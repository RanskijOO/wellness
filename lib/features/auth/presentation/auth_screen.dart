import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/design_system/app_tokens.dart';
import '../../../core/widgets/app_components.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSignUp = false;
  bool _busy = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _restoreLastEmail();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _restoreLastEmail() async {
    try {
      final String? lastEmail = await ref
          .read(authRepositoryProvider)
          .readLastEmail();
      if (!mounted || lastEmail == null || lastEmail.isEmpty) {
        return;
      }
      _emailController.text = lastEmail;
    } catch (_) {
      // Ignore local storage issues and allow manual input.
    }
  }

  Future<void> _submit() async {
    final FormState? form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    setState(() => _busy = true);
    try {
      if (_isSignUp) {
        await ref
            .read(appControllerProvider.notifier)
            .signUp(_emailController.text.trim(), _passwordController.text);
      } else {
        await ref
            .read(appControllerProvider.notifier)
            .signIn(_emailController.text.trim(), _passwordController.text);
      }
    } catch (error) {
      _show(_friendlyError(error));
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _resetPassword() async {
    final String? emailError = _validateEmail(_emailController.text);
    if (emailError != null) {
      _show(emailError);
      return;
    }

    try {
      await ref
          .read(appControllerProvider.notifier)
          .resetPassword(_emailController.text.trim());
      _show(
        'Якщо email налаштований, інструкцію для відновлення вже відправлено.',
      );
    } catch (error) {
      _show(_friendlyError(error));
    }
  }

  void _show(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String? _validateEmail(String? value) {
    final String email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'Введіть email.';
    }
    final RegExp emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailPattern.hasMatch(email)) {
      return 'Введіть коректний email.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final String password = value ?? '';
    if (password.isEmpty) {
      return 'Введіть пароль.';
    }
    if (password.length < 6) {
      return 'Пароль має містити щонайменше 6 символів.';
    }
    return null;
  }

  String _friendlyError(Object error) {
    final String message = error.toString();
    if (message.contains('Invalid login credentials')) {
      return 'Не вдалося увійти. Перевірте email і пароль.';
    }
    if (message.contains('email_address_invalid')) {
      return 'Email має некоректний формат.';
    }
    if (message.contains('User already registered')) {
      return 'Користувач із таким email уже існує.';
    }
    if (message.contains('network')) {
      return 'Немає зʼєднання. Спробуйте ще раз трохи пізніше.';
    }
    return 'Не вдалося виконати дію. Спробуйте ще раз.';
  }

  @override
  Widget build(BuildContext context) {
    final bool useLiveBackend = ref.watch(
      appEnvironmentProvider.select(
        (environment) =>
            environment.shouldEnableSupabase || environment.shouldEnableFirebase,
      ),
    );

    return Scaffold(
      body: AloePageBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(AloeSpacing.xl),
            children: <Widget>[
              const SizedBox(height: AloeSpacing.xl),
              GradientHero(
                eyebrow: 'Доступ',
                title: 'Поверніться у свій ритм',
                subtitle:
                    'Увійдіть за email або продовжіть як гість. Усі поради в додатку мають wellness-характер і не замінюють професійну консультацію.',
                trailing: const AloeIconBadge(
                  icon: Icons.lock_outline,
                  size: 82,
                  circular: true,
                ),
              ),
              const SizedBox(height: AloeSpacing.xl),
              Wrap(
                spacing: AloeSpacing.sm,
                runSpacing: AloeSpacing.sm,
                children: const <Widget>[
                  Chip(label: Text('Вхід за email')),
                  Chip(label: Text('Гостьовий режим')),
                  Chip(label: Text('Без медичних порад')),
                ],
              ),
              const SizedBox(height: AloeSpacing.xxl),
              SectionSurface(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Wrap(
                        spacing: AloeSpacing.sm,
                        children: <Widget>[
                          ChoiceChip(
                            label: const Text('Вхід'),
                            selected: !_isSignUp,
                            onSelected: (_) =>
                                setState(() => _isSignUp = false),
                          ),
                          ChoiceChip(
                            label: const Text('Реєстрація'),
                            selected: _isSignUp,
                            onSelected: (_) => setState(() => _isSignUp = true),
                          ),
                        ],
                      ),
                      const SizedBox(height: AloeSpacing.md),
                      Text(
                        _isSignUp
                            ? 'Створіть акаунт, щоб зберігати прогрес між пристроями.'
                            : 'Увійдіть, щоб повернутися до вашого wellness-ритму.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AloeSpacing.xl),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const <String>[AutofillHints.email],
                        textInputAction: TextInputAction.next,
                        validator: _validateEmail,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'you@example.com',
                        ),
                      ),
                      const SizedBox(height: AloeSpacing.lg),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        autofillHints: _isSignUp
                            ? const <String>[AutofillHints.newPassword]
                            : const <String>[AutofillHints.password],
                        textInputAction: TextInputAction.done,
                        validator: _validatePassword,
                        onFieldSubmitted: (_) => _busy ? null : _submit(),
                        decoration: InputDecoration(
                          labelText: 'Пароль',
                          hintText: 'Не менше 6 символів',
                          suffixIcon: IconButton(
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AloeSpacing.xl),
                      AppPrimaryButton(
                        label: _busy
                            ? 'Зачекайте...'
                            : _isSignUp
                            ? 'Створити акаунт'
                            : 'Увійти',
                        onPressed: _busy ? null : _submit,
                        icon: _isSignUp ? Icons.person_add_alt_1 : Icons.login,
                      ),
                      const SizedBox(height: AloeSpacing.md),
                      AppSecondaryButton(
                        label: 'Продовжити як гість',
                        onPressed: _busy
                            ? null
                            : () => ref
                                  .read(appControllerProvider.notifier)
                                  .continueAsGuest(),
                        icon: Icons.spa_outlined,
                      ),
                      const SizedBox(height: AloeSpacing.md),
                      TextButton(
                        onPressed: _busy ? null : _resetPassword,
                        child: const Text('Скинути пароль'),
                      ),
                      const SizedBox(height: AloeSpacing.md),
                      Wrap(
                        spacing: AloeSpacing.sm,
                        runSpacing: AloeSpacing.xs,
                        children: <Widget>[
                          TextButton(
                            onPressed: () => context.push('/legal/disclaimer'),
                            child: const Text('Дисклеймер'),
                          ),
                          TextButton(
                            onPressed: () => context.push('/legal/privacy'),
                            child: const Text('Приватність'),
                          ),
                          TextButton(
                            onPressed: () => context.push('/legal/terms'),
                            child: const Text('Умови'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AloeSpacing.lg),
              SectionSurface(
                child: Text(
                  useLiveBackend
                      ? 'Email-вхід, збереження прогресу та notifications уже підготовлені для live-конфігурації. Перед store release перевірте production credentials і реальні device flows.'
                      : 'У demo-режимі вхід працює локально, доки не підключені реальні ключі Supabase та Firebase.',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
