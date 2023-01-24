import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:whats_the_story/feature/profile/model/update_profile_model.dart';
import 'package:whats_the_story/feature/profile/model/upload_image_model.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

import '../model/user_profile_model.dart';

abstract class IUserProfileService {
  final Dio dio;

  IUserProfileService(this.dio);
  Future<UserProfileModel?> getUserProfile(String userId);
  Future<bool> updateUserProfile(String userId, ProfileData? prodata);
  Future<bool> uploadAvatarImage(String userId, File avatarImage);
  Future<void> logOutGoogleAccount();
}

class UserProfileService extends IUserProfileService {
  UserProfileService(super.dio);
  static final _googleSignIn = GoogleSignIn();

  @override
  Future<UserProfileModel?> getUserProfile(String userId) async {
    FormData postData = FormData.fromMap({'user_id': userId});

    final response = await dio.post("users/get_user_profile", data: postData);
    if (response.statusCode == HttpStatus.ok) {
      bool responseData = UserProfileModel.fromJson(response.data).status ?? false;
      if (responseData) {
        return UserProfileModel.fromJson(response.data);
      }
    }
    return null;
  }

  @override
  Future<bool> updateUserProfile(String userId, ProfileData? prodata) async {
    FormData postData = FormData.fromMap({
      'user_id': userId,
      'username': prodata?.username ?? "",
      'email': prodata?.email ?? "",
      'fullname': prodata?.fullname ?? "",
      'instagram': prodata?.instagram ?? "",
    });

    final response = await dio.post("users/update_user", data: postData);
    if (response.statusCode == HttpStatus.ok) {
      bool responseData = UpdateProfileModel.fromJson(response.data).status ?? false;
      if (responseData) {
        return UpdateProfileModel.fromJson(response.data).result ?? false;
      }
    }
    return false;
  }

  @override
  Future<void> logOutGoogleAccount() async {
    _googleSignIn.disconnect();
  }

  @override
  Future<bool> uploadAvatarImage(String userId, File avatarImage) async {
    FormData postData = FormData.fromMap({
      'user_id': userId,
      'avatar_image': await MultipartFile.fromFile(avatarImage.path, contentType: MediaType("image", "jpeg")),
    });

    final response = await dio.post("users/upload_user_avatar", data: postData);
    if (response.statusCode == HttpStatus.ok) {
      bool responseData = UploadImageModel.fromJson(response.data).status ?? false;
      if (responseData) {
        return UpdateProfileModel.fromJson(response.data).result ?? false;
      }
    }
    return false;
  }
}
