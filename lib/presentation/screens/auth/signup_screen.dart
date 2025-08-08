import 'package:flutter/material.dart';
import 'package:good_space_test/core/utils/helper_function.dart';
import 'package:good_space_test/presentation/screens/auth/login_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = THelperFunctions.screenSize(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 96),
              child: Image.asset(
                'assets/text_logo.png',
                width: 250,
                height: 100,
              ),
            ),
            SizedBox(
              height: 35,
            ),

            // Username

            Container(
              width: size.width * 0.95,
              height: size.height * 0.055,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  hintText: "Username",
                  border: InputBorder.none,
                ),
              ),
            ),

            SizedBox(height: 20),

            // Email Field
            Container(
              width: size.width * 0.95,
              height: size.height * 0.055,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  hintText: "Email",
                  border: InputBorder.none,
                ),
              ),
            ),

            SizedBox(height: 20),

            // Password Field
            Container(
              width: size.width * 0.95,
              height: size.height * 0.055,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                obscureText: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  hintText: "Password",
                  border: InputBorder.none,
                ),
              ),
            ),

            SizedBox(height: 20),

            // Confirm Password Field
            Container(
              width: size.width * 0.95,
              height: size.height * 0.055,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                obscureText: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  hintText: "Confirm Password",
                  border: InputBorder.none,
                ),
              ),
            ),

            SizedBox(height: 40),

            // Login Button
            Container(
              width: size.width * 0.95,
              height: size.height * 0.06,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  // Button
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const LoginScreen(), 
                        ),
                      );
                    },
                    child: Text(
                      "Login",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
