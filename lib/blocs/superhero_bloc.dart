import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:superheroes/exception/api_exception.dart';
import 'package:superheroes/favorite_superheroes_storage.dart';
import 'package:superheroes/model/superhero.dart';

class SuperheroBloc {
  http.Client? client;
  final String id;

  final superheroSubject = BehaviorSubject<Superhero>();

  StreamSubscription? getFromFavoritesSubscription;
  StreamSubscription? requestSubscription;
  StreamSubscription? addToFavoriteSubscription;
  StreamSubscription? removeToFavoriteSubscription;

  SuperheroBloc({this.client, required this.id}) {
    getFromFavorites();
  }

  void getFromFavorites() {
    getFromFavoritesSubscription?.cancel();
    getFromFavoritesSubscription = FavoriteSuperheroesStorage.getInstance()
        .getSuperhero(id)
        .asStream()
        .listen((superhero) {
      if (superhero != null) {
        superheroSubject.add(superhero);
      }
      requestSuperhero();
    }, onError: (error, stackTrace) {
      print('Error happened in addToFavorite: $error, $stackTrace');
    });
  }

  void addToFavorite() {
    final superhero = superheroSubject.valueOrNull;
    if (superhero == null) {
      print("Error: superhero is null while shouldn't be");
      return;
    }

    addToFavoriteSubscription?.cancel();
    addToFavoriteSubscription = FavoriteSuperheroesStorage.getInstance()
        .addToFavorites(superhero)
        .asStream()
        .listen((event) {
      print("Added to favorites: $event");
    }, onError: (error, stackTrace) {
      print('Error happened in addToFavorite: $error, $stackTrace');
    });
  }

  void removeFromFavorite() {
    removeToFavoriteSubscription?.cancel();
    removeToFavoriteSubscription = FavoriteSuperheroesStorage.getInstance()
        .removeToFavorites(id)
        .asStream()
        .listen((event) {
      print("Removed to favorites: $event");
    }, onError: (error, stackTrace) {
      print('Error happened in removeToFavorite: $error, $stackTrace');
    });
  }

  Stream<bool> observerIsFavorite() =>
      FavoriteSuperheroesStorage.getInstance().observeIsFavorite(id);

  void requestSuperhero() {
    requestSubscription?.cancel();
    requestSubscription = request().asStream().listen(
      (superhero) {
        superheroSubject.add(superhero);
      },
      onError: (error, stackTrace) {
        print('Error happened in requestSuprhero: $error, $stackTrace');
      },
    );
  }

  Future<Superhero> request() async {
    final token = dotenv.env["SUPERHERO_TOKEN"];
    final response = await (client ??= http.Client())
        .get(Uri.parse("https://superheroapi.com/api/$token/$id"));
    if (response.statusCode >= 500 && response.statusCode <= 599) {
      throw ApiException('Server error happened');
    }
    if (response.statusCode >= 400 && response.statusCode <= 499) {
      throw ApiException('Client error happened');
    }
    final decoded = json.decode(response.body);
    if (decoded['response'] == 'success') {
      return Superhero.fromJson(decoded);
    } else if (decoded['response'] == 'error') {
      throw ApiException('Client error happened');
    }
    throw Exception("unknown error happened");
  }

  Stream<Superhero> observeSuperhero() => superheroSubject;

  void dispose() {
    client?.close();
    superheroSubject.close();
    requestSubscription?.cancel();
    addToFavoriteSubscription?.cancel();
    removeToFavoriteSubscription?.cancel();
    getFromFavoritesSubscription?.cancel();
  }
}