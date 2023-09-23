import 'package:blueraymarket/tools/nav/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';

import '../../../tools/nav/serializer.dart';
import '../../../tools/nav/theme.dart';
import '../../../tools/size_config.dart';

class CustomAppBar extends StatelessWidget {
  CustomAppBar({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: MyTheme.of(context).primaryText,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: getProportionateScreenHeight(context, 5),
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
                Row(
                  children: [
                    Text(
                      title,
                      style: MyTheme.of(context).titleSmall.copyWith(
                          fontFamily: 'Open Sans',
                          color: MyTheme.of(context).secondaryReverse),
                    ),
                  ],
                ),
              ],
            ),
            PopupMenuButton(
                color: MyTheme.of(context).secondaryReverse,
                position: PopupMenuPosition.over,
                // add icon, by default "3 dot" icon
                // icon: Icon(Icons.book)
                icon: Icon(Icons.more_vert,
                    color: MyTheme.of(context).secondaryReverse),
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
                    context
                        .pushReplacementNamed('NavBarPage', queryParameters: {
                      'initialPage': serializeParam(
                        'HomePage',
                        ParamType.String,
                      ),
                    }, extra: {
                      kTransitionInfoKey: TransitionInfo(
                          hasTransition: true,
                          duration: 250.ms,
                          transitionType: PageTransitionType.bottomToTop)
                    });
                  } else if (value == 1) {
                    context
                        .pushReplacementNamed('NavBarPage', queryParameters: {
                      'initialPage': serializeParam(
                        'CategoriesPage',
                        ParamType.String,
                      ),
                    }, extra: {
                      kTransitionInfoKey: TransitionInfo(
                          hasTransition: true,
                          duration: 250.ms,
                          transitionType: PageTransitionType.bottomToTop)
                    });
                  } else if (value == 2) {
                    context
                        .pushReplacementNamed('NavBarPage', queryParameters: {
                      'initialPage': serializeParam(
                        'ProfilePage',
                        ParamType.String,
                      ),
                    }, extra: {
                      kTransitionInfoKey: TransitionInfo(
                          hasTransition: true,
                          duration: 250.ms,
                          transitionType: PageTransitionType.bottomToTop)
                    });
                  }
                })
          ],
        ),
      ),
    );
  }
}
