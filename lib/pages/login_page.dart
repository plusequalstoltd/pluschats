import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pluschats/main.dart';
import 'package:pluschats/responsive/constrained_scaffold.dart';
import 'package:pluschats/services/auth/auth_service.dart';
import 'package:pluschats/components/custom_button.dart';
import 'package:pluschats/components/custom_textfields.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final void Function()? onTap;

  LoginPage({
    super.key,
    required this.onTap,
  });

  void login(BuildContext context) async {
    final authService = AuthService();

    try {
      logger.d('Signing in with email and password');
      await authService.signInWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Error',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/svg/plus_chats.svg',
                width: 128,
              ),
              const SizedBox(height: 32),
              Text(
                'Welcome back, youve been missed',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextfields(
                hintText: 'Email',
                obscureText: false,
                controller: emailController,
              ),
              const SizedBox(height: 16),
              CustomTextfields(
                hintText: 'Password',
                obscureText: true,
                controller: passwordController,
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Login',
                onTap: () => login(context),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Dont have an account? ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.primary,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      'Register now',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
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
