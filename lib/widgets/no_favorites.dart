import 'package:flutter/material.dart';

import 'info_with_button.dart';

class NoFavorites extends StatelessWidget {
  const NoFavorites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfoWithButton(
      title: 'No favorites yet',
      subtitle: 'Search and add',
      buttonText: 'Search',
      assetImage: 'assets/images/ironman.png',
      imageHeight: 119,
      imageWidth: 108,
      imageTopPadding: 9,
    );
  }
}
