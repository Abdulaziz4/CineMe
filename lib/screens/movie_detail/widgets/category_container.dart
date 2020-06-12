import 'package:flutter/material.dart';

class CategoryContainer extends StatelessWidget {
  final String text;

  CategoryContainer(this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        right: 6,
      ),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFF707184),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.bodyText1.copyWith(
              fontSize: 14,
              color: Color(0xFF707184),
            ),
      ),
    );
  }
}
