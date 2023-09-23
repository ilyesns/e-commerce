import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:blueraymarket/tools/constants.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';

import '../../../tools/app_state.dart';
import '../../../tools/nav/routes.dart';
import '../../../tools/nav/serializer.dart';
import '../../../tools/nav/theme.dart';

class CustomAppBar extends StatelessWidget {
  CustomAppBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: MyTheme.of(context).secondaryBackground,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: getProportionateScreenHeight(context, 10),
          horizontal: getProportionateScreenWidth(context, 7),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  height: getProportionateScreenWidth(context, 40),
                  width: getProportionateScreenWidth(context, 40),
                  child: InkWell(
                    onTap: () {
                      context.pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: SvgPicture.asset(
                        'assets/icons/arrow-left.svg', // grid-2
                        width: 30,
                        color: MyTheme.of(context).grayDark,
                      ),
                    ),
                  ),
                ),
                Text(
                  title,
                  style: MyTheme.of(context)
                      .titleLarge
                      .copyWith(fontFamily: 'Open Sans', fontSize: 17),
                )
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: getProportionateScreenWidth(context, 38),
                  width: getProportionateScreenWidth(context, 38),
                  padding: EdgeInsets.all(5),
                  child: InkWell(
                    onTap: () {
                      // move to search page
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, top: 5),
                      child: SvgPicture.asset(
                        'assets/icons/Search Icon.svg', // grid-2
                        width: 30,
                        color: MyTheme.of(context).reverse,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: getProportionateScreenWidth(context, 38),
                  width: getProportionateScreenWidth(context, 38),
                  padding: EdgeInsets.all(5),
                  child: InkWell(
                    onTap: () {
                      context.pushNamed(
                        'CartPage',
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
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10, top: 5),
                      child: Badge(
                        offset: Offset(8, -3),
                        label: Text('${AppState().cart.length}'),
                        textColor: Colors.white,
                        backgroundColor: MyTheme.of(context).primary,
                        child: SvgPicture.asset(
                          'assets/icons/Cart Icon.svg', // grid-2
                          width: 30,
                          color: MyTheme.of(context).reverse,
                        ),
                      ),
                    ),
                  ),
                ),
                PopupMenuButton(
                    color: MyTheme.of(context).secondaryReverse,
                    position: PopupMenuPosition.over,
                    icon: Icon(Icons.more_horiz,
                        color: MyTheme.of(context).reverse),
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem<int>(
                          value: 0,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/Shop Icon.svg",
                                color: MyTheme.of(context).primaryText,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text("Home"),
                            ],
                          ),
                        ),
                        PopupMenuItem<int>(
                          value: 1,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/category.svg",
                                color: MyTheme.of(context).primaryText,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text("Categories"),
                            ],
                          ),
                        ),
                        PopupMenuItem<int>(
                          value: 2,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/User Icon.svg",
                                color: MyTheme.of(context).primaryText,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text("My Account"),
                            ],
                          ),
                        ),
                        PopupMenuItem<int>(
                          value: 3,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/help.svg",
                                color: MyTheme.of(context).primaryText,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text("Help"),
                            ],
                          ),
                        ),
                      ];
                    },
                    onSelected: (value) {
                      if (value == 0) {
                        context.pushReplacementNamed('NavBarPage',
                            queryParameters: {
                              'initialPage': serializeParam(
                                'HomePage',
                                ParamType.String,
                              ),
                            },
                            extra: {
                              kTransitionInfoKey: TransitionInfo(
                                  hasTransition: true,
                                  duration: 250.ms,
                                  transitionType:
                                      PageTransitionType.bottomToTop)
                            });
                      } else if (value == 1) {
                        context.pushReplacementNamed('NavBarPage',
                            queryParameters: {
                              'initialPage': serializeParam(
                                'CategoriesPage',
                                ParamType.String,
                              ),
                            },
                            extra: {
                              kTransitionInfoKey: TransitionInfo(
                                  hasTransition: true,
                                  duration: 250.ms,
                                  transitionType:
                                      PageTransitionType.bottomToTop)
                            });
                      } else if (value == 2) {
                        context.pushReplacementNamed('NavBarPage',
                            queryParameters: {
                              'initialPage': serializeParam(
                                'ProfilePage',
                                ParamType.String,
                              ),
                            },
                            extra: {
                              kTransitionInfoKey: TransitionInfo(
                                  hasTransition: true,
                                  duration: 250.ms,
                                  transitionType:
                                      PageTransitionType.bottomToTop)
                            });
                      }
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/**
 *  Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Text(
                    "rating", // rating
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 5),
                  SvgPicture.asset("assets/icons/Star Icon.svg"),
                ],
              ),
            )
 * 
*/