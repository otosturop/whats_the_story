import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kartal/kartal.dart';
import 'package:whats_the_story/product/constant/image_enum.dart';
import 'package:email_validator/email_validator.dart';

import '../../../product/widget/foundation_button.dart';
import '../../../product/widget/social_login_button.dart';
import '../../bottom_navigation_bar/view/bottom_bar_view.dart';
import '../../profile/viewModel/profile_view_model.dart';
import '../viewModel/login_view_model.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});
  static const routeName = '/sign_in';

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  GlobalKey<FormState> signUpKey = GlobalKey<FormState>();
  final TextEditingController userInput = TextEditingController();
  final TextEditingController userPassword = TextEditingController();
  final TextEditingController userEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  AnimatedContainer(
                    duration: context.durationLow,
                    height: context.isKeyBoardOpen ? 0 : context.dynamicHeight(0.3),
                    color: Colors.white,
                    child: Center(child: ImageEnum.signIn.toImage),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.vertical(bottom: Radius.circular(50))),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                      child: TabBar(
                        labelStyle: Theme.of(context).textTheme.headline5,
                        unselectedLabelStyle: Theme.of(context).textTheme.headline5,
                        labelColor: Colors.black,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: Theme.of(context).colorScheme.primary,
                        indicatorWeight: 3,
                        tabs: const [
                          Tab(text: "Login"),
                          Tab(text: "Register"),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                  flex: 7,
                  child: TabBarView(children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: loginKey,
                        child: Column(
                          children: [
                            loginViewModel.isLogin
                                ? Center(
                                    child: Text(
                                      "Incorrect username or password!",
                                      style: TextStyle(fontSize: 16.0, color: Theme.of(context).colorScheme.error),
                                    ),
                                  )
                                : const Spacer(),
                            buildNameField(context, "User Name"),
                            buildPasswordField(context, loginViewModel),
                            const Spacer(),
                            const Align(alignment: Alignment.centerRight, child: Text("forgot my password")),
                            const Spacer(),
                            context.isKeyBoardOpen
                                ? const Spacer()
                                : SocialLoginButton(
                                    buttonText: "Sign in with Google Account",
                                    onPressed: () {},
                                    buttonColor: Colors.white,
                                    textColor: Colors.black87,
                                    buttonIcon: ImageEnum.google.toImage,
                                  ),
                            const Spacer(),
                            loginViewModel.isLoading
                                ? const Center(child: CircularProgressIndicator())
                                : FoundationButton(
                                    "Login",
                                    () async {
                                      if (loginKey.currentState?.validate() ?? false) {
                                        loginKey.currentState?.save();
                                        bool result =
                                            await loginViewModel.controlLogin(userInput.text, userPassword.text);
                                        if (result) {
                                          if (!mounted) return;
                                          Provider.of<ProfileViewModel>(context, listen: false)
                                              .getUserInfo()
                                              .then((value) => Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => const BottomBarView()),
                                                  ));
                                        }
                                      }
                                    },
                                  ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                    // 2. tab area
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                          key: signUpKey,
                          child: Column(
                            children: [
                              const Spacer(),
                              buildNameField(context, "Full Name"),
                              buildEmailField(context),
                              buildPasswordField(context, loginViewModel),
                              const Spacer(),
                              loginViewModel.isLoading
                                  ? const Center(child: CircleAvatar())
                                  : FoundationButton("Register", () async {
                                      if (signUpKey.currentState?.validate() ?? false) {
                                        signUpKey.currentState?.save();
                                        bool result = await loginViewModel.userRegister(
                                            userInput.text, userEmail.text, userPassword.text);
                                        if (result) {
                                          if (!mounted) return;
                                          Provider.of<ProfileViewModel>(context, listen: false)
                                              .getUserInfo()
                                              .then((value) => Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => const BottomBarView()),
                                                  ));
                                        }
                                      }
                                    }),
                            ],
                          )),
                    )
                  ]))
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildNameField(BuildContext context, String myLabelText) {
    return TextFormField(
      keyboardType: TextInputType.text,
      validator: (value) {
        if ((value?.length ?? 0) < 3) return "Username field must be at least 3 characters.";
        return null;
      },
      decoration: InputDecoration(
          labelText: myLabelText,
          icon: Icon(
            Icons.person,
            color: Theme.of(context).colorScheme.primary,
          )),
      onSaved: (data) => userInput.text = data!,
    );
  }

  bool isEmail(String input) => EmailValidator.validate(input);

  TextFormField buildEmailField(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (!isEmail(value ?? "") || value!.contains("ı")) {
          return "Please enter a valid email address.";
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: "E-mail",
          icon: Icon(
            Icons.email,
            color: Theme.of(context).colorScheme.primary,
          )),
      onSaved: (data) => userEmail.text = data!,
    );
  }

  TextFormField buildPasswordField(BuildContext context, loginModel) {
    return TextFormField(
      obscureText: loginModel.textPasswordType,
      validator: (value) {
        if ((value?.length ?? 0) < 6) return "Password must be at least 6 digits!";
        return null;
      },
      decoration: InputDecoration(
          labelText: "Password",
          icon: Icon(
            Icons.lock,
            color: Theme.of(context).colorScheme.primary,
          ),
          suffix: IconButton(
            icon: Icon(loginModel.textPasswordType ? Icons.remove_red_eye_outlined : Icons.visibility_off),
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
              loginModel.changeTypePassword();
            },
          )),
      onSaved: (data) => userPassword.text = data!,
    );
  }
}
