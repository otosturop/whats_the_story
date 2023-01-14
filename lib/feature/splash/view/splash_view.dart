import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_the_story/feature/bottom_navigation_bar/view/bottom_bar_view.dart';
import 'package:whats_the_story/product/auth_manager/auth_manager.dart';
import 'package:kartal/kartal.dart';

import '../../../product/constant/image_enum.dart';
import '../view_model/splash_view_model.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    controlToApp();
  }

  Future<void> controlToApp() async {
    String userId = await readAuthManager.fetchUserLogin() ?? "0";
    if (readAuthManager.isLogin) {
      if (!mounted) return;
      await context.read<SplashViewModel>().getUser(userId);
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomBarView()));
    } else {
      if (!mounted) return;
      await context.read<SplashViewModel>().getUser(userId);
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BottomBarView()));
    }
  }

  AuthenticationManager get readAuthManager => context.read<AuthenticationManager>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: SizedBox(
              height: context.dynamicHeight(0.3),
              child: ImageEnum.logo.toImage,
            ),
          ),
          const Expanded(flex: 3, child: Center(child: CircularProgressIndicator())),
        ],
      ),
    );
  }
}
