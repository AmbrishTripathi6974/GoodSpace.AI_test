import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String postImage;
  final String username;
  final String profileImage;
  final String caption;
  final List<String> likes; // list of userIds (populated from likes subcollection)
  final String uid;

  const PostModel({
    required this.postId,
    required this.postImage,
    required this.username,
    required this.profileImage,
    required this.caption,
    this.likes = const [],
    required this.uid,
  });

  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    // Accept both legacy `likes`/`like` array in doc OR default to empty.
    final rawLikes = data['likes'] ?? data['like'] ?? [];
    List<String> likesList;
    try {
      likesList = List<String>.from(rawLikes);
    } catch (_) {
      likesList = [];
    }

    return PostModel(
      postId: doc.id,
      postImage: data['postImage'] ?? '',
      username: data['username'] ?? '',
      profileImage: data['profileImage'] ?? '',
      caption: data['caption'] ?? '',
      likes: likesList,
      uid: data['uid'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postImage': postImage,
      'username': username,
      'profileImage': profileImage,
      'caption': caption,
      // If you still persist likes as array in root doc (legacy) you can include this.
      'likes': likes,
      'uid': uid,
    };
  }

  PostModel copyWith({
    String? postId,
    String? postImage,
    String? username,
    String? profileImage,
    String? caption,
    List<String>? likes,
    String? uid,
  }) {
    return PostModel(
      postId: postId ?? this.postId,
      postImage: postImage ?? this.postImage,
      username: username ?? this.username,
      profileImage: profileImage ?? this.profileImage,
      caption: caption ?? this.caption,
      likes: likes ?? this.likes,
      uid: uid ?? this.uid,
    );
  }
}
