import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/widgets/action_button.dart';
import 'package:superheroes/widgets/info_with_button.dart';

class LoadingError extends StatelessWidget {
  const LoadingError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfoWithButton(
      title: 'Error happened',
      subtitle: 'Please try again',
      buttonText: 'Retry',
      assetImage: 'assets/images/superman.png',
      imageHeight: 119,
      imageWidth: 108,
      imageTopPadding: 9,
    );
  }
}
