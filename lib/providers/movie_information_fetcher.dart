import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:CineMe/constant.dart';
import "package:CineMe/models/movie.dart";

class MovieInfoGetter with ChangeNotifier {
  Future<List<Movie>> searchForMovies(String keyword) async {
    final url =
        "https://api.themoviedb.org/3/search/movie?api_key=$kTmdbKey&language=en-US&query=$keyword";

    final response = await http.get(url);

    final extractedData = (json.decode(response.body)["results"] as List);
    extractedData.removeWhere(
      (movie) => movie["poster_path"] == null || movie["backdrop_path"] == null,
    );
    print(extractedData);
    return extractedData.map((movie) {
      return Movie.previewfromJson(movie);
    }).toList();
  }

  Future<Movie> getMovieInfoById(String id) async {
    final url =
        "https://api.themoviedb.org/3/movie/$id?api_key=$kTmdbKey&language=en-US&append_to_response=videos";
    final response = await http.get(url);
    final extractedData = json.decode(response.body);

    final Movie movie = Movie.detailfromJson(extractedData);

    return movie;
  }
}
