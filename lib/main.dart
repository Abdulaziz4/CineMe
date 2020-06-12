import 'package:CineMe/constant.dart';
import 'package:CineMe/providers/movie_information_fetcher.dart';
import 'package:CineMe/screens/authentication/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:provider/provider.dart";

import './screens/authentication/login_screen.dart';
import './screens/home/home_screen.dart';
import 'package:CineMe/screens/movie_detail/movie_detail_screen.dart';
import 'package:CineMe/providers/explore.dart';
import 'package:CineMe/providers/watchlist.dart';
import 'package:CineMe/providers/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Explore(),
        ),
        ChangeNotifierProvider(
          create: (_) => MovieInfoGetter(),
        ),
        ChangeNotifierProvider(
          create: (_) => Watchlist(),
        ),
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, authData, _) => MaterialApp(
          theme: ThemeData(
            primaryColor: kDarkGrey,
            accentColor: kDeepPurple,
            textTheme: TextTheme(
              bodyText1: GoogleFonts.roboto(
                fontSize: 30,
                color: kWhite,
              ),
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: authData.isAuth
              ? HomeScreen()
              : FutureBuilder(
                  future: authData.tryAutoLogin(),
                  builder: (context, dataSnapShot) {
                    if (dataSnapShot.connectionState ==
                        ConnectionState.waiting) {
                      return SplashScreen();
                    } else if (dataSnapShot.connectionState ==
                        ConnectionState.done) {
                      if (dataSnapShot.hasError) {
                        print(dataSnapShot.error.toString());
                        return Scaffold(
                          appBar: AppBar(
                            title: Text("An error occur "),
                          ),
                        );
                      } else {
                        // no errors

                        return LoginScreen();
                      }
                    } else {
                      return SplashScreen();
                    }
                  },
                ),
          routes: {
            HomeScreen.routeName: (ctx) => HomeScreen(),
            MovieDetailScreen.routeName: (ctx) => MovieDetailScreen(),
          },
        ),
      ),
    );
  }
}
