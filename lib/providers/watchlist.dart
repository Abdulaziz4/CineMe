import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import "package:CineMe/models/movie.dart";

class Watchlist with ChangeNotifier {
  List<Movie> _watchlist = [];

  List<Movie> get moviesList {
    return _watchlist.toList();
  }

  Future<void> fetchAndSetMovies(String userId, String token) async {
    final url =
        "https://cineme-ac10b.firebaseio.com/usersWatchlist/$userId.json?auth=$token";
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map;

    List<Movie> temp = [];
    extractedData.forEach((key, data) {
      List<String> cate = [];
      (data["categories"] as List)
          .forEach((element) => cate.add(element.toString()));

      temp.add(
        Movie.detail(
          firebaseId: key.toString(),
          id: data["id"],
          title: data["title"],
          rating: data["rate"],
          overview: data["overview"],
          backdropPath: data["backdropPath"],
          status: data["status"],
          posterPath: data["posterPath"],
          releaseDate: data["date"],
          runTime: data["runtime"],
          productionCompanies: data["productionCompanies"] as List,
          categories: cate,
        ),
      );
    });

    _watchlist = temp;
  }

  Future<void> addMovie(Movie toAdd, String userId, String token) async {
    toAdd.inWatchlist = !toAdd.inWatchlist;

    notifyListeners();
    if (_watchlist.any((element) => element.id == toAdd.id)) {
      // remove from the watch list
      removeFromWatchlist(toAdd.id, userId, token);
    } else {
      _watchlist.add(toAdd);
      notifyListeners();
      final url =
          "https://cineme-ac10b.firebaseio.com/usersWatchlist/$userId.json?auth=$token";
      final response = await http.post(url,
          body: json.encode({
            "id": toAdd.id,
            "title": toAdd.title,
            "rate": toAdd.rating,
            "categories": toAdd.categories,
            "status": toAdd.status,
            "runtime": toAdd.runTime,
            "productionCompanies": toAdd.productionCompanies,
            "posterPath": toAdd.posterPath,
            "overview": toAdd.overview,
            "backdropPath": toAdd.backdropPath,
            "date": toAdd.releaseDate,
          }));
      if (response.statusCode >= 400) {
        toAdd.inWatchlist = !toAdd.inWatchlist;
        notifyListeners();
      }
      final extractedData = json.decode(response.body);

      // initlize the id
      _watchlist.singleWhere((element) => element.id == toAdd.id).firebaseId =
          extractedData["name"];
    }
  }

  // check if the id of the movie is in the watchlist or not
  bool isInTheWatchList(String id) {
    return _watchlist.any((element) => element.id == id);
  }

  // .. send request
  Future<void> removeFromWatchlist(
      String id, String userId, String token) async {
    int index = _watchlist.indexWhere((element) => element.id == id);
    Movie temp = _watchlist[index];
    _watchlist.removeAt(index);
    notifyListeners();
    final url =
        "https://cineme-ac10b.firebaseio.com/usersWatchlist/$userId/${temp.firebaseId}.json?auth=$token";
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _watchlist.insert(index, temp);
      notifyListeners();
    }
    temp = null;
  }
}
