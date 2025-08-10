import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoggedIn extends AuthEvent {
  final String email;
  final String password;

  const AuthLoggedIn({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthLoggedOut extends AuthEvent {}

class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String confirmPassword;
  final String username;
  final String bio;
  final File? profileImage;

  const AuthSignUpRequested({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.username,
    required this.bio,
    this.profileImage,
  });

  @override
  List<Object?> get props =>
      [email, password, confirmPassword, username, bio, profileImage];
}
