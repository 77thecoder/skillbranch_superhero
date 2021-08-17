import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/widgets/action_button.dart';

class InfoWithButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final String assetImage;
  final double imageHeight;
  final double imageWidth;
  final double imageTopPadding;

  const InfoWithButton({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.assetImage,
    required this.imageHeight,
    required this.imageWidth,
    required this.imageTopPadding,
  }) : super(key: key);

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
              top: imageTopPadding,
              child: SizedBox(
                width: imageWidth,
                height: imageHeight,
                child: Image.asset('assets/images/hulk.png'),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(
              color: SuperheroesColors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800),
        ),
        SizedBox(height: 20),
        Text(
          subtitle.toUpperCase(),
          style: TextStyle(
              color: SuperheroesColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 30),
        ActionButton(
          onTap: () => print('search'),
          text: buttonText,
        ),
      ],
    );
  }
}
