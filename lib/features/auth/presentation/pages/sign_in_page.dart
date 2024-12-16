import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pluschats/features/auth/presentation/components/custom_button.dart';
import 'package:pluschats/features/auth/presentation/components/custom_textfields.dart';
import 'package:pluschats/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:pluschats/responsive/constrained_scaffold.dart';

class SignInPage extends StatefulWidget {
  final void Function()? togglePage;
  const SignInPage({
    super.key,
    required this.togglePage,
  });

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void signIn() {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    final authCubit = context.read<AuthCubit>();
    if (email.isNotEmpty && password.isNotEmpty) {
      authCubit.signIn(email, password);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter both email and password',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.secondary,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Logo
              Icon(
                Icons.lock_open_rounded,
                size: 100,
                color: Theme.of(context).colorScheme.primary,
              ),
              // Spacing
              const SizedBox(height: 20),
              // Welcome message
              Text(
                'Welcome to +Socials',
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.onPrimaryFixed,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Spacing
              const SizedBox(height: 24),
              // Email textfield
              CustomTextfields(
                hintText: 'Email',
                obscureText: false,
                controller: emailController,
              ),
              // Spacing
              const SizedBox(height: 18),
              // Password textfield
              CustomTextfields(
                hintText: 'Password',
                obscureText: true,
                controller: passwordController,
              ),
              // Spacing
              const SizedBox(height: 24),
              // Sign in button
              CustomButton(
                text: 'Sign In',
                onTap: signIn,
              ),
              // Spacing
              const SizedBox(height: 48),
              // No account message
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Dont have an account? ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onPrimaryFixed,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.togglePage,
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onPrimaryFixed,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
