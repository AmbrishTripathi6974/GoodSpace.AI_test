import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../model/user_model.dart';

class FirebaseFirestoreService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseFirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// -------------------------
  /// Create User
  /// -------------------------
  Future<void> createUser({
    required String email,
    required String username,
    required String bio,
    required String profile,
  }) async {
    try {
      final uid = _auth.currentUser!.uid;
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'email': email,
        'username': username,
        'bio': bio,
        'profile': profile,
        'followers': [],
        'following': [],
      });
    } on FirebaseException catch (e) {
      throw Exception("Firestore error: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error creating user: $e");
    }
  }

  /// -------------------------
  /// Create Post
  /// -------------------------
  Future<void> createPost({
    required String postImage,
    required String caption,
    required String uid,
    required String username,
    required String profileImage,
    String location = '',
  }) async {
    try {
      await _firestore.collection('posts').add({
        'postImage': postImage,
        'username': username,
        'profileImage': profileImage,
        'caption': caption,
        'location': location,
        'uid': uid,
        'createdAt': Timestamp.now(),
        'serverCreatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Unexpected error creating post: $e");
    }
  }

  /// -------------------------
  /// Get User
  /// -------------------------
  Future<UserModel> getUser(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) throw Exception("User not found");
      return UserModel.fromFirestore(doc.data(), doc.id);
    } on FirebaseException catch (e) {
      throw Exception("Firestore error: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error fetching user: $e");
    }
  }

  /// -------------------------
  /// Add Comment
  /// -------------------------
  Future<void> addComment({
    required String comment,
    required String type,
    required String postId,
  }) async {
    try {
      final user = await getUser(_auth.currentUser!.uid);
      final commentId = const Uuid().v4();
      await _firestore
          .collection(type)
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .set({
        'comment': comment,
        'username': user.username,
        'profileImage': user.profile,
        'commentUid': commentId,
      });
    } catch (e) {
      throw Exception("Error adding comment: $e");
    }
  }

  /// -------------------------
  /// Like / Unlike Post or Reel
  /// -------------------------
  Future<String> like({
    required List<dynamic> likeList,
    required String type,
    required String uid,
    required String postId,
  }) async {
    String res = 'some error';
    try {
      if (likeList.contains(uid)) {
        await _firestore.collection(type).doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection(type).doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } on FirebaseException catch (e) {
      res = "Firestore error: ${e.message}";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  /// -------------------------
  /// Follow / Unfollow User
  /// -------------------------
  Future<void> followUser({required String targetUid}) async {
    try {
      final snap = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
      final following = (snap.data()! as dynamic)['following'] as List;

      if (following.contains(targetUid)) {
        // Unfollow
        await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .update({
          'following': FieldValue.arrayRemove([targetUid])
        });
        await _firestore.collection('users').doc(targetUid).update({
          'followers': FieldValue.arrayRemove([_auth.currentUser!.uid])
        });
      } else {
        // Follow
        await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .update({
          'following': FieldValue.arrayUnion([targetUid])
        });
        await _firestore.collection('users').doc(targetUid).update({
          'followers': FieldValue.arrayUnion([_auth.currentUser!.uid])
        });
      }
    } catch (e) {
      throw Exception("Error following/unfollowing user: $e");
    }
  }
}
