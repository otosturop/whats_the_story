class UserProfileModel {
  bool? status;
  ProfileData? data;

  UserProfileModel({this.status, this.data});

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? ProfileData.fromJson(json['data']) : null;
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

class ProfileData {
  String? fullname;
  String? email;
  String? username;
  String? instagram;
  String? avatarUrl;
  String? isGoogle;

  ProfileData({this.fullname, this.email, this.username, this.instagram, this.avatarUrl, this.isGoogle});

  ProfileData.fromJson(Map<String, dynamic> json) {
    fullname = json['fullname'];
    email = json['email'];
    username = json['username'];
    instagram = json['instagram'];
    avatarUrl = json['avatar_url'];
    isGoogle = json['is_google'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullname'] = fullname;
    data['email'] = email;
    data['username'] = username;
    data['instagram'] = instagram;
    data['avatar_url'] = avatarUrl;
    data['is_google'] = isGoogle;
    return data;
  }
}
