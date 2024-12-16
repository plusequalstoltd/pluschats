import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pluschats/responsive/constrained_scaffold.dart';
import 'package:pluschats/services/auth/login_or_register.dart';
import 'package:pluschats/pages/home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return HomePage();
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('An error occurred'),
            );
          } else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
