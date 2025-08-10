import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:good_space_test/bloc/auth/auth_event.dart';
import 'package:good_space_test/bloc/auth/auth_state.dart';
import 'package:good_space_test/presentation/screens/feed/feed_screen.dart';

import 'bloc/auth/auth_bloc.dart';
import 'firebase_options.dart';
import 'config/theme.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'services/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(authService: AuthenticationService())
        ..add(AuthCheckRequested()), 
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        routes: {
          '/login': (context) => LoginScreen(),
          '/feed': (context) => const FeedScreen(),
        },
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return const FeedScreen();
            } else if (state is Unauthenticated) {
              return LoginScreen();
            }
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }
}
