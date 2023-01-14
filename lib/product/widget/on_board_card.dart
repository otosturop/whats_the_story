import 'package:flutter/material.dart';
import 'package:whats_the_story/feature/onboard/on_board_model.dart';

class OnBoardCard extends StatelessWidget {
  const OnBoardCard({
    Key? key,
    required this.model,
  }) : super(key: key);
  final OnBoardModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(model.title, style: Theme.of(context).textTheme.headline4),
        Text(model.description),
        Image.asset(model.imageWithPath)
      ],
    );
  }
}
