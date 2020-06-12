import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:CineMe/constant.dart';
import 'package:http/http.dart' as http;

import '../models/movie.dart';

class Explore with ChangeNotifier {
  List<Movie> _popular = [];
  List<Movie> _topRated = [];
  List<Movie> _trendingToday = [];
  List<Movie> _upcoming = [];
  int _popularPageNumber = 1;
  int _topRatedPagenumber = 1;
  int _upcomingPageNumber = 1;

  List<Movie> get popular {
    return _popular.toList();
  }

  List<Movie> get topRated {
    return _topRated.toList();
  }

  List<Movie> get trendingToday {
    return _trendingToday.toList();
  }

  List<Movie> get upcoming {
    return _upcoming.toList();
  }

  Future<void> fetchPopularMovies() async {
    var url =
        "https://api.themoviedb.org/3/movie/popular?api_key=$kTmdbKey&language=en-US&page=$_popularPageNumber";

    final response = await http.get(url);
    final extractedData = json.decode(response.body);

    var tempList = extractedData["results"] as List;

    List<Movie> moviesList =
        tempList.map<Movie>((json) => Movie.previewfromJson(json)).toList();

    // merge the two lists
    moviesList.forEach((movie) => _popular.add(movie));
    _popularPageNumber++;
    notifyListeners();
  }

  Future<void> fetchTopRatedMovies() async {
    var url =
        "https://api.themoviedb.org/3/movie/top_rated?api_key=$kTmdbKey&language=en-US&page=$_topRatedPagenumber";

    final response = await http.get(url);
    final extractedData = jsonDecode(response.body);
    var tempList = extractedData["results"] as List;

    List<Movie> moviesList =
        tempList.map<Movie>((json) => Movie.previewfromJson(json)).toList();

    // merge the two lists
    moviesList.forEach((movie) => _topRated.add(movie));
    _topRatedPagenumber++;
    notifyListeners();
  }

  Future<void> fetchTrendingTodayMovies() async {
    const url =
        "https://api.themoviedb.org/3/trending/movie/day?api_key=$kTmdbKey";

    final response = await http.get(url);
    final extractedData = jsonDecode(response.body);
    var tempList = extractedData["results"] as List;

    List<Movie> moviesList =
        tempList.map<Movie>((json) => Movie.previewfromJson(json)).toList();

    // merge the two lists
    moviesList.forEach((movie) => _trendingToday.add(movie));

    notifyListeners();
  }

  Future<void> fetchUpcomingMovies() async {
    var url =
        "https://api.themoviedb.org/3/movie/upcoming?api_key=$kTmdbKey&language=en-US&page=$_upcomingPageNumber";

    final response = await http.get(url);
    final extractedData = jsonDecode(response.body);
    var tempList = extractedData["results"] as List;

    List<Movie> moviesList =
        tempList.map<Movie>((json) => Movie.previewfromJson(json)).toList();

    // merge the two lists
    moviesList.forEach((movie) => _upcoming.add(movie));
    _upcomingPageNumber++;
    notifyListeners();
  }
}
