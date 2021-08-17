import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/widgets/action_button.dart';
import 'package:superheroes/widgets/info_with_button.dart';

class LoadingError extends StatelessWidget {
  const LoadingError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InfoWithButton(
          title: 'Error happened',
          subtitle: 'Please try again',
          buttonText: 'Retry',
          assetImage: 'assets/images/superman.png',
          imageHeight: 119,
          imageWidth: 108,
          imageTopPadding: 9,
        ),
      ],
    );
  }
}

class LogoLoadingError extends StatelessWidget {
  const LogoLoadingError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            SizedBox(width: 108, height: 128),
            Container(
              width: 108,
              height: 108,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: SuperheroesColors.blue,
              ),
            ),
            Positioned(
              top: 9,
              child: SizedBox(
                width: 108,
                height: 119,
                child: Image.asset('assets/images/superman.png'),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Text(
          'Error happened',
          style: TextStyle(
              color: SuperheroesColors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800),
        ),
        SizedBox(height: 20),
        Text(
          'Please try again'.toUpperCase(),
          style: TextStyle(
              color: SuperheroesColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 30),
        ActionButton(
          onTap: () => print('retry'),
          text: 'Retry',
        ),
      ],
    );
  }
}
