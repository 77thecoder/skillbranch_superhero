import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/widgets/action_button.dart';
import 'package:superheroes/widgets/info_with_button.dart';

class NothingFound extends StatelessWidget {
  const NothingFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfoWithButton(
      title: 'Nothing Found',
      subtitle: 'Search for something else',
      buttonText: 'Search',
      assetImage: 'assets/images/hulk.png',
      imageHeight: 119,
      imageWidth: 108,
      imageTopPadding: 9,
    );
  }
}
