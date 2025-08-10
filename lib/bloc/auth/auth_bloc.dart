import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/firebase_auth.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationService _authService;

  AuthBloc({required AuthenticationService authService})
      : _authService = authService,
        super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoggedIn>(_onAuthLoggedIn);
    on<AuthLoggedOut>(_onAuthLoggedOut);
    on<AuthSignUpRequested>(_onAuthSignUpRequested);
  }

  Future<void> _onAuthCheckRequested(
      AuthCheckRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      final username = prefs.getString('username');

      if (userId != null && username != null) {
        emit(Authenticated(userId: userId, username: username));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError("Failed to check authentication: $e"));
    }
  }

  Future<void> _onAuthLoggedIn(
      AuthLoggedIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userModel = await _authService.login(
        email: event.email,
        password: event.password,
      );

      await _saveUserToPrefs(userModel.uid, userModel.username);
      emit(Authenticated(userId: userModel.uid, username: userModel.username));
    } catch (e) {
      emit(AuthError(_formatError(e)));
    }
  }

  Future<void> _onAuthSignUpRequested(
      AuthSignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userModel = await _authService.signup(
        email: event.email,
        password: event.password,
        confirmPassword: event.confirmPassword,
        username: event.username,
        bio: event.bio,
        profileImage: event.profileImage,
      );

      await _saveUserToPrefs(userModel.uid, userModel.username);
      emit(Authenticated(userId: userModel.uid, username: userModel.username));
    } catch (e) {
      emit(AuthError(_formatError(e)));
    }
  }

  Future<void> _onAuthLoggedOut(
      AuthLoggedOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authService.logout();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError("Failed to log out: $e"));
    }
  }

  Future<void> _saveUserToPrefs(String userId, String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    await prefs.setString('username', username);
  }

  String _formatError(Object e) {
    final msg = e.toString();
    return msg.startsWith('Exception: ') ? msg.replaceFirst('Exception: ', '') : msg;
  }
}
