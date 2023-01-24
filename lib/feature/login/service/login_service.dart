import 'dart:io';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../model/insert_user_model.dart';
import '../model/login_model.dart';

abstract class ILoginService {
  final Dio dio;

  ILoginService(this.dio);

  Future<LoginModel?> doLogin(String userInput, String password);
  Future<InsertUserModel?> insertUser(
      String fullname, String email, String password, String deviceInfo, String? avatarUrl);
  Future<GoogleSignInAccount?> registerWithGoogle();
}

class LoginService extends ILoginService {
  LoginService(super.dio);
  static final _googleSignIn = GoogleSignIn();

  @override
  Future<LoginModel?> doLogin(String userInput, String password) async {
    FormData postData = FormData.fromMap({
      'username': userInput,
      'password': password,
    });

    final response = await dio.post("users/do_login", data: postData);
    if (response.statusCode == HttpStatus.ok) {
      bool responseData = LoginModel.fromJson(response.data).status ?? false;
      if (responseData) {
        return LoginModel.fromJson(response.data);
      }
    }
    return null;
  }

  @override
  Future<InsertUserModel?> insertUser(
      String fullname, String email, String password, String deviceInfo, String? avatarUrl) async {
    FormData postData = FormData.fromMap({
      'full_name': fullname,
      'email': email,
      'phone_brand': deviceInfo,
      'password': password,
      'avatar_url': avatarUrl ?? "-",
    });
    final response = await dio.post("users/insert_user", data: postData);
    if (response.statusCode == HttpStatus.ok) {
      bool responseStatus = InsertUserModel.fromJson(response.data).status ?? false;
      if (responseStatus) {
        return InsertUserModel.fromJson(response.data);
      }
    }
    return null;
  }

  @override
  Future<GoogleSignInAccount?> registerWithGoogle() {
    return _googleSignIn.signIn();
  }
}
