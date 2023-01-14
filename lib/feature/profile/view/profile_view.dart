import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:kartal/kartal.dart';
import 'package:whats_the_story/feature/profile/viewModel/profile_view_model.dart';
import 'package:whats_the_story/product/cache_manager/cache_manager.dart';

import '../../../product/constant/image_enum.dart';
import '../../../product/widget/foundation_button.dart';
import '../../bottom_navigation_bar/viewModel/bottom_bar_view_model.dart';
import '../../login/view/sign_in_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with CacheManager {
  GlobalKey<FormState> profileKey = GlobalKey<FormState>();
  final TextEditingController fullname = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController instagram = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  checkUser() async {
    final userId = await getUserId() ?? "0";
    if (userId == "0") {
      if (!mounted) return;
      Provider.of<BottomBarViewModel>(context, listen: false).selectedIndex = 0;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignInView()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileViewModel>(context);
    return SafeArea(
        child: Material(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: profile.avatarUrl != "-"
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: networkAvatarImage('${profile.baseUrl}${profile.profileData!.avatarUrl}'),
                  )
                : Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      onTap: () {
                        clickedAvatarPhoto(context, profile);
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: profile.selectedPhoto != null ? FileImage(profile.selectedPhoto!) : null,
                          child: profile.selectedPhoto == null ? ClipOval(child: ImageEnum.addUser.toAvatar) : null,
                        ),
                      ),
                    ),
                  ),
            leadingWidth: context.dynamicHeight(0.15),
            toolbarHeight: context.dynamicHeight(0.13),
            title: profile.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Ink(
                      decoration: const ShapeDecoration(
                        color: Colors.green,
                        shape: CircleBorder(),
                      ),
                      child: IconButton(
                        onPressed: profile.isSelectedPhoto
                            ? () async {
                                bool result = await profile.updateAvatarImage();
                                if (result) {
                                  showToastMessage("The upload was successful.", Colors.green);
                                } else {
                                  showToastMessage("An unexpected error has occurred.", Colors.red);
                                }
                              }
                            : () {
                                showToastMessage("Please select an image first.", Colors.red);
                              },
                        icon: const Icon(Icons.upload_file),
                        color: Colors.white,
                      ),
                    ),
                  ),
            actions: [
              profile.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Ink(
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        //This keeps the splash effect within the circle
                        borderRadius: BorderRadius.circular(900.0), //Something large to ensure a circle
                        onTap: () {
                          profile.logOut();
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (context) => const SignInView()));
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.logout_outlined,
                            size: 25.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
            ],
            floating: true,
            expandedHeight: context.dynamicHeight(0.3),
            flexibleSpace: (FlexibleSpaceBar(
              title: myBrand(),
              centerTitle: true,
              background: ImageEnum.profile.toImage,
            )),
          ),
          Form(
            child: SliverList(
                delegate: SliverChildListDelegate([
              buildInputField(
                  context, "Full Name", Icons.person, TextInputType.text, profile.profileData?.fullname ?? "", (value) {
                profile.profileData?.fullname = value;
              }),
              buildInputField(
                  context, "User Name", Icons.person, TextInputType.text, profile.profileData?.username ?? "", (value) {
                profile.profileData?.username = value;
              }),
              buildInputField(
                  context, "E-mail", Icons.email, TextInputType.emailAddress, profile.profileData?.email ?? "",
                  (value) {
                profile.profileData?.email = value;
              }),
              buildInputField(context, "Instagram Name", Icons.insert_comment_rounded, TextInputType.emailAddress,
                  profile.profileData?.instagram ?? "", (value) {
                profile.profileData?.instagram = value;
              }),
              profile.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : FoundationButton("Update", () => _validation(profile)),
            ])),
          )
        ],
      ),
    ));
  }

  Text myBrand() {
    return const Text(
      "What's the story",
      style: TextStyle(
        fontFamily: 'Billabong',
        fontSize: 32.0,
        color: Colors.black87,
      ),
    );
  }

  Widget buildInputField(BuildContext context, String inputText, icon, type, String inputValue, textChange) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        keyboardType: type,
        controller: TextEditingController.fromValue(
            TextEditingValue(text: inputValue, selection: TextSelection.collapsed(offset: inputValue.length))),
        decoration: InputDecoration(
            labelText: inputText,
            border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
            prefixIcon: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
            )),
        onChanged: textChange,
      ),
    );
  }

  Widget networkAvatarImage(String userUrl) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        radius: 40,
        child: ClipOval(
            child: Image.network(
          userUrl,
          fit: BoxFit.cover,
        )),
      ),
    );
  }

  _validation(profile) async {
    if (profile.profileData?.fullname == "" ||
        profile.profileData?.email == "" ||
        profile.profileData?.username == "") {
      showToastMessage("Please enter your profile information completely.", Colors.red);
    } else {
      bool result = await profile.updateUserProfile();
      if (result) {
        showToastMessage("The profile has been successfully updated.", Colors.green);
      }
    }
  }

  showToastMessage(String message, Color toastColor) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: toastColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void clickedAvatarPhoto(BuildContext context, profile) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text("Gallery"),
              onTap: () {
                uploadPhoto(ImageSource.gallery, profile);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () {
                uploadPhoto(ImageSource.camera, profile);
              },
            ),
          ],
        ),
      ),
    );
  }

  void uploadPhoto(ImageSource source, profile) async {
    final picker = ImagePicker();
    final selectedPhoto = await picker.pickImage(source: source);

    if (selectedPhoto != null) {
      profile.setSelectedPhoto = selectedPhoto.path;
    }

    if (!mounted) return;
    Navigator.pop(context);
  }
}
