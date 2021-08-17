import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/widgets/action_button.dart';

class SuperheroPage extends StatelessWidget {
  final String name;

  const SuperheroPage({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SuperheroesColors.background,
      body: SafeArea(
        child: SuperheroPageContent(name: name),
      ),
    );
  }
}

class SuperheroPageContent extends StatelessWidget {
  final String name;

  const SuperheroPageContent({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Text(
            name,
            style: TextStyle(
              color: SuperheroesColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: ActionButton(
            text: 'Back',
            onTap: () => Navigator.pop(context),
          ),
        )
      ],
    );
  }
}
