import 'package:CineMe/constant.dart';
import 'package:CineMe/widgets/drawer.dart';
import 'package:flutter/material.dart';

class DestinationView extends StatelessWidget {
  final String title;
  final String iconPath;
  final Widget destBody;

  DestinationView({this.title, this.destBody, this.iconPath});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            children: <Widget>[
              Text(
                title == "Explore" ? "CineMe" : title,
              ),
              SizedBox(
                width: 10,
              ),
              Image.asset(
                title == "Explore" ? kTapeIconPath : iconPath,
                height: 30,
                width: 30,
              )
            ],
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: destBody,
    );
  }
}
