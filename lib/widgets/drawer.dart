import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:CineMe/providers/auth.dart';
import 'package:CineMe/constant.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      color: Colors.blueGrey,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 90,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                "Welcome ",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Colors.black),
              ),
              Image.asset(
                kTheatreIconPath,
                height: 35,
                width: 35,
              ),
            ],
          ),
          Divider(),
          Spacer(),
          FlatButton(
            onPressed: () => Provider.of<Auth>(context, listen: false).logout(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Logout",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontSize: 19, color: Colors.black),
                ),
                Image.asset(
                  kExitIconPath,
                  height: 35,
                  width: 35,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
