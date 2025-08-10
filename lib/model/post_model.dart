import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String postImage;
  final String username;
  final String profileImage;
  final String caption;
  final List<dynamic> likes;
  final String uid;  

  PostModel({
    required this.postId,
    required this.postImage,
    required this.username,
    required this.profileImage,
    required this.caption,
    required this.likes,
    required this.uid,  
  });

  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PostModel(
      postId: doc.id,
      postImage: data['postImage'] ?? '',
      username: data['username'] ?? '',
      profileImage: data['profileImage'] ?? '',
      caption: data['caption'] ?? '',
      likes: data['like'] ?? [],
      uid: data['uid'] ?? '',  
    );
  }
}
