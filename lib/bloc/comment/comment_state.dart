import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object?> get props => [];
}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentLoaded extends CommentState {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> comments;

  const CommentLoaded(this.comments);

  @override
  List<Object?> get props => [comments];
}

class CommentError extends CommentState {
  final String message;
  const CommentError(this.message);

  @override
  List<Object?> get props => [message];
}

class CommentSending extends CommentState {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> comments;
  const CommentSending(this.comments);

  @override
  List<Object?> get props => [comments];
}
