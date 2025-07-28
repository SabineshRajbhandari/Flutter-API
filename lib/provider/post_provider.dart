import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:statement/models/post_model.dart';
import 'package:statement/services/api_service.dart';

final postProvider =
    StateNotifierProvider<PostNotifier, AsyncValue<List<Post>>>(
      (ref) => PostNotifier(),
    );

class PostNotifier extends StateNotifier<AsyncValue<List<Post>>> {
  PostNotifier() : super(const AsyncValue.loading()) {
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      state = AsyncValue.loading();
      final posts = await ApiService.getPosts();
      state = AsyncValue.data(posts);
    } catch (e, stackTrack) {
      state = AsyncValue.error(e, stackTrack);
    }
  }

  Future<void> createPost(Post post) async {
    try {
      await ApiService.createPost(post);
      await _loadPosts();
    } catch (e, stackTrack) {
      state = AsyncValue.error(e, stackTrack);
    }
  }
}
