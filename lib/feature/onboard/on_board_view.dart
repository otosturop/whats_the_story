import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whats_the_story/feature/onboard/on_board_model.dart';
import 'package:whats_the_story/feature/onboard/tab_indicator.dart';
import 'package:whats_the_story/product/widget/on_board_card.dart';
import '../../product/padding/page_padding.dart';

part './module/start_fab_button.dart';

class OnBoardView extends StatefulWidget {
  const OnBoardView({super.key});

  @override
  State<OnBoardView> createState() => _OnBoardViewState();
}

class _OnBoardViewState extends State<OnBoardView> {
  final String _skipTile = 'Skip';
  int _selectedIndex = 0;
  bool get _isLastName => OnBoardsModels.onBoardsItems.length - 1 == _selectedIndex;
  bool get _isFirstPage => _selectedIndex == 0;
  final PageController pageController = PageController();

  ValueNotifier<bool> isBackEnable = ValueNotifier(false);

  void _incrementAndChange([int? value]) {
    if (_isLastName && value == null) {
      changeBackEnable(true);
      return;
    }
    changeBackEnable(false);
    _incrementSelectedPage(value);
  }

  void changeBackEnable(bool value) {
    if (value == isBackEnable.value) return;

    isBackEnable.value = value;
  }

  void _incrementSelectedPage(int? value) {
    setState((() {
      if (value != null) {
        _selectedIndex = value;
      } else {
        _selectedIndex++;
        pageController.animateToPage(
          _selectedIndex,
          duration: const Duration(microseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Padding(
        padding: const PagePadding.allNormal(),
        child: Column(children: [
          Expanded(child: _pageViewItems()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TabIndicator(selectedIndex: _selectedIndex),
              _StartFabButton(
                isLastPage: _isLastName,
                onPressed: () {
                  _incrementAndChange();
                },
              )
            ],
          ),
        ]),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      actions: [
        ValueListenableBuilder<bool>(
            valueListenable: isBackEnable,
            builder: (BuildContext context, bool value, Widget? child) {
              return value ? const SizedBox() : TextButton(onPressed: () {}, child: Text(_skipTile));
            })
      ],
      leading: _isFirstPage
          ? null
          : IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.chevron_left_outlined,
                color: Colors.grey,
              ),
            ),
    );
  }

  Widget _pageViewItems() {
    return PageView.builder(
        onPageChanged: (value) {
          _incrementAndChange(value);
        },
        controller: pageController,
        itemCount: OnBoardsModels.onBoardsItems.length,
        itemBuilder: (contex, index) {
          return OnBoardCard(
            model: OnBoardsModels.onBoardsItems[index],
          );
        });
  }
}
