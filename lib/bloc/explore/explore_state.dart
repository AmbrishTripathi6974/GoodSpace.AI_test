import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class ExploreState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExploreInitial extends ExploreState {}

class ExploreLoading extends ExploreState {}

class ExplorePostsLoaded extends ExploreState {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> posts;
  ExplorePostsLoaded(this.posts);

  @override
  List<Object?> get props => [posts];
}

class ExploreUsersLoaded extends ExploreState {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> users;
  ExploreUsersLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class ExploreError extends ExploreState {
  final String message;
  ExploreError(this.message);

  @override
  List<Object?> get props => [message];
}
