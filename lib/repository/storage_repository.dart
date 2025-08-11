import 'package:cloud_firestore/cloud_firestore.dart';

class ExploreRepository {
  final FirebaseFirestore firestore;
  ExploreRepository({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getExplorePosts() async {
    final snapshot = await firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .limit(100) // batch limit
        .get();

    return snapshot.docs;
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> searchUsers(String query) async {
    if (query.isEmpty) return [];
    final snapshot = await firestore
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: query)
        .limit(50)
        .get();
    return snapshot.docs;
  }
}
