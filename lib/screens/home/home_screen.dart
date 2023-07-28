import 'package:flutter/material.dart';
import 'package:blueraymarket/components/coustom_bottom_nav_bar.dart';
import 'package:blueraymarket/tools/enums.dart';

import '../../tools/size_config.dart';
import 'components/body.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Body()),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
