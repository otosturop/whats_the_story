import 'dart:io';
import 'package:dio/dio.dart';
import 'package:whats_the_story/feature/single_one_post/model/add_comment_model.dart';

import '../model/post_comments_model.dart';

abstract class ICommentsService {
  final Dio dio;
  ICommentsService(this.dio);

  Future<PostCommentsModel?> fetchPostComments(String postId);
  Future<AddCommentModel?> addComment(String postId, String userId, String description);
}

class CommentsService extends ICommentsService {
  CommentsService(Dio dio) : super(dio);

  @override
  Future<PostCommentsModel?> fetchPostComments(String postId) async {
    FormData postData = FormData.fromMap({
      'post_id': postId,
    });

    final response = await dio.post("comments/get_post_comments", data: postData);

    if (response.statusCode == HttpStatus.ok) {
      final jsonBody = response.data;
      if (jsonBody is Map<String, dynamic>) {
        return PostCommentsModel.fromJson(jsonBody);
      }
    }
    return null;
  }

  @override
  Future<AddCommentModel?> addComment(String postId, String userId, String description) async {
    FormData postData = FormData.fromMap({'post_id': postId, 'user_id': userId, 'description': description});
    final response = await dio.post("comments/insert_comment", data: postData);
    if (response.statusCode == HttpStatus.ok) {
      final jsonBody = response.data;
      if (jsonBody is Map<String, dynamic>) {
        return AddCommentModel.fromJson(jsonBody);
      }
    }
    return null;
  }
}
