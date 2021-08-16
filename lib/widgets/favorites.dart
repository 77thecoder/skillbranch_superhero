import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/widgets/superhero_card.dart';

class Favorites extends StatelessWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 114),
          Text(
            'Your Favorites',
            style: TextStyle(
                color: SuperheroesColors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 20),
          SuperheroCard(
            name: 'Batman',
            realName: 'Bruce Wayne',
            imageUrl:
                'https://www.superherodb.com/pictures2/portraits/10/100/639.jpg',
          ),
          SizedBox(height: 8),
          SuperheroCard(
            name: 'Ironman',
            realName: 'Tony Stark',
            imageUrl:
                'https://www.superherodb.com/pictures2/portraits/10/100/85.jpg',
          ),
        ],
      ),
    );
  }
}
