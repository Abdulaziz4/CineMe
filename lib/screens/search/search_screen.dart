import 'package:CineMe/constant.dart';
import 'package:CineMe/widgets/movie_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:CineMe/models/movie.dart';
import 'package:CineMe/providers/movie_information_fetcher.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final inputController = TextEditingController();
  bool _isLoading = false;
  List<Movie> searchResult = [];
  // to show no result or nothing
  bool hasSearched = false;
  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  Widget _builderNoResult() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          kNoResultIconPath,
          scale: 0.8,
        ),
        SizedBox(
          height: 22,
        ),
        Text(
          "No matching search results",
          style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 18),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              autofocus: false,
              enableInteractiveSelection: false,
              controller: inputController,
              decoration: InputDecoration(
                fillColor: kWhite,
                labelText: "Movie name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                filled: true,
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) async {
                setState(() {
                  _isLoading = true;
                });

                final response =
                    await Provider.of<MovieInfoGetter>(context, listen: false)
                        .searchForMovies(inputController.text);
                searchResult = response;
                hasSearched = true;

                setState(() {
                  _isLoading = false;
                });
              },
            ),
          ),
          SizedBox(
            height: mediaQuery.height * 0.66,
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : hasSearched
                    ? searchResult.length == 0
                        ? Center(
                            child: _builderNoResult(),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: GridView.builder(
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 5.0,
                                mainAxisSpacing: 5.0,
                                childAspectRatio: 0.7,
                              ),
                              itemCount: searchResult.length,
                              itemBuilder: (context, index) => MovieItem(
                                id: searchResult[index].id,
                                title: searchResult[index].title,
                                releaseDate: searchResult[index].releaseDate,
                                rate: searchResult[index].rating,
                                posterPath: searchResult[index].posterPath,
                              ),
                            ),
                          )
                    : Container(),
          ),
        ],
      ),
    );
  }
}
