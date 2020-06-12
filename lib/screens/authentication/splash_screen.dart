import 'package:CineMe/constant.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkGrey,
      appBar: AppBar(
        title: Text("CineMe"),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
