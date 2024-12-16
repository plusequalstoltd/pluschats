import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pluschats/features/auth/presentation/components/custom_button.dart';
import 'package:pluschats/features/auth/presentation/components/custom_textfields.dart';
import 'package:pluschats/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:pluschats/responsive/constrained_scaffold.dart';

class SignUpPage extends StatefulWidget {
  final void Function()? togglePage;
  const SignUpPage({
    super.key,
    required this.togglePage,
  });

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void signUp() {
    final String firstname = firstnameController.text.trim();
    final String lastname = lastnameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String confirmPassword = confirmPasswordController.text.trim();

    final authCubit = context.read<AuthCubit>();
    if (firstname.isNotEmpty &&
        lastname.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty) {
      if (password == confirmPassword) {
        authCubit.signUp('$firstname $lastname', email, password);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Passwords do not match',
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please complete all fields',
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
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
                'Let\'s create an account for you',
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.onPrimaryFixed,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Spacing
              const SizedBox(height: 24),
              // First Name textfield
              CustomTextfields(
                hintText: 'First Name',
                obscureText: false,
                controller: firstnameController,
              ),
              // Spacing
              const SizedBox(height: 18),
              // Last Name textfield
              CustomTextfields(
                hintText: 'Last Name',
                obscureText: false,
                controller: lastnameController,
              ),
              // Spacing
              const SizedBox(height: 18),
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
              const SizedBox(height: 18),
              // Confirm password textfield
              CustomTextfields(
                hintText: 'Confirm Password',
                obscureText: true,
                controller: confirmPasswordController,
              ),
              // Spacing
              const SizedBox(height: 24),
              // Sign up button
              CustomButton(
                text: 'Sign Up',
                onTap: () {
                  signUp();
                },
              ),
              // Spacing
              const SizedBox(height: 48),
              // Already have an account message
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
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
                      'Sign In',
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
