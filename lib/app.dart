import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluschats/features/auth/data/firebase_auth_repo.dart';
import 'package:pluschats/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:pluschats/features/auth/presentation/cubits/auth_states.dart';
import 'package:pluschats/features/auth/presentation/pages/auth_page.dart';
// import 'package:pluschats/features/home/presentation/pages/home_page.dart';
// import 'package:pluschats/features/posts/data/firebase_post_repo.dart';
// import 'package:pluschats/features/posts/presentaion/cubits/post_cubit.dart';
import 'package:pluschats/features/profile/data/firebase_profile_repo.dart';
import 'package:pluschats/features/profile/presentation/cubits/profile_cubit.dart';
// import 'package:pluschats/features/search/data/firebase_search_repo.dart';
// import 'package:pluschats/features/search/presentation/cubits/search_cubit.dart';
import 'package:pluschats/features/storage/data/firebase_storage_repo.dart';
import 'package:pluschats/main.dart';
import 'package:pluschats/features/home/presentation/home_page.dart';
import 'package:pluschats/responsive/constrained_scaffold.dart';
import 'package:pluschats/themes/theme_cubit.dart';

/* 
APP - ROOT LEVEL 

Repository: for database
  - firebase

Bloc_Provider: for state management
  - auth
  - profile
  - post
  - search
  - theme

Check Auth State:
  - unauthenticated: AuthPage()
  - authenticated: HomePage()
*/

class App extends StatelessWidget {
  final firebaseAuthRepo = FirebaseAuthRepo();
  final firebaseProfileRepo = FirebaseProfileRepo();
  final firebaseStorageRepo = FirebaseStorageRepo();
  // final firebasePostRepo = FirebasePostRepo();
  // final firebaseSearchRepo = FirebaseSearchRepo();

  App({super.key});

  @override
  Widget build(BuildContext context) {
    // provide cubit to the app
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(
            authRepo: firebaseAuthRepo,
          )..checkAuth(),
        ),
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(
            profileRepo: firebaseProfileRepo,
            storageRepo: firebaseStorageRepo,
          ),
        ),
        // BlocProvider<PostCubit>(
        //   create: (context) => PostCubit(
        //     postRepo: firebasePostRepo,
        //     storageRepo: firebaseStorageRepo,
        //   ),
        // ),
        // BlocProvider<SearchCubit>(
        //   create: (context) => SearchCubit(
        //     searchRepo: firebaseSearchRepo,
        //   ),
        // ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, currentTheme) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: '+Chats',
          theme: currentTheme,
          home: BlocConsumer<AuthCubit, AuthState>(
            builder: (context, authState) {
              logger.i(authState);
              if (authState is Unauthenticated) {
                return const AuthPage();
              } else if (authState is Authenticated) {
                return const HomePage();
              } else {
                return const ConstrainedScaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
            // listen for auth errors
            listener: (context, authState) {
              if (authState is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      authState.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
