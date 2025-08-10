import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;
  final _uuid = const Uuid();

  FirebaseStorageService({FirebaseStorage? storage, FirebaseAuth? auth})
      : _storage = storage ?? FirebaseStorage.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Future<String> uploadImage({
    required String folder,
    required File file,
  }) async {
    try {
      final String fileId = _uuid.v4();
      final ref = _storage
          .ref()
          .child(folder)
          .child(_auth.currentUser!.uid)
          .child(fileId);

      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask.whenComplete(() {});

      return await snapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw Exception("Storage error: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error uploading image: $e");
    }
  }
}
