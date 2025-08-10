import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uid;
  final String email;
  final String username;
  final String bio;
  final String profile;
  final List<String> following;
  final List<String> followers;

  const UserModel({
    required this.uid,
    required this.email,
    required this.username,
    required this.bio,
    required this.profile,
    required this.following,
    required this.followers,
  });

  static const empty = UserModel(
    uid: '',
    email: '',
    username: '',
    bio: '',
    profile: '',
    following: [],
    followers: [],
  );

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      bio: map['bio'] ?? '',
      profile: map['profile'] ?? '',
      following: List<String>.from(map['following'] ?? []),
      followers: List<String>.from(map['followers'] ?? []),
    );
  }

  factory UserModel.fromFirestore(
      Map<String, dynamic>? data, String documentId) {
    final map = data ?? {};
    return UserModel(
      uid: documentId,
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      bio: map['bio'] ?? '',
      profile: map['profile'] ?? '',
      following: List<String>.from(map['following'] ?? []),
      followers: List<String>.from(map['followers'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'bio': bio,
      'profile': profile,
      'following': following,
      'followers': followers,
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? username,
    String? bio,
    String? profile,
    List<String>? following,
    List<String>? followers,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      profile: profile ?? this.profile,
      following: following ?? this.following,
      followers: followers ?? this.followers,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        email,
        username,
        bio,
        profile,
        following,
        followers,
      ];
}
