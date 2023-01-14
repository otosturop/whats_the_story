import 'package:flutter/material.dart';
import 'package:whats_the_story/feature/like_posts/model/like_pots_model.dart';
import 'package:whats_the_story/feature/like_posts/service/like_posts_service.dart';
import 'package:whats_the_story/product/cache_manager/cache_manager.dart';

import '../../post_list/service/post_service.dart';

class PostsLikeViewModel with ChangeNotifier, CacheManager {
  final ILikePostsService likePostService;
  final IPostService postService;
  bool isLoading = false;
  late String userId;
  String baseUrl = 'http://whatsyourstory.massviptransfer.com';
  List<Data> posts = [];

  PostsLikeViewModel(this.likePostService, this.postService) {
    _fetchPosts();
  }

  void _changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  Future<void> _fetchPosts() async {
    _changeLoading();
    userId = await getUserId() ?? "0";
    posts = (await likePostService.fetchLikePosts(userId))?.data ?? [];
    _changeLoading();
  }

  Future<void> disLikePost(String postId) async {
    _changeLoading();
    await postService.unLikedPost(userId, postId);
    posts.removeWhere((element) => element.id == postId);
    notifyListeners();
    _changeLoading();
  }
}
