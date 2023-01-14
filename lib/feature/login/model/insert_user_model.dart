class InsertUserModel {
  bool? status;
  String? message;
  int? userId;
  String? token;

  InsertUserModel({this.status, this.message, this.userId, this.token});

  InsertUserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userId = json['user_id'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['user_id'] = userId;
    data['token'] = token;
    return data;
  }
}
