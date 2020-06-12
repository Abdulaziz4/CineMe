import 'package:flutter/material.dart';

import "package:CineMe/screens/movie_detail/movie_detail_screen.dart";
import 'package:CineMe/constant.dart';

class MovieItem extends StatelessWidget {
  final String id;
  final String title;
  final String releaseDate;
  final String rate;
  final String posterPath;

  MovieItem({
    @required this.id,
    @required this.title,
    @required this.releaseDate,
    @required this.rate,
    @required this.posterPath,
  });

  Widget _posterImage() {
    var url = "https://image.tmdb.org/t/p/w500$posterPath";

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: posterPath == null
          ? Image.asset(
              kNoPosterPath,
              fit: BoxFit.cover,
            )
          : FadeInImage(
              placeholder: AssetImage(kMoviePlaceholderImage),
              image: NetworkImage(url),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 200),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(MovieDetailScreen.routeName, arguments: {
          "id": id,
        });
      },
      child: Container(
        padding: EdgeInsets.only(right: 5),
        height: mediaQuery.height * 0.3,
        width: mediaQuery.width * 0.33,
        child: Card(
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: <Widget>[
              _posterImage(),
              Positioned(
                top: 2,
                right: 5,
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      color: Colors.yellow[700],
                      size: 17,
                    ),
                    Text(
                      rate,
                      style: TextStyle(color: Colors.white),
                      overflow: TextOverflow.clip,
                    ),
                  ],
                ),
              ),
              // Positioned(
              //   bottom: 0,
              //   child: Container(
              //     // width: double.infinity,
              //     height: 30,
              //     color: Colors.black54,
              //   ),
              // ),
              // Positioned(
              //   bottom: 4,
              //   child: Container(
              //     alignment: Alignment.center,
              //     constraints: BoxConstraints(
              //       maxHeight: 30,
              //       minHeight: 0,
              //       maxWidth: 100,
              //       minWidth: 0,
              //     ),
              //     child: FittedBox(
              //       fit: BoxFit.scaleDown,
              //       child: Text(
              //         title,
              //         style: TextStyle(color: Colors.white),
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
