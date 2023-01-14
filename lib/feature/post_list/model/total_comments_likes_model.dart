class TotalLikesCommentsModal {
  bool? status;
  List<SubData>? data;

  TotalLikesCommentsModal({this.status, this.data});

  TotalLikesCommentsModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <SubData>[];
      json['data'].forEach((v) {
        data!.add(SubData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubData {
  String? postId;
  String? likes;
  String? comments;

  SubData({this.postId, this.likes, this.comments});

  SubData.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    likes = json['likes'];
    comments = json['comments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['post_id'] = postId;
    data['likes'] = likes;
    data['comments'] = comments;
    return data;
  }
}
