import 'package:CineMe/screens/explore/explore_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:CineMe/constant.dart';
import 'package:CineMe/providers/explore.dart';
import 'package:CineMe/widgets/movie_item.dart';

class MoviesList extends StatelessWidget {
  // Trending today collection have only one page
  final CollectionType collectionType;
  final String title;

  MoviesList(this.collectionType, this.title);

  Widget _listBuilder(BuildContext context) {
    return FutureBuilder(
      future: fetchMovies(
        context,
      ),
      builder: (context, dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return LinearProgressIndicator(
            backgroundColor: Colors.blueGrey,
            valueColor: AlwaysStoppedAnimation<Color>(kWhite),
          );
        } else if (dataSnapShot.connectionState == ConnectionState.done) {
          return Consumer<Explore>(builder: (context, moviesData, _) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  ...moviesList(moviesData),
                  collectionType != CollectionType.TrendingToday
                      ? IconButton(
                          icon: Icon(
                            Icons.arrow_forward,
                            color: kPurple,
                          ),
                          onPressed: () => fetchMovies(context),
                        )
                      : Container(),
                ],
              ),
            );
          });
        } else {
          return Text("An error occur");
        }
      },
    );
  }

  // determine which list to access based on the collection type
  List<MovieItem> moviesList(Explore moviesData) {
    if (collectionType == CollectionType.Popular) {
      //.. obtain the popular movies

      return moviesData.popular
          .map(
            (movie) => MovieItem(
              id: movie.id,
              title: movie.title,
              releaseDate: movie.releaseDate,
              rate: movie.rating,
              posterPath: movie.posterPath,
            ),
          )
          .toList();
    } else if (collectionType == CollectionType.TopRated) {
      //.. obtain the top rated movies
      return moviesData.topRated
          .map(
            (movie) => MovieItem(
              id: movie.id,
              title: movie.title,
              releaseDate: movie.releaseDate,
              rate: movie.rating,
              posterPath: movie.posterPath,
            ),
          )
          .toList();
    } else if (collectionType == CollectionType.Upcoming) {
      //.. obtain the upcoming movies
      return moviesData.upcoming
          .map(
            (movie) => MovieItem(
              id: movie.id,
              title: movie.title,
              releaseDate: movie.releaseDate,
              rate: movie.rating,
              posterPath: movie.posterPath,
            ),
          )
          .toList();
    } else {
      return moviesData.trendingToday
          .map(
            (movie) => MovieItem(
              id: movie.id,
              title: movie.title,
              releaseDate: movie.releaseDate,
              rate: movie.rating,
              posterPath: movie.posterPath,
            ),
          )
          .toList();
    }
  }

  Future<void> fetchMovies(BuildContext context) async {
    final explore = Provider.of<Explore>(context, listen: false);
    // if (request == Request.Create) {
    switch (collectionType) {
      case CollectionType.Popular:
        {
          return await explore.fetchPopularMovies();
        }
        break;
      case CollectionType.TopRated:
        {
          return await explore.fetchTopRatedMovies();
        }
        break;
      case CollectionType.Upcoming:
        {
          return await explore.fetchUpcomingMovies();
        }
        break;
      case CollectionType.TrendingToday:
        {
          return await explore.fetchTrendingTodayMovies();
        }
        break;
      default:
        {}
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 18),
          ),
          Divider(
            color: kWhite,
            height: 15,
            thickness: 0.7,
          ),
          Container(
            child: _listBuilder(context),
            // height: 170,
            width: double.infinity,
          ),
        ]);
  }
}
