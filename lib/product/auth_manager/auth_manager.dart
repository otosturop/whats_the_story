import 'package:flutter/material.dart';
import 'package:whats_the_story/product/cache_manager/cache_manager.dart';

class AuthenticationManager extends CacheManager {
  BuildContext context;
  AuthenticationManager({required this.context});

  bool isLogin = false;

  Future<String?> fetchUserLogin() async {
    final token = await getToken();

    if (token != null) {
      final userId = await getUserId() ?? "0";
      isLogin = true;
      return userId;
    }
    return null;
  }
}
