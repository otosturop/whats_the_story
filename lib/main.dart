import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:whats_the_story/feature/profile/service/profile_service.dart';
import 'package:whats_the_story/feature/profile/viewModel/profile_view_model.dart';

import './feature/init/main_build.dart';
import './feature/login/service/login_service.dart';
import './feature/login/viewModel/login_view_model.dart';
import './feature/post_list/viewModel/posts_view_model.dart';
import './feature/splash/view/splash_view.dart';
import './feature/splash/view_model/splash_view_model.dart';
import './product/auth_manager/auth_manager.dart';
import './product/service/project_service.dart';

import 'feature/bottom_navigation_bar/viewModel/bottom_bar_view_model.dart';
import 'feature/like_posts/view_model/like_posts_view_model.dart';
import 'feature/post_list/service/post_service.dart';
import 'feature/single_one_post/service/comments_service.dart';
import 'feature/single_one_post/view_model/comments_view_model.dart';
import 'feature/splash/service/user_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget with ProjectDioMixin {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => AuthenticationManager(context: context)),
        ChangeNotifierProvider(create: (_) => LoginViewModel(LoginService(service))),
        ChangeNotifierProvider(create: (_) => CommentsViewModel(CommentsService(service))),
        ChangeNotifierProvider(create: (_) => PostsViewModel(PostService(service))),
        ChangeNotifierProvider<BottomBarViewModel>(create: (_) => BottomBarViewModel()),
        ChangeNotifierProvider<ProfileViewModel>(create: (_) => ProfileViewModel(UserProfileService(service))),
        ChangeNotifierProxyProvider<PostsViewModel, PostsLikeViewModel>(
          create: (BuildContext context) => PostsLikeViewModel(post: PostsViewModel(PostService(service))),
          update: (BuildContext context, PostsViewModel postModel, _) => PostsLikeViewModel(post: postModel),
        ),
        ChangeNotifierProxyProvider<PostsViewModel, SplashViewModel>(
          create: (BuildContext context) =>
              SplashViewModel(userService: UserService(service), post: PostsViewModel(PostService(service))),
          update: (BuildContext context, PostsViewModel postModel, _) =>
              SplashViewModel(post: postModel, userService: UserService(service)),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "What's the Story",
        builder: MainBuild.build,
        home: const SplashView(),
        theme: ThemeData.light().copyWith(
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
          scaffoldBackgroundColor: Colors.grey[300],
          floatingActionButtonTheme:
              const FloatingActionButtonThemeData(backgroundColor: Color.fromRGBO(11, 23, 84, 1)),
        ),
      ),
    );
  }
}
