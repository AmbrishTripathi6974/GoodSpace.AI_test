import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'add_post_event.dart';
import 'add_post_state.dart';

class AddPostBloc extends Bloc<AddPostEvent, AddPostState> {
  AddPostBloc() : super(AddPostInitial()) {
    on<AddPostSubmitted>(_onAddPostSubmitted);
  }

  Future<void> _onAddPostSubmitted(
    AddPostSubmitted event,
    Emitter<AddPostState> emit,
  ) async {
    emit(AddPostLoading());
    try {
      // Step 1: Upload image to Firebase Storage
      String fileName = 'posts/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(event.file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Step 2: Save post details to Firestore
      await FirebaseFirestore.instance.collection('posts').add({
        'imageUrl': downloadUrl,
        'caption': event.caption,
        'timestamp': FieldValue.serverTimestamp(),
        'likes': 0,
        // Add more fields if needed (e.g., userId)
      });

      emit(AddPostSuccess());
    } catch (e) {
      emit(AddPostFailure(e.toString()));
    }
  }
}
