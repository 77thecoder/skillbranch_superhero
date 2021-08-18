import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/pages/superhero_page.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
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
    return Stack(
      children: [
        Center(child: MainPageStateWidget()),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
          child: SearchWidget(),
        ),
      ],
    );
  }
}

class SearchWidget extends StatefulWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController controller = TextEditingController();
  bool haveSearchedText = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
      controller.addListener(
        () {
          bloc.updateText(controller.text);
          final haveText = controller.text.isNotEmpty;
          if (haveSearchedText != haveText) {
            setState(() {
              haveSearchedText = haveText;
            });
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: SuperheroesColors.white,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.search,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 20,
        color: SuperheroesColors.white,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: SuperheroesColors.indigo75,
        isDense: true,
        prefixIcon: Icon(
          Icons.search,
          color: Colors.white54,
          size: 24,
        ),
        suffix: GestureDetector(
          onTap: () => controller.clear(),
          child: Icon(Icons.clear, color: Colors.white),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: haveSearchedText
              ? BorderSide(
                  color: SuperheroesColors.white,
                  width: 2,
                )
              : BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: SuperheroesColors.white,
            width: 2,
          ),
        ),
      ),
    );
  }
}

class MainPageStateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
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
            return LoadingError();
          case MainPageState.searchResults:
            return SuperheroesList(
              title: "Search results",
              stream: bloc.observeSearchedSuperheroes(),
            );
          case MainPageState.favorites:
            return SuperheroesList(
              title: "Your favorites",
              stream: bloc.observeFavoriteSuperheroes(),
            );
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

class SuperheroesList extends StatelessWidget {
  final String title;
  final Stream<List<SuperheroInfo>> stream;

  const SuperheroesList({
    Key? key,
    required this.title,
    required this.stream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SuperheroInfo>>(
      stream: stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.hasData == null) {
          return const SizedBox.shrink();
        }
        final List<SuperheroInfo> superheroes = snapshot.data!;
        return ListView.separated(
          physics: BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 90, bottom: 12),
                child: Text(
                  title,
                  style: TextStyle(
                    color: SuperheroesColors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                  ),
                ),
              );
            }
            final SuperheroInfo item = superheroes[index - 1];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SuperheroCard(
                superheroInfo: SuperheroInfo(
                  name: item.name,
                  realName: item.realName,
                  imageUrl: item.imageUrl,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SuperheroPage(name: item.name),
                    ),
                  );
                },
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 8);
          },
          itemCount: superheroes.length + 1,
        );
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
            superheroInfo: SuperheroInfo(
              name: 'Batman',
              realName: 'Bruce Wayne',
              imageUrl:
                  'https://www.superherodb.com/pictures2/portraits/10/100/639.jpg',
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SuperheroPage(name: 'Batman'),
              ),
            ),
          ),
          SizedBox(height: 8),
          SuperheroCard(
            superheroInfo: SuperheroInfo(
              name: 'Venom',
              realName: 'Eddie Brock',
              imageUrl:
                  'https://www.superherodb.com/pictures2/portraits/10/100/22.jpg',
            ),
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
        SizedBox(height: 90),
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
            superheroInfo: SuperheroInfo(
              name: 'Batman',
              realName: 'Bruce Wayne',
              imageUrl:
                  'https://www.superherodb.com/pictures2/portraits/10/100/639.jpg',
            ),
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
            superheroInfo: SuperheroInfo(
              name: 'Ironman',
              realName: 'Tony Stark',
              imageUrl:
                  'https://www.superherodb.com/pictures2/portraits/10/100/85.jpg',
            ),
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
