import 'package:flutter/material.dart';
import 'package:shop_app/components/coustom_bottom_nav_bar.dart';
import 'package:shop_app/tools/enums.dart';

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
