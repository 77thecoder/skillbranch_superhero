import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_colors.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const ActionButton({Key? key, required this.onTap, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 117.5, right: 117.5, bottom: 30),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          height: 40,
          decoration: BoxDecoration(
            color: SuperheroesColors.blue,
            border: Border.all(),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            text.toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: SuperheroesColors.white),
          ),
        ),
      ),
    );
  }
}
