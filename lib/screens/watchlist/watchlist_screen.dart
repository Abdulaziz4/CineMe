import 'package:CineMe/constant.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:CineMe/providers/watchlist.dart';
import 'package:CineMe/screens/watchlist/widgets/watchlist_item.dart';
import 'package:CineMe/providers/auth.dart';

class WatchlistScreen extends StatelessWidget {
  Widget _builderEmptyList(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          kEmptyListIconPath,
          scale: 5,
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Nothing to watch yet !",
          style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 17),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    return FutureBuilder(
      future: Provider.of<Watchlist>(context, listen: false)
          .fetchAndSetMovies(auth.userId, auth.token),
      builder: (context, watchlistDataSnapShot) {
        if (watchlistDataSnapShot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (watchlistDataSnapShot.connectionState ==
            ConnectionState.done) {
          return Consumer<Watchlist>(
            builder: (context, watchlist, _) => watchlist.moviesList.isEmpty
                ? Center(child: _builderEmptyList(context))
                : SingleChildScrollView(
                    child: Column(
                      children: watchlist.moviesList
                          .map(
                            (movie) => WatchlistItem(
                              id: movie.id,
                              title: movie.title,
                              categories: movie.categories,
                              date: movie.releaseDate,
                              rate: movie.rating,
                              posterPath: movie.posterPath,
                            ),
                          )
                          .toList(),
                    ),
                  ),
          );
        } else {
          return Center(
            child: Text("An error occur"),
          );
        }
      },
    );
  }
}
