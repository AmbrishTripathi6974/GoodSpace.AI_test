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

  /// Create a post and store it in Firestore
  Future<void> createPost({
    required File image,
    required String caption,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception("User not logged in");

      final user = await firestoreService.getUser(currentUser.uid);

      final compressedImage = await ImageCompressor.compressImage(image);
      if (compressedImage == null) throw Exception("Image compression failed");

      final imageUrl = await storageService.uploadImage(
        folder: "posts",
        file: compressedImage,
      );

      await firestoreService.createPost(
        postImage: imageUrl,
        caption: caption,
        uid: currentUser.uid,
        username: user.username,
        profileImage: user.profile,
      );
    } catch (e) {
      throw Exception("Failed to create post: $e");
    }
  }

  /// Get all posts as a stream (no likes merged)
  Stream<List<PostModel>> getPostsStream() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => PostModel.fromFirestore(doc)).toList());
  }

  /// Get all posts with their likes populated from subcollection.
  /// NOTE: This performs a small `.get()` per post snapshot. For many posts/large scale,
  /// consider switching to a per-tile stream or keeping a separate `likeCount` field on post doc.
  Stream<List<PostModel>> getPostsStreamWithLikes() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      final List<PostModel> posts = [];
      for (final doc in snapshot.docs) {
        final likesSnap = await _firestore
            .collection('posts')
            .doc(doc.id)
            .collection('likes')
            .get();
        final likeUserIds = likesSnap.docs.map((d) => d.id).toList();
        final post = PostModel.fromFirestore(doc).copyWith(likes: likeUserIds);
        posts.add(post);
      }
      return posts;
    });
  }

  /// Toggle like for the current user (works using auth currentUser)
  Future<void> toggleLike({required String postId}) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception("User not logged in");
    await toggleLikeInSubcollection(postId: postId, userId: currentUser.uid);
  }

  /// Toggle like for a specific user in the `posts/{postId}/likes/{userId}` doc
  Future<void> toggleLikeInSubcollection({
    required String postId,
    required String userId,
  }) async {
    final likeRef = _firestore
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userId);

    final likeDoc = await likeRef.get();

    if (likeDoc.exists) {
      // Unlike
      await likeRef.delete();
    } else {
      // Like
      await likeRef.set({
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /// Stream of like count for a post
  Stream<int> getLikesCount(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  /// One-time like count using aggregation query
  Future<int> getLikeCountOnce(String postId) async {
    final likesSnapshot = await _firestore
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .count()
        .get();

    return likesSnapshot.count ?? 0;
  }

  /// Check if a particular user (or current user if omitted) has liked the post
  Future<bool> isPostLiked(String postId, {String? userId}) async {
    final uid = userId ?? _auth.currentUser?.uid;
    if (uid == null) return false;
    final doc = await _firestore
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(uid)
        .get();
    return doc.exists;
  }

  // Delete Post
  Future<void> deletePost(String postId) async {
    try {
      final uid = _auth.currentUser?.uid;
      print('Deleting post: $postId by user: $uid');
      final doc = await _firestore.collection('posts').doc(postId).get();
      print('Post ownerId: ${doc.data()?['ownerId']}');
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      throw Exception("Failed to delete post: $e");
    }
  }

  String? getCurrentUserId() => _auth.currentUser?.uid;
}
