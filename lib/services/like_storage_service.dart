import 'package:shared_preferences/shared_preferences.dart';

class LikePersistenceService {
  static const String _likedPostsKey = 'liked_posts';

  static Future<Set<String>> getLikedPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_likedPostsKey) ?? <String>[];
    return list.toSet();
  }

  static Future<void> saveLikedPosts(Set<String> likedPosts) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_likedPostsKey, likedPosts.toList());
  }

  static Future<void> toggleLike(String postId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_likedPostsKey) ?? <String>[];
    final set = list.toSet();
    if (set.contains(postId)) {
      set.remove(postId);
    } else {
      set.add(postId);
    }
    await prefs.setStringList(_likedPostsKey, set.toList());
  }

  static Future<bool> isPostLiked(String postId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_likedPostsKey) ?? <String>[];
    return list.contains(postId);
  }
}
