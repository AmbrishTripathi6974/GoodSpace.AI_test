import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:good_space_test/presentation/screens/home/navigation_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:good_space_test/core/utils/helper_function.dart';
import 'package:good_space_test/bloc/auth/auth_bloc.dart';
import 'package:good_space_test/bloc/auth/auth_event.dart';
import 'package:good_space_test/bloc/auth/auth_state.dart';
import 'package:good_space_test/presentation/screens/auth/login_screen.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final ValueNotifier<File?> imageFile = ValueNotifier(null);

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }

  // IMPORTANT: Navigate to NavigationsScreen instead of FeedScreen
  void _navigateToNavigationsScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const NavigationsScreen()),
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = THelperFunctions.screenSize(context);

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              _navigateToNavigationsScreen(context); // updated here
            } else if (state is Unauthenticated) {
              _showError(context, "Signup failed");
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // Logo
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 96),
                    child: Image.asset(
                      'assets/text_logo.png',
                      width: 250,
                      height: 100,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Profile Image Picker
                  GestureDetector(
                    onTap: _pickImage,
                    child: ValueListenableBuilder<File?>(
                      valueListenable: imageFile,
                      builder: (context, file, _) {
                        return CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage:
                              file != null ? FileImage(file) : null,
                          child: file == null
                              ? const Icon(Icons.camera_alt,
                                  size: 40, color: Colors.black54)
                              : null,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Username
                  _buildTextField(
                    controller: usernameController,
                    hintText: "Username",
                    size: size,
                  ),
                  const SizedBox(height: 20),

                  // Email
                  _buildTextField(
                    controller: emailController,
                    hintText: "Email",
                    size: size,
                  ),
                  const SizedBox(height: 20),

                  // Password
                  _buildTextField(
                    controller: passwordController,
                    hintText: "Password",
                    obscure: true,
                    size: size,
                  ),
                  const SizedBox(height: 20),

                  // Confirm Password
                  _buildTextField(
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    obscure: true,
                    size: size,
                  ),
                  const SizedBox(height: 40),

                  // Create Account Button
                  GestureDetector(
                    onTap: () {
                      final username = usernameController.text.trim();
                      final email = emailController.text.trim();
                      final password = passwordController.text.trim();
                      final confirmPassword =
                          confirmPasswordController.text.trim();

                      if (password != confirmPassword) {
                        _showError(context, "Passwords do not match");
                        return;
                      }
                      if (username.isEmpty ||
                          email.isEmpty ||
                          password.isEmpty) {
                        _showError(context, "Please fill all fields");
                        return;
                      }

                      context.read<AuthBloc>().add(
                            AuthSignUpRequested(
                              email: email,
                              password: password,
                              confirmPassword: confirmPassword,
                              username: username,
                              bio: "Hey there! I'm using GoodSpace.",
                              profileImage: imageFile.value,
                            ),
                          );
                    },
                    child: Container(
                      width: size.width * 0.95,
                      height: size.height * 0.06,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: state is AuthLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Create Account",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),

                  // Already have an account
                  Row(
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
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LoginScreen(),
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscure = false,
    required Size size,
  }) {
    return SizedBox(
      width: size.width * 0.95,
      height: size.height * 0.07,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: hintText, // floating label
          labelStyle: const TextStyle(color: Colors.black),
          filled: true,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        ),
      ),
    );
  }
}
