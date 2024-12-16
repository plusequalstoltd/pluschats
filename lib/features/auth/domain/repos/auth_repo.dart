import 'package:pluschats/features/auth/domain/entities/app_user.dart';

abstract class AuthRepo {
  Future<AppUser?> getCurrentUser();
  Future<AppUser?> signInWithEmailAndPassword(String email, String password);
  Future<AppUser?> signUpWithEmailAndPassword(
      String name, String email, String password);
  Future<void> signOut();
}
