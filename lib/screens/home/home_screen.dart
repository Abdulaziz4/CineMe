import 'package:flutter/material.dart';

import 'package:CineMe/screens/home/widgets/destination_view.dart';
import 'package:CineMe/constant.dart';
import '../explore/explore_screen.dart';
import "../search/search_screen.dart";
import '../watchlist/watchlist_screen.dart';
import '../home/widgets/NavigationBarItemIcon.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home-screen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<DestinationView> allDestination = [
    DestinationView(
      title: "Explore",
      destBody: ExploreScreen(),
      iconPath: kTheatreIconPath,
    ),
    DestinationView(
      title: "Search",
      destBody: SearchScreen(),
      iconPath: kSearchIconPath,
    ),
    DestinationView(
      title: "Watchlist",
      destBody: WatchlistScreen(),
      iconPath: kListIconPath,
    ),
  ];

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    // flutter gives you the index for the selected tap
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedPageIndex,
        children: allDestination,
      ),
      bottomNavigationBar: SizedBox(
        // height: MediaQuery.of(context).size.height * 0.11,
        child: BottomNavigationBar(
          backgroundColor: Color(0xFFf7f6f4),
          elevation: 5,
          currentIndex: _selectedPageIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          selectedFontSize: 16,
          onTap: (index) => _selectPage(index),
          items: allDestination
              .map(
                (des) => BottomNavigationBarItem(
                  icon: NavigationBarItemIcon(des.iconPath),
                  title: Text(des.title),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
