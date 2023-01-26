import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kartal/kartal.dart';

import '../../post_list/viewModel/posts_view_model.dart';
import './build.post.dart';
import '../view_model/like_posts_view_model.dart';

class MyLikePostsView extends StatelessWidget {
  const MyLikePostsView({super.key});

  @override
  Widget build(BuildContext context) {
    final likePosts = Provider.of<PostsLikeViewModel>(context);
    final myPosts = Provider.of<PostsViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: myBrand(),
        actions: [
          myIconButton(
            () {},
            const Icon(Icons.live_tv),
          ),
          const SizedBox(width: 16.0),
          myIconButton(
            () {},
            const Icon(Icons.send),
          ),
        ],
      ),
      body: likePosts.isLoading
          ? SizedBox(
              height: context.dynamicHeight(0.9),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
            )
          : likePosts.likePosts.isEmpty
              ? const Center(child: Text("There is no liked posts"))
              : myPostsList(likePosts, myPosts),
    );
  }

  ListView myPostsList(PostsLikeViewModel likePosts, myPosts) {
    return ListView.builder(
      itemCount: likePosts.likePosts.length,
      itemBuilder: (BuildContext context, int index) {
        return BuildPost(
          imgUrl: likePosts.baseUrl + (likePosts.likePosts[index].imageUrl ?? ''),
          postText: likePosts.likePosts[index].post ?? '',
          postTitle: likePosts.likePosts[index].subject ?? '',
          userUrl: likePosts.baseUrl + (likePosts.likePosts[index].avatarUrl ?? ''),
          fullname: likePosts.likePosts[index].fullname ?? '',
          totalLikes: myPosts.totalLikesComments[index].likes ?? '',
          totalComments: myPosts.totalLikesComments[index].comments ?? '',
          postDate: likePosts.likePosts[index].fixedDate,
          postId: int.parse(likePosts.likePosts[index].id ?? "1"),
        );
      },
    );
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

  IconButton myIconButton(VoidCallback onPressed, Icon myIcon) {
    return IconButton(
      onPressed: onPressed,
      icon: myIcon,
      iconSize: 30,
      color: Colors.black87,
    );
  }
}
