class UserModel {
  bool? status;
  Data? data;

  UserModel({this.status, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? fullname;
  String? avatarUrl;
  String? email;
  String? username;
  String? instagram;

  Data({this.id, this.fullname, this.avatarUrl, this.email, this.username, this.instagram});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    avatarUrl = json['avatar_url'];
    email = json['email'];
    username = json['username'];
    instagram = json['instagram'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fullname'] = fullname;
    data['avatar_url'] = avatarUrl;
    data['email'] = email;
    data['username'] = username;
    data['instagram'] = instagram;
    return data;
  }
}
