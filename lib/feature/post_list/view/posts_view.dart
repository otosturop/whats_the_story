import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kartal/kartal.dart';
import 'package:whats_the_story/feature/post_list/viewModel/posts_view_model.dart';
import 'package:whats_the_story/feature/post_list/view/build.post.dart';

class PostsView extends StatelessWidget {
  const PostsView({super.key});

  @override
  Widget build(BuildContext context) {
    final myPosts = Provider.of<PostsViewModel>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFEDF0F6),
      appBar: AppBar(
        title: myBrand(),
        actions: [
          // const SizedBox(width: 16.0),
          myIconButton(
            () {},
            const Icon(Icons.send),
          ),
        ],
      ),
      body: myPosts.isLoading
          ? SizedBox(
              height: context.dynamicHeight(0.9),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
            )
          : myPostsList(myPosts),
    );
  }

  ListView myPostsList(PostsViewModel myPosts) {
    return ListView.builder(
      itemCount: myPosts.posts.length,
      itemBuilder: (BuildContext context, int index) {
        return BuildPost(
          imgUrl: myPosts.baseUrl + (myPosts.posts[index].imageUrl ?? ''),
          postText: myPosts.posts[index].post ?? '',
          postTitle: myPosts.posts[index].subject ?? '',
          userUrl: myPosts.baseUrl + (myPosts.posts[index].avatarUrl ?? ''),
          fullname: myPosts.posts[index].fullname ?? '',
          totalLikes: myPosts.totalLikesComments[index].likes ?? '',
          totalComments: myPosts.totalLikesComments[index].comments ?? '',
          postDate: myPosts.posts[index].fixedDate,
          postId: int.parse(myPosts.posts[index].id ?? "1"),
          likeStatus: myPosts.posts[index].status ?? -1,
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
