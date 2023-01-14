import 'package:flutter/material.dart';
import '../../post_list/viewModel/posts_view_model.dart';
import '../service/user_service.dart';

import '../model/user_model.dart';

class SplashViewModel extends ChangeNotifier {
  final IUserService userService;
  String baseUrl = 'http://whatsyourstory.massviptransfer.com';
  Data? user;
  bool isLoading = false;

  final PostsViewModel post;

  SplashViewModel({
    required this.userService,
    required this.post,
  });

  void _changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  Future<void> getUser(String userId) async {
    _changeLoading();
    if (userId != "0") {
      user = (await userService.getUser(userId))?.data;
      post.isLogin = true;
      post.userId = userId;
    }
    post.sendView();
    _changeLoading();
  }
}
