class LoginModel {
  bool? status;
  Data? data;

  LoginModel({this.status, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
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
  String? userId;
  String? fullName;
  String? email;
  String? avatarUrl;
  String? token;

  Data({this.userId, this.fullName, this.email, this.avatarUrl, this.token});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    fullName = json['full_name'];
    email = json['email'];
    avatarUrl = json['avatar_url'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['full_name'] = fullName;
    data['email'] = email;
    data['avatar_url'] = avatarUrl;
    data['token'] = token;
    return data;
  }
}
