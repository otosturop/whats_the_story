import 'dart:io';

import 'package:dio/dio.dart';
import 'package:whats_the_story/feature/splash/model/user_model.dart';

abstract class IUserService {
  final Dio dio;

  IUserService(this.dio);

  Future<UserModel?> getUser(String userId);
}

class UserService extends IUserService {
  UserService(super.dio);

  @override
  Future<UserModel?> getUser(String userId) async {
    FormData postData = FormData.fromMap({
      'user_id': userId,
    });
    final response = await dio.post("users/get_user", data: postData);
    if (response.statusCode == HttpStatus.ok) {
      final jsonBody = response.data;
      if (jsonBody is Map<String, dynamic>) {
        return UserModel.fromJson(jsonBody);
      }
    }
    return null;
  }
}
