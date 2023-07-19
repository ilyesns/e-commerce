import 'package:flutter/material.dart';
import 'package:blueraymarket/components/coustom_bottom_nav_bar.dart';
import 'package:blueraymarket/tools/enums.dart';

import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Body()),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
