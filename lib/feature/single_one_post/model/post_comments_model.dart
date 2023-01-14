class PostCommentsModel {
  bool? status;
  List<Data>? data;

  PostCommentsModel({this.status, this.data});

  PostCommentsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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

class Data {
  String? description;
  String? postId;
  String? fullname;
  String? avatarUrl;
  String? date;

  Data({this.description, this.postId, this.fullname, this.date});

  String get fixedDate {
    int dateLength = date?.length ?? 0;
    if (dateLength == 0) {
      return "";
    } else {
      return date!.substring(0, date!.length - 3);
    }
  }

  Data.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    postId = json['post_id'];
    fullname = json['fullname'];
    avatarUrl = json['avatar_url'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['post_id'] = postId;
    data['fullname'] = fullname;
    data['avatar_url'] = avatarUrl;
    data['date'] = date;
    return data;
  }
}
