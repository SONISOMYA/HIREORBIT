import 'package:flutter/material.dart';
import 'package:hireorbit/providers/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/text_styles.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/primary_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: usernameController,
            decoration: _inputDecoration('Username'),
            validator: Validators.validateUsername,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: _inputDecoration('Password'),
            validator: Validators.validatePassword,
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            label: 'Login',
            isLoading: authProvider.isLoading,
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final success = await authProvider.login(
                  usernameController.text.trim(),
                  passwordController.text.trim(),
                );
                if (success) {
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Login failed'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              }
            },
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/signup');
            },
            child: const Text(
              'Don\'t have an account? Sign Up',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: AppTextStyles.subtitle.copyWith(
        fontWeight: FontWeight.w500,
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
      ),
    );
  }
}
