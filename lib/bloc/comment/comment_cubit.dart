import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'comment_state.dart';
import 'package:uuid/uuid.dart';

class CommentCubit extends Cubit<CommentState> {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  StreamSubscription? _subscription;

  CommentCubit({required this.firestore, required this.auth})
      : super(CommentInitial());

  void loadComments(String type, String postId) {
    emit(CommentLoading());

    _subscription?.cancel();
    _subscription = firestore
        .collection(type)
        .doc(postId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      emit(CommentLoaded(snapshot.docs));
    }, onError: (e) {
      emit(CommentError(e.toString()));
    });
  }

  Future<void> sendComment({
    required String type,
    required String postId,
    required String comment,
  }) async {
    if (state is! CommentLoaded) return;
    final currentState = state as CommentLoaded;

    emit(CommentSending(currentState.comments));

    try {
      final userDoc =
          await firestore.collection('users').doc(auth.currentUser!.uid).get();
      final commentId = const Uuid().v4();

      await firestore
          .collection(type)
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .set({
        'comment': comment,
        'username': userDoc['username'],
        'profileImage': userDoc['profile'],
        'commentUid': commentId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
