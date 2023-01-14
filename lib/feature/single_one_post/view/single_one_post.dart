import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kartal/kartal.dart';
import 'package:provider/provider.dart';
import 'package:whats_the_story/feature/post_list/viewModel/posts_view_model.dart';
import 'package:whats_the_story/product/cache_manager/cache_manager.dart';

import '../../../product/constant/image_enum.dart';
import '../../../product/service/project_service.dart';
import '../../../product/padding/page_padding.dart';
import '../../bottom_navigation_bar/viewModel/bottom_bar_view_model.dart';
import '../../login/view/sign_in_view.dart';
import '../../profile/viewModel/profile_view_model.dart';
import '../model/post_comments_model.dart';
import '../view_model/comments_view_model.dart';

class SingleOnePost extends StatefulWidget {
  final int postId;
  const SingleOnePost({super.key, required this.postId});

  @override
  State<SingleOnePost> createState() => _SingleOnePostState();
}

class _SingleOnePostState extends State<SingleOnePost> with ProjectDioMixin, CacheManager {
  final _commentController = TextEditingController();
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
    final myComments = Provider.of<CommentsViewModel>(context).fetchComments(widget.postId.toString());
    final postData = Provider.of<PostsViewModel>(context).getPost(widget.postId.toString());
    final commentsLikes = Provider.of<PostsViewModel>(context).getPostLikesComments(widget.postId.toString());
    final profile = Provider.of<ProfileViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFEDF0F6),
      body: Padding(
        padding: const PagePadding.allToLow(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 40.0),
                width: double.infinity,
                height: context.dynamicHeight(0.95),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        children: <Widget>[
                          imageTitleBar(context, postData, profile),
                          touchImageDecoration(context, postData.imageUrl, profile),
                          actionBar(commentsLikes),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                  width: double.infinity,
                  height: context.dynamicHeight(0.3),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      )),
                  child: FutureBuilder<List<Data>>(
                    future: myComments,
                    builder: (context, snapshot) {
                      int commentLength = snapshot.data?.length ?? 0;
                      if (snapshot.hasData) {
                        return commentLength == 0
                            ? const Center(child: Text("No comments yet"))
                            : ListView.builder(
                                itemCount: commentLength,
                                itemBuilder: (BuildContext context, index) {
                                  return commentBar(context, snapshot.data![index], profile);
                                });
                      } else {
                        return SizedBox(
                          height: context.dynamicHeight(0.3),
                          child: const Center(
                            child: CircularProgressIndicator(
                              value: null,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }
                    },
                  ))
            ],
          ),
        ),
      ),
      bottomNavigationBar: Transform.translate(
        offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: context.dynamicHeight(0.15),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            boxShadow: [
              BoxShadow(color: Colors.black12, offset: Offset(0, -2), blurRadius: 6.0),
            ],
            color: Colors.white,
          ),
          child: mySendTextInput(profile),
        ),
      ),
    );
  }

  Padding mySendTextInput(profile) {
    final myComments = Provider.of<CommentsViewModel>(context);
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
          controller: _commentController,
          onChanged: (value) {
            myComments.fillDescription(value);
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            contentPadding: const EdgeInsets.all(20.0),
            hintText: 'Add a comment',
            prefixIcon: Container(
              margin: const EdgeInsets.all(4),
              height: 48.0,
              width: 48.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    offset: Offset(0, 2),
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: profile.avatarUrl != "-"
                  ? myCircleAvatar(48.0, 48.0, '${profile.baseUrl}/${profile.profileData!.avatarUrl}')
                  : myDefaultAvatar(),
            ),
            suffixIcon: Container(
              margin: const EdgeInsets.only(
                right: 4.0,
              ),
              width: 70.0,
              child: IconButton(
                icon: const Icon(Icons.send),
                color: Colors.green,
                onPressed: () async {
                  bool response = await myComments.addComment(widget.postId, profile.userId);
                  if (response) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    _commentController.clear();
                    showToastMessage("The comment has been successfully added.", Colors.green);
                  } else {
                    FocusManager.instance.primaryFocus?.unfocus();
                    _commentController.clear();
                    showToastMessage("An unexpected error has occurred.", Colors.red);
                  }
                },
              ),
            ),
          )),
    );
  }

  Padding commentBar(BuildContext context, comment, profile) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    offset: Offset(0, 2),
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: comment.avatarUrl != "-"
                  ? myCircleAvatar(50.0, 50.0, myBaseUrl + comment.avatarUrl)
                  : myDefaultAvatar(),
            ),
            title: Text(
              comment.fullname,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(comment.fixedDate),
            trailing: IconButton(
              icon: const Icon(
                Icons.favorite_border,
                color: Colors.grey,
              ),
              onPressed: () {},
            ),
          ),
          Text(comment.description),
          Divider(
            height: context.dynamicHeight(0.1),
          ),
        ],
      ),
    );
  }

  Widget imageTitleBar(BuildContext context, postData, profile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          iconSize: 30,
          color: Colors.black,
        ),
        SizedBox(
          width: context.dynamicWidth(0.8),
          child: ListTile(
            leading: Container(
              width: 50.0,
              height: 50.0,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    offset: Offset(0, 2),
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: profile.avatarUrl != "-"
                  ? myCircleAvatar(50.0, 50.0, '${profile.baseUrl}/${postData.avatarUrl}')
                  : myDefaultAvatar(),
            ),
            title: Text(
              postData.fullname,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(postData.fixedDate),
            trailing: IconButton(
              icon: const Icon(Icons.more_horiz),
              color: Colors.black,
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }

  Widget myCircleAvatar(double myHeight, double myWidth, String imagePath) {
    return CircleAvatar(
      child: ClipOval(
        child: Image.network(
          height: myHeight,
          width: myWidth,
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget myDefaultAvatar() {
    return CircleAvatar(
      child: ClipOval(
        child: ImageEnum.addUser.toAvatar,
      ),
    );
  }

  InkWell touchImageDecoration(BuildContext context, String? postUrl, profile) {
    return InkWell(
      onDoubleTap: () {},
      child: Container(
        margin: const EdgeInsets.all(10.0),
        width: double.infinity,
        height: context.dynamicHeight(0.63),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              offset: Offset(0, 1),
              blurRadius: 20.0,
            ),
          ],
          image: DecorationImage(
            image: NetworkImage('${profile.baseUrl}/$postUrl'),
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }

  Padding actionBar(commentsLikes) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Row(
                children: <Widget>[
                  myIconButton(
                    () {},
                    const Icon(Icons.favorite_border),
                  ),
                  Text(
                    commentsLikes.likes,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20.0),
              Row(
                children: <Widget>[
                  myIconButton(
                    () {},
                    const Icon(Icons.chat),
                  ),
                  Text(
                    commentsLikes.comments,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          myIconButton(
            () {},
            const Icon(Icons.bookmark_border),
          ),
        ],
      ),
    );
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

  IconButton myIconButton(VoidCallback onPressed, Icon myIcon) {
    return IconButton(
      onPressed: onPressed,
      icon: myIcon,
      iconSize: 30,
    );
  }
}
