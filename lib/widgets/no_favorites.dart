import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/widgets/action_button.dart';

class NoFavorites extends StatelessWidget {
  const NoFavorites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LogoNoFavorites(),
      ],
    );
  }
}

class LogoNoFavorites extends StatelessWidget {
  const LogoNoFavorites({Key? key}) : super(key: key);

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
                child: Image.asset('assets/images/ironman.png'),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Text(
          'No favorites yet',
          style: TextStyle(
              color: SuperheroesColors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800),
        ),
        SizedBox(height: 20),
        Text(
          'Search and add'.toUpperCase(),
          style: TextStyle(
              color: SuperheroesColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 30),
        ActionButton(
          onTap: () => print('search'),
          text: 'Search',
        ),
      ],
    );
  }
}
