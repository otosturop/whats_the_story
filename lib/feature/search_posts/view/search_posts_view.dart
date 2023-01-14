import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kartal/kartal.dart';

import '../../../product/constant/image_enum.dart';
import '../../post_list/viewModel/posts_view_model.dart';
import 'build.post.dart';

class SearchPostsView extends StatelessWidget {
  const SearchPostsView({super.key});

  @override
  Widget build(BuildContext context) {
    final myPosts = Provider.of<PostsViewModel>(context);
    return CustomScrollView(slivers: [
      SliverAppBar(
        title: myBrand(),
        floating: false,
        expandedHeight: context.dynamicHeight(0.3),
        flexibleSpace: (FlexibleSpaceBar(
          title: mySearchInput(myPosts),
          centerTitle: true,
          background: ImageEnum.search.toImage,
        )),
      ),
      SliverList(
          delegate: SliverChildBuilderDelegate(
        (context, index) {
          return BuildPost(
            fullname: myPosts.filterPosts[index].fullname ?? '',
            imgUrl: myPosts.baseUrl + (myPosts.filterPosts[index].imageUrl ?? ''),
            postText: myPosts.filterPosts[index].post ?? '',
            postTitle: myPosts.filterPosts[index].subject ?? '',
            userUrl: myPosts.baseUrl + (myPosts.filterPosts[index].avatarUrl ?? ''),
            totalLikes: myPosts.totalLikesComments[index].likes ?? '',
            totalComments: myPosts.totalLikesComments[index].comments ?? '',
            postDate: myPosts.filterPosts[index].fixedDate,
            postId: int.parse(myPosts.filterPosts[index].id ?? "1"),
          );
        },
        childCount: myPosts.filterPosts.length,
      ))
    ]);
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

  mySearchInput(myPosts) {
    return SizedBox(
      height: 50,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          cursorColor: Colors.grey,
          decoration: InputDecoration(
              labelText: 'Search',
              hintText: 'Search any words...',
              fillColor: Colors.white70,
              filled: true,
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
              prefixIcon: const Icon(
                Icons.search,
                size: 25,
              ),
              suffix: IconButton(
                icon: const Icon(
                  Icons.send,
                  size: 15,
                ),
                onPressed: () {},
              )),
          onChanged: (value) {
            myPosts.searchPosts(value);
          },
        ),
      ),
    );
  }
}
