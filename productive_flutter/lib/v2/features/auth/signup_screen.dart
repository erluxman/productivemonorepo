import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:productive_flutter/v2/features/auth/widgets/signup_form.dart';
import 'package:productive_flutter/v2/features/home/home_screen.dart';
import 'package:productive_flutter/v2/features/splash/splash_screen.dart';
import 'package:productive_flutter/v2/core/auth/providers/auth_provider.dart';
import 'package:productive_flutter/v2/core/navigation/navigation_extension.dart';

import '../../utils/haptics.dart';

/// Signup screen refactored to use v2 architecture
/// Following cursor rules: Handle Either results properly in UI
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _acceptedTerms = false;
  bool _privacyPolicyError = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isValid = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateValidity);
    _passwordController.addListener(_updateValidity);
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateValidity);
    _emailController.dispose();
    _passwordController.removeListener(_updateValidity);
    _passwordController.dispose();
    super.dispose();
  }

  void _updateValidity() {
    final isEmailValid = _emailController.text.isNotEmpty &&
        _emailController.text.contains('@') &&
        _emailController.text.contains('.');
    final isPasswordValid = _passwordController.text.length >= 6;

    setState(() {
      _isValid = _acceptedTerms && isEmailValid && isPasswordValid;
      _privacyPolicyError =
          !_acceptedTerms && _formKey.currentState?.validate() == true;
    });
  }

  Future<void> _signup() async {
    if (!_acceptedTerms) {
      setState(() {
        _privacyPolicyError = true;
      });
      return;
    }

    if (_formKey.currentState?.validate() != true) return;

    setState(() {
      _isLoading = true;
    });

    final signUpUseCase = ref.read(signUpUseCaseProvider);
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final result = await signUpUseCase.execute(
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
        // Handle success
        if (mounted) {
          context.navigateToReplacing(const HomeScreen());
        }
      },
    );
  }

  Future<void> _navigateTo(BuildContext context, Widget destination) async {
    if (!_acceptedTerms) {
      setState(() {
        _privacyPolicyError = true;
      });
      return;
    }

    if (!context.mounted) return;
    await context.navigateToReplacing(destination);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Create Account',
          style: theme.textTheme.headlineSmall?.copyWith(
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                SignupForm(
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  acceptedTerms: _acceptedTerms,
                  privacyPolicyError: _privacyPolicyError,
                  isValid: _isValid,
                  isLoading: _isLoading,
                  onTermsChanged: (value) {
                    setState(() {
                      _acceptedTerms = value ?? false;
                      _privacyPolicyError = false;
                      _updateValidity();
                    });
                  },
                  onPrivacyPolicyTap: () {
                    // Show privacy policy
                  },
                  onTermsOfServiceTap: () {
                    // Show terms of service
                  },
                  onSignup: _signup,
                  navigateTo: _navigateTo,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

