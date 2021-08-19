import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/pages/superhero_page.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/widgets/action_button.dart';
import 'package:superheroes/widgets/info_with_button.dart';
import 'package:superheroes/widgets/superhero_card.dart';
import 'package:http/http.dart' as http;

class MainPage extends StatefulWidget {
  final http.Client? client;
  MainPage({Key? key, this.client}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late MainBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = MainBloc(client: widget.client);
  }

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
  final FocusNode searchFieldFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(child: MainPageStateWidget(searchFieldFocusNode: searchFieldFocusNode,)),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
          child: SearchWidget(searchFieldFocucNode: searchFieldFocusNode,),
        ),
      ],
    );
  }
}

class SearchWidget extends StatefulWidget {
  final FocusNode searchFieldFocucNode;
  const SearchWidget({Key? key, required this.searchFieldFocucNode}) : super(key: key);

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
      focusNode: widget.searchFieldFocucNode,
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
  final FocusNode searchFieldFocusNode;

  const MainPageStateWidget({Key? key, required this.searchFieldFocusNode}) : super(key: key);
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
          case MainPageState.favorites:
            return Stack(
              children: [
                SuperheroesList(
                  title: "Your favorites",
                  stream: bloc.observeFavoriteSuperheroes(),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child:
                      ActionButton(onTap: bloc.removeFavorite, text: 'Remove'),
                ),
              ],
            );
          case MainPageState.noFavorites:
            return Stack(
              children: [
                Center(child: NoFavorites(searchFieldFocusNode: searchFieldFocusNode)),
                Align(
                  alignment: Alignment.bottomCenter,
                  child:
                      ActionButton(onTap: bloc.removeFavorite, text: 'Remove'),
                ),
              ],
            );
          case MainPageState.minSymbols:
            return Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 110.0),
                child: MinSymbols(),
              ),
            );
          case MainPageState.nothingFound:
            return NothingFound(searchFieldFocusNode: searchFieldFocusNode,);
          case MainPageState.loadingError:
            return LoadingError();
          case MainPageState.searchResults:
            return SuperheroesList(
              title: "Search results",
              stream: bloc.observeSearchedSuperheroes(),
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
  final FocusNode searchFieldFocusNode;
  const NoFavorites({Key? key, required this.searchFieldFocusNode}) : super(key: key);

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
      onTap: () => searchFieldFocusNode.requestFocus(),
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
  final FocusNode searchFieldFocusNode;
  const NothingFound({Key? key, required this.searchFieldFocusNode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfoWithButton(
      title: 'Nothing found',
      subtitle: 'Search for something else',
      buttonText: 'Search',
      assetImage: 'assets/images/hulk.png',
      imageHeight: 119,
      imageWidth: 108,
      imageTopPadding: 9,
      onTap: () => searchFieldFocusNode.requestFocus(),
    );
  }
}

class LoadingError extends StatelessWidget {
  const LoadingError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<MainBloc>(context, listen: false);
    return InfoWithButton(
      title: 'Error happened',
      subtitle: 'Please try again',
      buttonText: 'Retry',
      assetImage: 'assets/images/superman.png',
      imageHeight: 119,
      imageWidth: 108,
      imageTopPadding: 9,
      onTap: bloc.retry,
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
