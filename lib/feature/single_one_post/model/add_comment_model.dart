class AddCommentModel {
  int? commentId;
  bool? status;
  String? message;

  AddCommentModel({this.commentId, this.status, this.message});

  AddCommentModel.fromJson(Map<String, dynamic> json) {
    commentId = json['comment_id'];
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['comment_id'] = commentId;
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}
