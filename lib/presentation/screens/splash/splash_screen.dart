import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import 'splash_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // start splash timer on first build
    context.read<SplashCubit>().startSplash();

    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/instagram.json', // your lottie file path here
          width: 200,
          height: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
