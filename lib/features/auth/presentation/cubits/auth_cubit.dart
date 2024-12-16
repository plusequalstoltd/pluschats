import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluschats/features/auth/domain/entities/app_user.dart';
import 'package:pluschats/features/auth/domain/repos/auth_repo.dart';
import 'package:pluschats/features/auth/presentation/cubits/auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  AppUser? _currentUser;

  AuthCubit({
    required this.authRepo,
  }) : super(AuthInitial());

  // Check if the user is authenticated
  void checkAuth() async {
    final AppUser? user = await authRepo.getCurrentUser();

    if (user != null) {
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  // Get the current user
  AppUser? get currentUser => _currentUser;

  // Sign in with email and password
  void signIn(String email, String password) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.signInWithEmailAndPassword(email, password);

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (error) {
      emit(AuthError('Sign In error: ${error.toString()}'));
      emit(Unauthenticated());
    }
  }

  // Sign up with email and password
  void signUp(String name, String email, String password) async {
    try {
      emit(AuthLoading());
      final user =
          await authRepo.signUpWithEmailAndPassword(name, email, password);

      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (error) {
      emit(AuthError('Sign In error: ${error.toString()}'));
      emit(Unauthenticated());
    }
  }

  // Log out the user
  void signOut() async {
    await authRepo.signOut();
    _currentUser = null;
    emit(Unauthenticated());
  }
}
