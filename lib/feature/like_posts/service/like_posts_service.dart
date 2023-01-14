import 'dart:io';

import 'package:dio/dio.dart';
import 'package:whats_the_story/feature/like_posts/model/like_pots_model.dart';

abstract class ILikePostsService {
  ILikePostsService(this.dio);
  final Dio dio;

  Future<LikePostsModel?> fetchLikePosts(String userId);
}

class LikePostsService extends ILikePostsService {
  LikePostsService(Dio dio) : super(dio);

  @override
  Future<LikePostsModel?> fetchLikePosts(String userId) async {
    FormData postData = FormData.fromMap({'user_id': userId});

    final response = await dio.post("post/user_liked_posts", data: postData);
    if (response.statusCode == HttpStatus.ok) {
      bool responseData = LikePostsModel.fromJson(response.data).status ?? false;
      if (responseData) {
        return LikePostsModel.fromJson(response.data);
      }
    }
    return null;
  }
}
