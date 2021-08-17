import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/pages/superhero_page.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/widgets/action_button.dart';
import 'package:superheroes/widgets/info_with_button.dart';
import 'package:superheroes/widgets/superhero_card.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final MainBloc bloc = MainBloc();

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: bloc,
      child: Scaffold(
        backgroundColor: SuperheroesColors.background,
        body: SafeArea(
          child: MainPageContent(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}

class MainPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context);
    return Stack(
      children: [
        Center(child: MainPageStateWidget()),
        Align(
          alignment: Alignment.bottomCenter,
          child: ActionButton(
            text: 'Next state',
            onTap: () => bloc.nextState(),
          ),
        ),
      ],
    );
  }
}

class MainPageStateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context);
    return StreamBuilder<MainPageState>(
      stream: bloc.observeMainPageState(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return SizedBox();
        }
        final MainPageState state = snapshot.data!;
        switch (state) {
          case MainPageState.loading:
            return LoadingIndicator();
          case MainPageState.noFavorites:
            return NoFavorites();
          case MainPageState.minSymbols:
            return Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 110.0),
                child: MinSymbols(),
              ),
            );
          case MainPageState.nothingFound:
            return NothingFound();
          case MainPageState.loadingError:
            return Center(
              child: LoadingError(),
            );
          case MainPageState.searchResults:
            return Search();
          case MainPageState.favorites:
            return Favorites();
          default:
            return Text(
              state.toString(),
              style: TextStyle(color: Colors.white),
            );
        }
      },
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 110),
        child: CircularProgressIndicator(
          color: SuperheroesColors.blue,
          strokeWidth: 4,
        ),
      ),
    );
  }
}

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

class NothingFound extends StatelessWidget {
  const NothingFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfoWithButton(
      title: 'Nothing Found',
      subtitle: 'Search for something else',
      buttonText: 'Search',
      assetImage: 'assets/images/hulk.png',
      imageHeight: 119,
      imageWidth: 108,
      imageTopPadding: 9,
    );
  }
}

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

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 114),
          Text(
            'Search results',
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
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SuperheroPage(name: 'Batman'),
              ),
            ),
          ),
          SizedBox(height: 8),
          SuperheroCard(
            name: 'Venom',
            realName: 'Eddie Brock',
            imageUrl:
                'https://www.superherodb.com/pictures2/portraits/10/100/22.jpg',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SuperheroPage(name: 'Venom'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
