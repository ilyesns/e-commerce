import 'package:blueraymarket/backend/schema/user/user_record.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';

import '../../../auth/auth_util.dart';
import '../../../auth/firebase_user_provider.dart';
import '../../../tools/nav/routes.dart';
import '../../../tools/nav/theme.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatefulWidget {
  Body();
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
          if (loggedIn)
            ProfileMenu(
              text: "Go to Dashbord",
              secondIcon: Icons.dashboard_outlined,
              press: () {
                context.pushNamed(
                  'DashboardScreen',
                  extra: <String, dynamic>{
                    kTransitionInfoKey: TransitionInfo(
                      hasTransition: true,
                      transitionType: PageTransitionType.rightToLeftWithFade,
                      duration: Duration(milliseconds: kTransitionDuration),
                    ),
                  },
                );
              },
            ),
          if (loggedIn)
            ProfileMenu(
              text: "Log Out",
              icon: "assets/icons/Log out.svg",
              press: () {
                GoRouter.of(context).prepareAuthEvent();
                signOut();

                context.goNamedAuth('Login', context.mounted);
              },
            ),
          if (!loggedIn)
            ProfileMenu(
              text: "Log In",
              icon: "assets/icons/log-in.svg",
              press: () {
                context.pushReplacementNamed('Login');
              },
            ),
        ],
      ),
    );
  }
}
