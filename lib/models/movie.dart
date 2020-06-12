import 'package:flutter/material.dart';

// movie model will be two kinds either for preview in the explore page or detailed in the movie detail screen
class Movie with ChangeNotifier {
  String id;
  String firebaseId;
  String title;
  String posterPath;
  String rating;
  String overview;
  String releaseDate;
  String backdropPath;
  List<String> categories;
  List<dynamic> productionCompanies;
  String runTime;
  // Released / Upcoming
  String status;
  bool inWatchlist = false;
  String voteCount;
  String videoKey;

  Movie.preview({
    this.id,
    this.title,
    this.posterPath,
    this.rating,
  });

  Movie.detail({
    this.id,
    this.backdropPath,
    this.categories,
    this.overview,
    this.posterPath,
    this.productionCompanies,
    this.rating,
    this.releaseDate,
    this.runTime,
    this.status,
    this.title,
    this.firebaseId,
    this.voteCount,
    this.videoKey,
  });

  factory Movie.previewfromJson(Map<String, dynamic> json) {
    return Movie.preview(
      id: json["id"].toString(),
      title: json["title"],
      posterPath: json["poster_path"],
      rating: json["vote_average"].toString(),
    );
  }

  factory Movie.detailfromJson(Map<String, dynamic> json) {
    return Movie.detail(
      id: json["id"].toString(),
      title: json["title"],
      posterPath: json["poster_path"],
      rating: json["vote_average"].toString(),
      categories:
          (json["genres"] as List).map((cat) => cat["name"] as String).toList(),
      overview: json["overview"],
      backdropPath: json["backdrop_path"],
      productionCompanies: json["production_companies"],
      releaseDate: json["release_date"],
      runTime: json["runtime"].toString(),
      status: json["status"],
      voteCount: json["vote_count"].toString(),
      videoKey: (json["videos"]["results"] as List).firstWhere(
        (video) => video["type"] == "Trailer",
      )["key"],
    );
  }
}
