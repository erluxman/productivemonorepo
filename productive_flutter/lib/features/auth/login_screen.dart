import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../core/utils/haptics.dart';
import '../../features/home/home_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../providers/auth_provider.dart';
import '../../utils/extensions/navigation_extension.dart';
import 'widgets/forget_password_dialog.dart';
import 'widgets/login_form.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _loginIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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

    final authController = ref.read(authControllerProvider.notifier);
    final email = _loginIdController.text.trim();
    final password = _passwordController.text;

    // Clear any previous errors
    authController.clearError();

    final success = await authController.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (success && mounted) {
      // Navigation will be handled automatically by the auth state listener in main.dart
      // But we can also navigate manually if needed
      context.navigateToReplacing(const HomeScreen());
    } else if (mounted) {
      // Show error message
      final error = ref.read(authControllerProvider).error;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showForgotPasswordDialog() async {
    if (!mounted) return;

    final result = await ForgotPasswordDialog.show(
      context,
      onSubmit: (email) async {
        final authController = ref.read(authControllerProvider.notifier);
        return await authController.sendPasswordResetEmail(email);
      },
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset email sent! Check your inbox.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authState = ref.watch(authControllerProvider);

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
                isLoading: authState.isLoading,
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
