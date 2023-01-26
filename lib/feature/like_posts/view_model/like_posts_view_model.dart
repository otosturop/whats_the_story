import 'package:flutter/material.dart';
import 'package:whats_the_story/product/cache_manager/cache_manager.dart';
import '../../post_list/model/posts_with_user_like_status_model.dart';
import '../../post_list/viewModel/posts_view_model.dart';

class PostsLikeViewModel with ChangeNotifier, CacheManager {
  final PostsViewModel post;
  bool isLoading = false;
  late String userId;
  String baseUrl = 'http://whatsyourstory.massviptransfer.com';
  List<Data> likePosts = [];

  PostsLikeViewModel({required this.post}) {
    getLikePosts();
  }

  void _changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void getLikePosts() {
    likePosts = post.posts.where((post) => post.status == 1).toList();
  }

  Future<void> disLikePost(String postId) async {
    _changeLoading();
    await post.changeLikeStatus(postId, 1);
    _changeLoading();
  }
}
