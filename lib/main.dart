import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:good_space_test/presentation/screens/home/navigation_screen.dart';

import 'bloc/auth/auth_bloc.dart';
import 'bloc/auth/auth_event.dart';
import 'bloc/auth/auth_state.dart';
import 'bloc/post/post_bloc.dart';
import 'bloc/post/post_event.dart';
import 'config/theme.dart';
import 'firebase_options.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'repository/post_repository.dart';
import 'services/firebase_auth.dart';
import 'services/firestore.dart';
import 'services/storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirebaseFirestoreService();
    final storageService = FirebaseStorageService();

    final postRepository = PostRepository(
      firestoreService: firestoreService,
      storageService: storageService,
    );

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<PostRepository>.value(value: postRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(
              authService: AuthenticationService(),
            )..add(AuthCheckRequested()),
          ),
          BlocProvider<PostBloc>(
            create: (context) => PostBloc(
              postRepository: context.read<PostRepository>(),
            )..add(LoadPostsEvent()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          routes: {
            '/login': (context) => LoginScreen(),
            '/feed': (context) => const NavigationsScreen(),
          },
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is Authenticated) {
                return const NavigationsScreen();
              } else if (state is Unauthenticated) {
                return LoginScreen();
              }
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ),
      ),
    );
  }
}
