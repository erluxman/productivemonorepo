import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../utils/haptics.dart';
import '../home/home_screen.dart';
import '../splash/splash_screen.dart';
import '../../core/auth/providers/auth_provider.dart';
import '../../core/navigation/navigation_extension.dart';
import 'widgets/forget_password_dialog.dart';
import 'widgets/login_form.dart';

/// Login screen refactored to use v2 architecture
/// Following cursor rules: Handle Either results properly in UI
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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
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

    final signInUseCase = ref.read(signInUseCaseProvider);
    final email = _loginIdController.text.trim();
    final password = _passwordController.text;

    final result = await signInUseCase.execute(
      email: email,
      password: password,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    // Handle Either result following cursor rules
    result.fold(
      (error) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: Colors.red,
          ),
        );
      },
      (userCredential) {
        // Handle success - navigation will be handled by auth state listener
        if (mounted) {
          context.navigateToReplacing(const HomeScreen());
        }
      },
    );
  }

  Future<void> _showForgotPasswordDialog() async {
    if (!mounted) return;

    final sendPasswordResetUseCase = ref.read(sendPasswordResetUseCaseProvider);
    
    final result = await ForgotPasswordDialog.show(
      context,
      onSubmit: (email) async {
        final resetResult = await sendPasswordResetUseCase.execute(email);
        return resetResult.fold(
          (error) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(error.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
            return false;
          },
          (_) => true,
        );
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

