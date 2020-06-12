import 'package:flutter/material.dart';

import 'package:CineMe/screens/explore/widgets/movies_list.dart';

enum CollectionType {
  Popular,
  TopRated,
  TrendingToday,
  Upcoming,
}

class ExploreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MoviesList(
              CollectionType.Popular,
              "Popular",
            ),
            SizedBox(
              height: 7,
            ),
            MoviesList(CollectionType.TopRated, "Top Rated"),
            SizedBox(
              height: 7,
            ),
            MoviesList(CollectionType.TrendingToday, "Trending Today"),
            SizedBox(
              height: 7,
            ),
            MoviesList(CollectionType.Upcoming, "Upcoming"),
          ],
        ),
      ),
    );
  }
}
