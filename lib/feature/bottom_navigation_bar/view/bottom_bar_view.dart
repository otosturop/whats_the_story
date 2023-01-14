import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whats_the_story/feature/bottom_navigation_bar/viewModel/bottom_bar_view_model.dart';

class BottomBarView extends StatelessWidget {
  const BottomBarView({super.key});

  @override
  Widget build(BuildContext context) {
    final navbarProvider = Provider.of<BottomBarViewModel>(context, listen: true);
    return Scaffold(
      body: navbarProvider.items[navbarProvider.selectedIndex].widget,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: navbarProvider.selectedIndex,
            onTap: (i) {
              navbarProvider.selectedIndex = i;
            },
            items: navbarProvider.items
                .map((e) => BottomNavigationBarItem(
                      icon: Icon(e.icon, size: 30.0),
                      label: e.name,
                    ))
                .toList()),
      ),
    );
  }
}
