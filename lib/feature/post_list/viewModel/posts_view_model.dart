import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../service/post_service.dart';
import '../model/total_comments_likes_model.dart';
import '../model/posts_with_user_like_status_model.dart';

class PostsViewModel extends ChangeNotifier {
  final IPostService postService;
  bool isLoading = false;
  List<Data> posts = [];
  List<Data> filterPosts = [];
  List<SubData> totalLikesComments = [];
  String baseUrl = 'http://whatsyourstory.massviptransfer.com/';
  bool isLogin = false;
  String userId = "";

  PostsViewModel(this.postService);

  void _changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  Future<void> _fetchPosts() async {
    posts = (await postService.fetchResourceItems())?.data ?? [];
    notifyListeners();
  }

  Future<void> _getTotalLikesComments() async {
    totalLikesComments = (await postService.fetchResult())?.data ?? [];
    notifyListeners();
  }

  Future<void> sendView() async {
    _changeLoading();
    if (isLogin) {
      await _fetchPostsWithUserLikeStatus(userId);
    } else {
      await _fetchPosts();
    }

    await _getTotalLikesComments();
    _changeLoading();
  }

  Data getPost(String id) {
    return posts.firstWhere((post) => post.id == id);
  }

  SubData getPostLikesComments(String id) {
    return totalLikesComments.firstWhere((item) => item.postId == id);
  }

  searchPosts(String key) {
    if (posts.isNotEmpty) {
      final items = posts
          .where((element) => '${element.subject?.toLowerCase()} ${element.post?.toLowerCase()}'.contains(key))
          .toList();
      if (items.isNotEmpty) {
        filterPosts = items;
        notifyListeners();
      }
    }
  }

  Future<void> _fetchPostsWithUserLikeStatus(String userId) async {
    posts = (await postService.fetchPostsWithUserLikeStatus(userId))?.data ?? [];
    notifyListeners();
  }

  Future<void> changeLikeStatus(String postId, int status) async {
    if (isLogin) {
      for (var element in posts) {
        if (element.id == postId) {
          if (status == 1) {
            await postService.unLikedPost(userId, postId);
            element.status = -1;
            increaseDecreaseLike(postId, -1);
          } else {
            await postService.likedPost(userId, postId);
            element.status = 1;
            increaseDecreaseLike(postId, 1);
          }
        }
      }
      notifyListeners();
    } else {
      Fluttertoast.showToast(
          msg: 'Please login first.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void increaseDecreaseLike(String postId, int operation) {
    for (var item in totalLikesComments) {
      if (item.postId == postId) {
        if (operation == 1) {
          item.likes = (int.parse(item.likes ?? "0") + 1).toString();
        } else {
          item.likes = (int.parse(item.likes ?? "0") - 1).toString();
        }
      }
    }
  }
}
