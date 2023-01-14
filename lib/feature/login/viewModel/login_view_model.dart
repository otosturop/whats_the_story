import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

import '../service/login_service.dart';
import '../../../product/cache_manager/cache_manager.dart';

class LoginViewModel with ChangeNotifier, CacheManager {
  bool isLoading = false;
  final ILoginService loginService;
  bool isLogin = false;
  bool textPasswordType = true;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  LoginViewModel(this.loginService);

  void _changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  void _changeLoginStatus(bool status) {
    isLogin = status;
    notifyListeners();
  }

  void changeTypePassword() {
    textPasswordType = !textPasswordType;
    notifyListeners();
  }

  Future<bool> controlLogin(String userInput, String password) async {
    _changeLoading();
    final response = await loginService.doLogin(userInput, password);
    if (response != null) {
      await saveUser(response.data!.token!, response.data!.userId!);
      _changeLoginStatus(false);
      _changeLoading();
      return true;
    } else {
      _changeLoginStatus(true);
      _changeLoading();
      return false;
    }
  }

  Future<bool> userRegister(String userInput, String email, String password) async {
    _changeLoading();
    String device = "";
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      device = '${androidInfo.brand} - ${androidInfo.model}';
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      device = iosInfo.utsname.machine.toString();
    }

    final response = await loginService.insertUser(userInput, email, password, device);
    if (response != null) {
      await saveUser(response.token ?? '-', response.userId.toString());
      _changeLoginStatus(true);
      _changeLoading();
      return true;
    } else {
      _changeLoginStatus(false);
      _changeLoading();
      return false;
    }
  }
}
