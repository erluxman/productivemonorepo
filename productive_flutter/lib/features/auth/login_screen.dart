import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../core/utils/haptics.dart';
import '../../features/home/home_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../utils/extensions/navigation_extension.dart';
import 'widgets/forget_password_dialog.dart';
import 'widgets/login_form.dart';
import 'widgets/two_factor_auth_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _loginIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isFormValid = false;
  @override
  void initState() {
    super.initState();

    // Add listeners to validate form
    _loginIdController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    final isLoginIdValid = _loginIdController.text.length >= 4;
    final isPasswordValid = _passwordController.text.length >= 6;

    setState(() {
      _isFormValid = isLoginIdValid && isPasswordValid;
    });
  }

  @override
  void dispose() {
    _loginIdController.removeListener(_validateForm);
    _passwordController.removeListener(_validateForm);
    _loginIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() != true) return;
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;
    await _show2FADialog();
  }

  Future<void> _show2FADialog() async {
    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;
    final result = await TwoFactorAuthDialog.show(context);
    if (result == true && mounted) {
      if (!mounted) return;

      await context.navigateToReplacing(const HomeScreen());
    }
  }

  Future<void> _showForgotPasswordDialog() async {
    if (!mounted) return;
    final result = await ForgotPasswordDialog.show(context);
    if (result == true && mounted) {
      if (!mounted) return;

      await context.navigateToReplacing(const HomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Login',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Haptics.light();
            context.navigateToReplacing(const SplashScreen());
          },
          color: colorScheme.onSurface,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Hero(
                tag: 'paper_plane_animation',
                child: Lottie.asset(
                  'assets/lottie/paper_plane.json',
                  height: 250,
                  animate: true,
                  repeat: true,
                ),
              ),
              LoginForm(
                formKey: _formKey,
                loginIdController: _loginIdController,
                passwordController: _passwordController,
                isLoading: _isLoading,
                isFormValid: _isFormValid,
                showForgotPasswordDialog: _showForgotPasswordDialog,
                login: _login,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
