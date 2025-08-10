import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../core/utils/image_compressor.dart';
import '../model/post_model.dart';
import '../services/firestore.dart';
import '../services/storage.dart';

class PostRepository {
  final FirebaseFirestoreService firestoreService;
  final FirebaseStorageService storageService;
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  PostRepository({
    required this.firestoreService,
    required this.storageService,
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Upload compressed image and create post with current user info
  Future<void> createPost({
    required File image,
    required String caption,
  }) async {
    try {
      final user = await firestoreService.getUser(_auth.currentUser!.uid);

      // Compress the image before uploading
      final compressedImage = await ImageCompressor.compressImage(image);
      if (compressedImage == null) {
        throw Exception("Image compression failed");
      }

      final imageUrl =
          await storageService.uploadImage(folder: "posts", file: compressedImage);

      await firestoreService.createPost(
        postImage: imageUrl,
        caption: caption,
        uid: _auth.currentUser!.uid,
        username: user.username,
        profileImage: user.profile,
      );
    } catch (e) {
      throw Exception("Failed to create post: $e");
    }
  }

  /// Real-time stream of posts ordered by createdAt desc
  Stream<List<PostModel>> getPostsStream() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => PostModel.fromFirestore(doc)).toList());
  }

  /// Toggle like/unlike post for current user
  Future<void> toggleLike({
    required String postId,
    required String uid,
    required List<dynamic> currentLikes,
  }) async {
    final postRef = _firestore.collection('posts').doc(postId);

    if (currentLikes.contains(uid)) {
      await postRef.update({
        'like': FieldValue.arrayRemove([uid]),
      });
    } else {
      await postRef.update({
        'like': FieldValue.arrayUnion([uid]),
      });
    }
  }
}
