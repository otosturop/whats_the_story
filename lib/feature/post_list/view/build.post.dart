import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:provider/provider.dart';

import '../../single_one_post/view/single_one_post.dart';
import '../viewModel/posts_view_model.dart';

class BuildPost extends StatelessWidget {
  final String fullname;
  final String userUrl;
  final String imgUrl;
  final String postText;
  final String postTitle;
  final String totalLikes;
  final String totalComments;
  final String postDate;
  final int postId;
  final int likeStatus;
  const BuildPost({
    super.key,
    required this.userUrl,
    required this.imgUrl,
    required this.postText,
    required this.postTitle,
    required this.fullname,
    required this.totalLikes,
    required this.totalComments,
    required this.postDate,
    required this.postId,
    required this.likeStatus,
  });

  @override
  Widget build(BuildContext context) {
    final myPosts = Provider.of<PostsViewModel>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Container(
        width: double.infinity,
        height: context.dynamicHeight(0.89),
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
                  imageTitleBar(),
                  touchImageDecoration(context),
                  actionBar(context, myPosts),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListTile imageTitleBar() {
    return ListTile(
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
        child: CircleAvatar(
          child: ClipOval(
              child: Image.network(
            userUrl,
            fit: BoxFit.cover,
          )),
        ),
      ),
      title: Text(
        fullname,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(postTitle),
      trailing: Text(postDate),
    );
  }

  InkWell touchImageDecoration(BuildContext context) {
    return InkWell(
      onDoubleTap: () {},
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SingleOnePost(
              postId: postId,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(10.0),
        width: double.infinity,
        height: context.dynamicHeight(0.63),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              offset: Offset(0, 5),
              blurRadius: 8.0,
            ),
          ],
          image: DecorationImage(
            image: NetworkImage(imgUrl),
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }

  Padding actionBar(BuildContext context, myPost) {
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
                    () {
                      myPost.changeLikeStatus(postId.toString(), likeStatus);
                    },
                    likeStatus == -1 ? const Icon(Icons.favorite_border) : const Icon(Icons.favorite),
                  ),
                  Text(
                    totalLikes,
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
                    totalComments,
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
            () {
              myAlertDialog(context);
            },
            const Icon(Icons.library_books_outlined),
          ),
        ],
      ),
    );
  }

  Future<Object?> myAlertDialog(BuildContext context) {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                title: Text(postTitle),
                content: Text(postText),
              ),
            ),
          );
        },
        transitionDuration: context.durationLow,
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return const SizedBox();
        });
  }

  IconButton myIconButton(VoidCallback onPressed, Icon myIcon) {
    return IconButton(
      onPressed: onPressed,
      icon: myIcon,
      iconSize: 30,
    );
  }
}
