import 'dart:ui';

import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:flutter_youtube/flutter_youtube.dart';

import 'package:CineMe/constant.dart';
import 'package:CineMe/providers/watchlist.dart';
import 'package:CineMe/models/movie.dart';
import 'package:CineMe/providers/auth.dart';
import 'package:CineMe/screens/movie_detail/widgets/category_container.dart';
import 'package:CineMe/providers/movie_information_fetcher.dart';

class MovieDetailScreen extends StatefulWidget {
  static const routeName = "/movie-item";

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  // will be assigned to the scaffold to be used to show snackbar
  final globalKey = GlobalKey<ScaffoldState>();
  List<Widget> categoriesText(List<String> categories) {
    List<Widget> temp = [];
    for (int i = 0; i < categories.length - 1; i++) {
      temp.add(
        Text(
          "${categories[i]} ,",
          style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14),
        ),
      );
    }
    temp.add(
      Text(
        categories[categories.length - 1],
        style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 14),
      ),
    );
    return temp;
  }

  Widget _builderMovieInfoRow(String title, String content) {
    return Row(
      children: <Widget>[
        Text(
          "$title: ",
          style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Colors.grey,
                fontSize: 15,
              ),
        ),
        FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            content.length < 17 ? content : "${content.substring(0, 17)}...",
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  color: Colors.white,
                  fontSize: 15,
                ),
            overflow: TextOverflow.clip,
          ),
        ),
      ],
    );
  }

  void playYoutubeVideoIdEditAuto(String id) {
    FlutterYoutube.onVideoEnded.listen((onData) {
      //perform your action when video playing is done
    });

    FlutterYoutube.playYoutubeVideoById(
      apiKey: kYoutubeKey,
      videoId: id,
      autoPlay: true,
      appBarColor: kDarkGrey,
      // backgroundColor: kDarkGrey,
    );
  }

  void _showSnackBar(String content) {
    globalKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          content,
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _builderPageContent(Movie movie, BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          expandedHeight: mediaQuery.height * 0.62,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: movie.backdropPath == null
                          ? AssetImage(kNoBackgroundPath)
                          : NetworkImage(
                              "https://image.tmdb.org/t/p/w500/${movie.backdropPath}"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        kDarkGrey,
                      ],
                      // stops: [0.7, 1],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  top: mediaQuery.height * 0.45,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: mediaQuery.width - 20,
                        ),
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                movie.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      fontSize:
                                          movie.title.length > 17 ? 24 : 30,
                                      color: Colors.white,
                                    ),
                                overflow: TextOverflow.clip,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "( ${movie.releaseDate.substring(0, 4)} )",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      fontSize: 17,
                                      color: Colors.white,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      movie.categories.length <= 3
                          ? Row(
                              // mainAxisAlignment: MainAxisAlignment.end,
                              children: movie.categories
                                  .map((cat) => CategoryContainer(cat))
                                  .toList(),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.end,
                                  children: movie.categories
                                      .sublist(0, 3)
                                      .map((cat) => CategoryContainer(cat))
                                      .toList(),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.end,
                                  children: movie.categories
                                      .sublist(3, movie.categories.length - 1)
                                      .map((cat) => CategoryContainer(cat))
                                      .toList(),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
                Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.play_circle_outline,
                      color: kWhite,
                      size: 50,
                    ),
                    onPressed: () {
                      playYoutubeVideoIdEditAuto(movie.videoKey);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Image.asset(
                              kTimerIconPath,
                              height: 35,
                              width: 35,
                            ),
                            Text(
                              "${movie.runTime} min",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              kStarIconPath,
                              height: 30,
                              width: 30,
                            ),
                            Text(
                              "${movie.rating} / 10",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                            ),
                            Text(
                              "${movie.voteCount} Reviews",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Consumer<Watchlist>(
                              builder: (context, watchlist, _) => IconButton(
                                  iconSize: 35,
                                  icon: Icon(
                                    watchlist.isInTheWatchList(movie.id)
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color: Colors.yellow[700],
                                  ),
                                  onPressed: () {
                                    watchlist.addMovie(
                                        movie,
                                        Provider.of<Auth>(context,
                                                listen: false)
                                            .userId,
                                        Provider.of<Auth>(context,
                                                listen: false)
                                            .token);
                                    if (!watchlist.isInTheWatchList(movie.id)) {
                                      // item has been removed
                                      _showSnackBar(
                                          "Item removed from your watchlist");
                                    } else {
                                      // item added
                                      _showSnackBar(
                                          "Item added to your watchlist");
                                    }
                                  }),
                            ),
                            Text(
                              "Watchlist",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                    color: Colors.grey,
                                    fontSize: 17,
                                  ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: mediaQuery.height * 0.3,
                          width: mediaQuery.width * 0.35,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          child: movie.posterPath == null
                              ? Image.asset(
                                  kNoPosterPath,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  "https://image.tmdb.org/t/p/w500${movie.posterPath}",
                                  fit: BoxFit.cover,
                                ),
                        ),
                        SizedBox(
                          width: mediaQuery.width * 0.05,
                        ),
                        Container(
                          constraints:
                              BoxConstraints(maxWidth: mediaQuery.width * 0.5),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _builderMovieInfoRow("Title", movie.title),
                                SizedBox(
                                  height: 10,
                                ),
                                _builderMovieInfoRow("Release Date",
                                    movie.releaseDate.replaceAll("-", ".")),
                                SizedBox(
                                  height: 10,
                                ),
                                _builderMovieInfoRow("Status: ", movie.status),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Storyline",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          movie.overview,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(fontSize: 17, color: Colors.grey),
                          maxLines: 20,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // setup a listener
    final routeArgs = (ModalRoute.of(context).settings.arguments as Map);
    final movieId = routeArgs["id"];

    return Scaffold(
      key: globalKey,
      backgroundColor: Theme.of(context).primaryColor,
      body: FutureBuilder(
          future: Provider.of<MovieInfoGetter>(context, listen: false)
              .getMovieInfoById(movieId),
          builder: (context, movieDataSnapShot) {
            if (movieDataSnapShot.connectionState == ConnectionState.waiting) {
              return Stack(
                children: [
                  Positioned(
                    top: 30,
                    left: 2,
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: kWhite,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              );
            } else if (movieDataSnapShot.connectionState ==
                ConnectionState.done) {
              final movie = movieDataSnapShot.data as Movie;
              print(movieDataSnapShot.hasData);
              if (movieDataSnapShot.hasData) {
                return _builderPageContent(movie, context);
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Sorry, Can't find any data"),
                      FlatButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.arrow_back),
                        label: Text("Go back"),
                      ),
                    ],
                  ),
                );
              }
            } else {
              return Text("An error occur");
            }
          }),
    );
  }
}
