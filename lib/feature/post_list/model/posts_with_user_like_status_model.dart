class PostsWithUserLikeStatusModel {
  bool? status;
  List<Data>? data;

  PostsWithUserLikeStatusModel({this.status, this.data});

  PostsWithUserLikeStatusModel.fromJson(Map<String, dynamic> json) {
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
  String? id;
  String? title;
  String? imageUrl;
  String? fullname;
  String? avatarUrl;
  String? isGoogle;
  String? post;
  String? subject;
  String? date;
  int? status;

  Data(
      {this.id,
      this.title,
      this.imageUrl,
      this.fullname,
      this.avatarUrl,
      this.isGoogle,
      this.post,
      this.subject,
      this.date,
      this.status});

  String get fixedDate {
    final fixedDate = date?.split(' ') ?? [];
    final onlyDate = fixedDate[0].split('-');
    final fixedHour = fixedDate[1].split(':');

    final onlyHour = '${fixedHour[0]}:${fixedHour[1]}';
    return '${onlyDate[2]}/${onlyDate[1]}/${onlyDate[0]} \n $onlyHour';
  }

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    imageUrl = json['image_url'];
    fullname = json['fullname'];
    avatarUrl = json['avatar_url'];
    isGoogle = json['is_google'];
    post = json['post'];
    subject = json['subject'];
    date = json['date'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image_url'] = imageUrl;
    data['fullname'] = fullname;
    data['avatar_url'] = avatarUrl;
    data['is_google'] = isGoogle;
    data['post'] = post;
    data['subject'] = subject;
    data['date'] = date;
    data['status'] = status;
    return data;
  }
}
