import 'package:flutter/material.dart';

import "package:CineMe/constant.dart";

import '../authentication/widgets/login_form.dart';
import '../authentication/widgets/top_bar.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = "/login-screen";
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            // fill all the device screen
            height: double.infinity,
            width: double.infinity,
            color: kDarkGrey,
          ),
          Container(
            child: TopBar(),
          ),
          Positioned(
            top: mediaQuery.height * 0.1,
            left: mediaQuery.width * 0.05,
            child: Row(
              children: <Widget>[
                Text("Welcome to CineMe",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: 22)),
                Image.asset(
                  kTapeIconPath,
                  height: 35,
                  width: 35,
                  alignment: Alignment.center,
                ),
              ],
            ),
          ),
          LoginForm(),
        ],
      ),
    );
  }
}
