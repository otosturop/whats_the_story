import 'dart:io';
import 'package:dio/dio.dart';
import 'package:whats_the_story/feature/post_list/model/posts_with_user_like_status_model.dart';
import '../model/liked_post_model.dart';

import '../model/total_comments_likes_model.dart';

abstract class IPostService {
  IPostService(this.dio);
  final Dio dio;

  Future<PostsWithUserLikeStatusModel?> fetchResourceItems();
  Future<TotalLikesCommentsModal?> fetchResult();
  Future<LikedPostModel?> likedPost(String userId, String postId);
  Future<LikedPostModel?> unLikedPost(String userId, String postId);
  Future<PostsWithUserLikeStatusModel?> fetchPostsWithUserLikeStatus(String userId);
}

class PostService extends IPostService {
  PostService(Dio dio) : super(dio);

  @override
  Future<PostsWithUserLikeStatusModel?> fetchResourceItems() async {
    final response = await dio.get("post/fetch_all_posts_data");

    if (response.statusCode == HttpStatus.ok) {
      final jsonBody = response.data;
      if (jsonBody is Map<String, dynamic>) {
        return PostsWithUserLikeStatusModel.fromJson(jsonBody);
      }
    }
    return null;
  }

  @override
  Future<TotalLikesCommentsModal?> fetchResult() async {
    final response = await dio.get("post/sum_comments_likes");
    if (response.statusCode == HttpStatus.ok) {
      final jsonBody = response.data;
      if (jsonBody is Map<String, dynamic>) {
        return TotalLikesCommentsModal.fromJson(jsonBody);
      }
    }
    return null;
  }

  @override
  Future<LikedPostModel?> likedPost(String userId, String postId) async {
    FormData postData = FormData.fromMap({'user_id': userId, 'post_id': postId});

    final response = await dio.post("post/post_like", data: postData);
    if (response.statusCode == HttpStatus.ok) {
      bool responseData = LikedPostModel.fromJson(response.data).status ?? false;
      if (responseData) {
        return LikedPostModel.fromJson(response.data);
      }
    }
    return null;
  }

  @override
  Future<LikedPostModel?> unLikedPost(String userId, String postId) async {
    FormData postData = FormData.fromMap({'user_id': userId, 'post_id': postId});

    final response = await dio.post("post/post_unlike", data: postData);
    if (response.statusCode == HttpStatus.ok) {
      bool responseData = LikedPostModel.fromJson(response.data).status ?? false;
      if (responseData) {
        return LikedPostModel.fromJson(response.data);
      }
    }
    return null;
  }

  @override
  Future<PostsWithUserLikeStatusModel?> fetchPostsWithUserLikeStatus(String userId) async {
    FormData postData = FormData.fromMap({'user_id': userId});
    final response = await dio.post("post/fetch_all_post_with_like_status", data: postData);
    if (response.statusCode == HttpStatus.ok) {
      final jsonBody = response.data;
      if (jsonBody is Map<String, dynamic>) {
        return PostsWithUserLikeStatusModel.fromJson(jsonBody);
      }
    }
    return null;
  }
}
