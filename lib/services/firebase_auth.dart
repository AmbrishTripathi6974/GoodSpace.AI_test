import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/user_model.dart';
import 'firestore.dart';
import 'storage.dart';

class AuthenticationService {
  final FirebaseAuth _auth;
  final FirebaseFirestoreService _firestoreService;
  final FirebaseStorageService _storageService;

  AuthenticationService({
    FirebaseAuth? auth,
    FirebaseFirestoreService? firestoreService,
    FirebaseStorageService? storageService,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestoreService = firestoreService ?? FirebaseFirestoreService(),
        _storageService = storageService ?? FirebaseStorageService();

  /// -------------------------
  /// Login
  /// -------------------------
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception("Please enter both email and password.");
    }

    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Get Firestore user
      final user = _auth.currentUser!;
      UserModel? userModel;
      try {
        userModel = await _firestoreService.getUser(user.uid);
      } catch (_) {
        // If not found, create a minimal doc
        await _firestoreService.createUser(
          email: user.email ?? '',
          username: user.displayName ?? 'New User',
          bio: "Hey there! I'm using GoodSpace.",
          profile: user.photoURL ??
              'https://firebasestorage.googleapis.com/v0/b/instagram-8a227.appspot.com/o/person.png?alt=media',
        );
        userModel = await _firestoreService.getUser(user.uid);
      }

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw Exception(_firebaseAuthError(e));
    }
  }

  /// -------------------------
  /// Signup
  /// -------------------------
  Future<UserModel> signup({
    required String email,
    required String password,
    required String confirmPassword,
    required String username,
    required String bio,
    File? profileImage,
  }) async {
    if (email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        username.isEmpty) {
      throw Exception("All fields are required.");
    }
    if (password != confirmPassword) {
      throw Exception("Passwords do not match.");
    }

    try {
      // Create Firebase user
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      String profileUrl = '';
      if (profileImage != null) {
        profileUrl = await _storageService.uploadImage(
          folder: 'Profile',
          file: profileImage,
        );
      }
      if (profileUrl.isEmpty) {
        profileUrl =
            'https://firebasestorage.googleapis.com/v0/b/instagram-8a227.appspot.com/o/person.png?alt=media';
      }

      // Save in Firestore
      await _firestoreService.createUser(
        email: email.trim(),
        username: username.trim(),
        bio: bio.trim(),
        profile: profileUrl,
      );

      // Fetch created user
      final user = _auth.currentUser!;
      final userModel = await _firestoreService.getUser(user.uid);
      return userModel;
    } on FirebaseAuthException catch (e) {
      throw Exception(_firebaseAuthError(e));
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<UserModel?> getCurrentUser() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return null;
    return await _firestoreService.getUser(currentUser.uid);
  }

  String _firebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return "No user found for that email.";
      case 'wrong-password':
        return "Incorrect password.";
      case 'email-already-in-use':
        return "The email address is already registered.";
      case 'weak-password':
        return "The password is too weak.";
      case 'invalid-email':
        return "Invalid email address.";
      default:
        return e.message ?? "Authentication error occurred.";
    }
  }
}
