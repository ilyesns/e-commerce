import 'package:blueraymarket/components/default_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';

import '../../../auth/auth_util.dart';
import '../../../auth/firebase_user_provider.dart';
import '../../../tools/nav/routes.dart';
import '../../../tools/nav/theme.dart';
import 'custom_hearder.dart';
import 'profile_menu.dart';

class Body extends StatefulWidget {
  Body();
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SafeArea(
          child: CustomAppBar(),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                //ProfilePic(),
                //SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Text(
                        'My Account ',
                        style: MyTheme.of(context).bodyLarge.copyWith(
                              fontFamily: 'Open Sans',
                              color: MyTheme.of(context).grayLight,
                            ),
                      )
                    ],
                  ),
                ),

                ProfileMenu(
                  text: "My Orders",
                  icon: "assets/icons/orders.svg",
                  press: () => {
                    context.pushNamed(
                      'MyOrdersPage',
                      extra: <String, dynamic>{
                        kTransitionInfoKey: TransitionInfo(
                          hasTransition: true,
                          transitionType:
                              PageTransitionType.rightToLeftWithFade,
                          duration: Duration(milliseconds: kTransitionDuration),
                        ),
                      },
                    )
                  },
                ),
                ProfileMenu(
                  text: "Notifications",
                  icon: "assets/icons/Bell.svg",
                  press: () {
                    context.pushNamed(
                      'NotificationPage',
                      extra: <String, dynamic>{
                        kTransitionInfoKey: TransitionInfo(
                          hasTransition: true,
                          transitionType:
                              PageTransitionType.rightToLeftWithFade,
                          duration: Duration(milliseconds: kTransitionDuration),
                        ),
                      },
                    );
                  },
                ),
                ProfileMenu(
                  text: "Settings",
                  icon: "assets/icons/Settings.svg",
                  press: () {
                    context.pushNamed(
                      'SettingsPage',
                      extra: <String, dynamic>{
                        kTransitionInfoKey: TransitionInfo(
                          hasTransition: true,
                          transitionType:
                              PageTransitionType.rightToLeftWithFade,
                          duration: Duration(milliseconds: kTransitionDuration),
                        ),
                      },
                    );
                  },
                ),
                ProfileMenu(
                  text: "Help Center",
                  icon: "assets/icons/Question mark.svg",
                  press: () {},
                ),
                if (loggedIn &&
                    currentUserRole!.toLowerCase() == 'admin' &&
                    currentUserRole != null)
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Text(
                              'Admin Control Panel ',
                              style: MyTheme.of(context).bodyLarge.copyWith(
                                    fontFamily: 'Open Sans',
                                    color: MyTheme.of(context).grayLight,
                                  ),
                            )
                          ],
                        ),
                      ),
                      ProfileMenu(
                        text: "Go to Dashbord",
                        secondIcon: Icons.dashboard_outlined,
                        press: () {
                          context.pushNamed(
                            'DashboardScreen',
                            extra: <String, dynamic>{
                              kTransitionInfoKey: TransitionInfo(
                                hasTransition: true,
                                transitionType:
                                    PageTransitionType.rightToLeftWithFade,
                                duration:
                                    Duration(milliseconds: kTransitionDuration),
                              ),
                            },
                          );
                        },
                      ),
                    ],
                  ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Text(
                        'My settings',
                        style: MyTheme.of(context).bodyLarge.copyWith(
                              fontFamily: 'Open Sans',
                              color: MyTheme.of(context).grayLight,
                            ),
                      )
                    ],
                  ),
                ),
                if (loggedIn)
                  Column(
                    children: [
                      ProfileMenu(
                        text: "My Account",
                        icon: "assets/icons/User Icon.svg",
                        press: () => {
                          context.pushNamed(
                            'EditProfilePage',
                            extra: <String, dynamic>{
                              kTransitionInfoKey: TransitionInfo(
                                hasTransition: true,
                                transitionType:
                                    PageTransitionType.rightToLeftWithFade,
                                duration:
                                    Duration(milliseconds: kTransitionDuration),
                              ),
                            },
                          )
                        },
                      ),
                    ],
                  ),
                Column(
                  children: [
                    ProfileMenu(
                      text: "Address Book",
                      icon: "assets/icons/address-book.svg",
                      press: () {},
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: DefaultButton(
                        text: loggedIn ? 'Log Out' : "Log In",
                        press: () {
                          loggedIn
                              ? signOut()
                              : context.pushReplacementNamed('Login');
                        },
                      ),
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
