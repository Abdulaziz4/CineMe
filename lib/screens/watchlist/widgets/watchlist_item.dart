import 'package:CineMe/constant.dart';
import 'package:CineMe/providers/watchlist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:CineMe/screens/movie_detail/movie_detail_screen.dart';
import 'package:CineMe/providers/auth.dart';

class WatchlistItem extends StatelessWidget {
  final String id;
  final String title;
  final String rate;
  final String date;
  final String posterPath;
  final List<String> categories;

  WatchlistItem({
    this.id,
    this.title,
    this.rate,
    this.date,
    this.posterPath,
    this.categories,
  });

  Widget _posterImage() {
    var url = "https://image.tmdb.org/t/p/w780$posterPath";
    if (posterPath == null) {
      // no image preview url
      url =
          "https://vb.haeaty.com/wp-content/uploads/2018/05/no-preview-available-17.jpg";
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
    );
  }

  void _showSnackBar(BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Item removed",
          textAlign: TextAlign.center,
        ),
        elevation: 6,
        duration: Duration(
          seconds: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(6),
            bottomRight: Radius.circular(6),
          ),
        ),
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
        padding: const EdgeInsets.only(right: 10),
        child: Icon(
          Icons.delete,
        ),
      ),
      key: UniqueKey(),
      onDismissed: (_) {
        Provider.of<Watchlist>(context, listen: false).removeFromWatchlist(
            id,
            Provider.of<Auth>(context, listen: false).userId,
            Provider.of<Auth>(context, listen: false).token);
        _showSnackBar(context);
      },
      child: GestureDetector(
        onTap: () => Navigator.of(context)
            .pushNamed(MovieDetailScreen.routeName, arguments: {
          "id": id,
        }),
        child: Container(
          // height: 130,
          child: Card(
            elevation: 7,
            margin: const EdgeInsets.all(8),
            color: Colors.blueGrey,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints(
                      minHeight: 100,
                      maxHeight: 110,
                    ),
                    child: _posterImage(),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "$title (${date.substring(0, 4)})",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(fontSize: 17),
                        ),
                        Divider(
                          color: kDarkGrey,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              color: Colors.yellow[700],
                              size: 20,
                            ),
                            Text(
                              rate,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(fontSize: 17),
                            ),
                          ],
                        ),
                        Divider(
                          color: kDarkGrey,
                        ),
                        FittedBox(
                            child: Text(
                                // show only three categories
                                categories.length > 3
                                    ? categories.sublist(0, 3).join(", ")
                                    : categories.join(", "),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(fontSize: 16))),
                      ],
                    ),
                  ),
                  Center(child: Icon(Icons.arrow_left)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
