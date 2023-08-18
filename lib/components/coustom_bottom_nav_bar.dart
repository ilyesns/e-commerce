import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:blueraymarket/screens/home/home_screen.dart';
import 'package:blueraymarket/screens/profile/profile_screen.dart';
import 'package:go_router/go_router.dart';

import '../tools/constants.dart';
import '../tools/enums.dart';

class CustomBottomNavBar extends StatefulWidget {
  CustomBottomNavBar({Key? key, this.onTap});

  static MenuState? _selectedMenu = MenuState.home;
  static MenuState get selectedMenu => _selectedMenu!;
  static set selectedMenu(menu) => _selectedMenu = menu;
  late List<Function()?>? onTap;

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color.fromARGB(255, 87, 85, 85);

    List<Widget> widgets = [
      IconButton(
        icon: SvgPicture.asset(
          "assets/icons/Shop Icon.svg",
          color: MenuState.home == CustomBottomNavBar.selectedMenu
              ? kPrimaryColor
              : inActiveIconColor,
        ),
        onPressed: widget.onTap![0],
      ),
      IconButton(
        icon: SvgPicture.asset(
          "assets/icons/Heart Icon.svg",
          color: MenuState.favourite == CustomBottomNavBar.selectedMenu
              ? kPrimaryColor
              : inActiveIconColor,
        ),
        onPressed: () {},
      ),
      IconButton(
        icon: SvgPicture.asset(
          "assets/icons/Chat bubble Icon.svg",
          color: MenuState.message == CustomBottomNavBar.selectedMenu
              ? kPrimaryColor
              : inActiveIconColor,
        ),
        onPressed: () {},
      ),
      IconButton(
        icon: SvgPicture.asset(
          "assets/icons/User Icon.svg",
          color: MenuState.profile == CustomBottomNavBar.selectedMenu
              ? kPrimaryColor
              : inActiveIconColor,
        ),
        onPressed: widget.onTap![1],
      ),
    ];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [],
      ),
    );
  }
}
