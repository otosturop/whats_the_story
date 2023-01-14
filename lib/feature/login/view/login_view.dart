import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:provider/provider.dart';
import 'package:whats_the_story/feature/post_list/view/posts_view.dart';

import '../../../product/constant/image_enum.dart';
import '../../../product/padding/page_padding.dart';
import '../viewModel/login_view_model.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});
  final String name = 'Enter Username or Email';
  final String password = 'Enter Password';
  final String login = 'Login';
  final String remember = 'Remember me';
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    final loginViewModel = Provider.of<LoginViewModel>(context);
    final TextEditingController userInput = TextEditingController();
    final TextEditingController userPassword = TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const PagePadding.allToLow(),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              AnimatedContainer(
                duration: context.durationLow,
                height: context.isKeyBoardOpen ? 0 : context.dynamicHeight(0.2),
                width: context.dynamicWidth(0.3),
                child: ImageEnum.door.toImage,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  login,
                  style: context.textTheme.headline3,
                ),
              ),
              TextFormField(
                controller: userInput,
                decoration: InputDecoration(labelText: name, border: const OutlineInputBorder()),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: userPassword,
                decoration: InputDecoration(labelText: password, border: const OutlineInputBorder()),
              ),
              loginViewModel.isLoading
                  ? const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState?.validate() ?? false) {
                          bool result = await loginViewModel.controlLogin(userInput.text, userPassword.text);
                          if (result) {
                            if (!mounted) return;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const PostsView()),
                            );
                          }
                        }
                      },
                      child: Center(child: Text(login)),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
