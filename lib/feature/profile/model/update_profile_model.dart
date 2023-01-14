class UpdateProfileModel {
  bool? status;
  bool? result;

  UpdateProfileModel({this.status, this.result});

  UpdateProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['result'] = result;
    return data;
  }
}
