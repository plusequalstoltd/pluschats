import 'package:flutter/material.dart';
import 'package:pluschats/features/auth/presentation/pages/sign_in_page.dart';
import 'package:pluschats/features/auth/presentation/pages/sign_up_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showSignInPage = true;

  void togglePage() {
    setState(() {
      showSignInPage = !showSignInPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignInPage) {
      return SignInPage(togglePage: togglePage);
    } else {
      return SignUpPage(togglePage: togglePage);
    }
  }
}
