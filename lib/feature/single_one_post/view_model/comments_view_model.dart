import 'package:flutter/material.dart';

import '../service/comments_service.dart';
import '../model/post_comments_model.dart';

class CommentsViewModel extends ChangeNotifier {
  final ICommentsService commentsService;
  List<Data> comments = [];
  String description = '';

  CommentsViewModel(this.commentsService);

  Future<List<Data>> fetchComments(String postId) async {
    comments = (await commentsService.fetchPostComments(postId))?.data ?? [];
    return comments;
  }

  Future<bool> addComment(postId, userId) async {
    if (description != '') {
      final addComment = await commentsService.addComment(postId.toString(), userId.toString(), description);
      if (addComment != null) {
        return addComment.status ?? false;
      }
    }
    return false;
  }

  fillDescription(String key) {
    description = key;
  }
}
