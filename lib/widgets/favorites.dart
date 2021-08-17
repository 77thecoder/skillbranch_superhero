import 'package:flutter/material.dart';
import 'package:superheroes/pages/superhero_page.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/widgets/superhero_card.dart';

class Favorites extends StatelessWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 114),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Text(
            'Your favorites',
            style: TextStyle(
                color: SuperheroesColors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800),
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: SuperheroCard(
            name: 'Batman',
            realName: 'Bruce Wayne',
            imageUrl:
                'https://www.superherodb.com/pictures2/portraits/10/100/639.jpg',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SuperheroPage(name: 'Batman'),
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: SuperheroCard(
            name: 'Ironman',
            realName: 'Tony Stark',
            imageUrl:
                'https://www.superherodb.com/pictures2/portraits/10/100/85.jpg',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SuperheroPage(name: 'Ironman'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
