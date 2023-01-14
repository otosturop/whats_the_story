import 'package:flutter/material.dart';
import 'package:whats_the_story/feature/like_posts/view/like_posts_view.dart';
import 'package:whats_the_story/feature/post_list/view/posts_view.dart';
import 'package:whats_the_story/feature/profile/view/profile_view.dart';
import 'package:whats_the_story/feature/search_posts/view/search_posts_view.dart';

class BottomBarViewModel with ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }

  final List<NavbarComponent> _items = [
    NavbarComponent(
      name: "",
      icon: Icons.home,
      widget: const PostsView(),
    ),
    NavbarComponent(
      name: "",
      icon: Icons.search,
      widget: const SearchPostsView(),
    ),
    NavbarComponent(
      name: "",
      icon: Icons.favorite_border,
      widget: const MyLikePostsView(),
    ),
    NavbarComponent(
      name: "",
      icon: Icons.person_outline,
      widget: const ProfileView(),
    ),
  ];

  List<NavbarComponent> get items => _items;
}

class NavbarComponent {
  String? name;
  IconData? icon;
  Widget? widget;
  NavbarComponent({this.name, this.icon, this.widget});
}
