import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/auth_util.dart';
import '../../../tools/nav/theme.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "My Account",
            icon: "assets/icons/User Icon.svg",
            press: () => {},
          ),
          ProfileMenu(
            text: "Notifications",
            icon: "assets/icons/Bell.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Settings",
            icon: "assets/icons/Settings.svg",
            press: () {
              if (Theme.of(context).brightness == Brightness.light) {
                setDarkModeSetting(context, ThemeMode.dark);
              } else
                setDarkModeSetting(context, ThemeMode.light);
            },
          ),
          ProfileMenu(
            text: "Help Center",
            icon: "assets/icons/Question mark.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Go to Dashbord",
            secondIcon: Icons.dashboard_outlined,
            press: () {
              context.pushNamed(
                'DashboardScreen',
              );
            },
          ),
          ProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: () {
              context.pushReplacementNamed(
                'Login',
              );
              signOut();
            },
          ),
        ],
      ),
    );
  }
}
