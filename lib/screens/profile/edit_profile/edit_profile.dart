import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:flutter/material.dart';
import 'package:blueraymarket/components/coustom_bottom_nav_bar.dart';
import 'package:blueraymarket/tools/enums.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';

import '../../../auth/auth_util.dart';
import '../../../tools/constants.dart';
import '../../../tools/nav/routes.dart';
import '../components/profile_menu.dart';
import '../components/profile_pic.dart';
import 'components/edit_profile_menu.dart';
import 'components/logo_header.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Body()),
    );
  }
}

class Body extends StatefulWidget {
  Body();
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool menuOne = false;
  bool menuTwo = false;
  @override
  Widget build(BuildContext context) {
    print('Role :$currentUserRole');

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                LogoHeader(
                  title: 'Good Morning $currentUserDisplayName',
                ),
                SizedBox(height: 20),
                Container(
                  child: Column(
                    children: [
                      ProfileMenu(
                        toggle: menuOne,
                        text: "Profile information",
                        icon: "assets/icons/User Icon.svg",
                        press: () => {
                          setState(() {
                            menuOne = !menuOne;
                          })
                        },
                      ),
                      if (menuOne)
                        Column(
                          children: [
                            EditProfileMenu(
                              text: "Base Informations",
                              press: () => {
                                context.pushNamed('BaseInfosPage',
                                    extra: <String, dynamic>{
                                      kTransitionInfoKey: TransitionInfo(
                                          hasTransition: true,
                                          duration: kAnimationDuration,
                                          transitionType: PageTransitionType
                                              .rightToLeftWithFade)
                                    })
                              },
                            ),
                            EditProfileMenu(
                              text: "Change The Phone Number",
                              press: () => {},
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                ProfileMenu(
                  toggle: menuTwo,
                  text: "Security settings",
                  icon: "assets/icons/lock-svgrepo-com.svg",
                  press: () => {
                    setState(() {
                      menuTwo = !menuTwo;
                    })
                  },
                ),
                if (menuTwo)
                  Column(
                    children: [
                      EditProfileMenu(
                        text: "Change the password",
                        press: () => {},
                      ),
                      EditProfileMenu(
                        text: "Delete Account",
                        press: () => {},
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
