import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:good_space_test/app.dart';  // Use your app.dart import here

void main() {
  testWidgets('App shows splash screen initially', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify SplashScreen is shown initially
    expect(find.byType(Center), findsWidgets); // Lottie is inside Center in SplashScreen

    // Optionally, check for Lottie widget presence
    expect(find.byType(AnimatedWidget), findsWidgets); // Lottie animation is an AnimatedWidget

    // Wait for 3 seconds (duration of splash)
    await tester.pump(const Duration(seconds: 3));

    // After splash finishes, the app shows either login or home
    // But since auth state depends on Firebase and async, we test loading indicator

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });
}
