import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore.dart';
import '../services/storage.dart';

class PostRepository {
  final FirebaseFirestoreService firestoreService;
  final FirebaseStorageService storageService;
  final FirebaseAuth _auth;

  PostRepository({
    required this.firestoreService,
    required this.storageService,
    FirebaseAuth? auth,
  }) : _auth = auth ?? FirebaseAuth.instance;

  Future<void> createPost({
    required File image,
    required String caption,
  }) async {
    try {
      final user = await firestoreService.getUser(_auth.currentUser!.uid);

      final imageUrl =
          await storageService.uploadImage(folder: "posts", file: image);

      await firestoreService.createPost(
        postImage: imageUrl,
        caption: caption,
        uid: _auth.currentUser!.uid,
        username: user.username,
        profileImage: user.profile,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
