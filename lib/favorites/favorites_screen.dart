import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';
import 'components/check_out_card.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Body(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: MyTheme.of(context).primary,
      title: Text(
        "Your Favorites",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
