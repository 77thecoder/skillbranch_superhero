import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_colors.dart';

class MinSymbols extends StatelessWidget {
  const MinSymbols({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Enter at least 3 symbols',
      style: TextStyle(
          color: SuperheroesColors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600),
    );
  }
}
