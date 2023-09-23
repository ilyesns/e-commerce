import 'package:blueraymarket/auth/auth_util.dart';
import 'package:blueraymarket/auth/firebase_user_provider.dart';
import 'package:blueraymarket/components/default_button.dart';
import 'package:blueraymarket/tools/app_state.dart';
import 'package:blueraymarket/tools/nav/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../tools/nav/theme.dart';
import '../../../../tools/size_config.dart';

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: MyTheme.of(context).primaryText,
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
                Row(
                  children: [
                    Text(
                      'My Orders',
                      style: MyTheme.of(context).titleSmall.copyWith(
                          fontFamily: 'Open Sans',
                          color: MyTheme.of(context).secondaryReverse),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  height: getProportionateScreenWidth(context, 38),
                  width: getProportionateScreenWidth(context, 38),
                  padding: EdgeInsets.all(5),
                  child: InkWell(
                    onTap: () {
//
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: SvgPicture.asset(
                        'assets/icons/Search Icon.svg', // grid-2
                        width: 30,
                        color: MyTheme.of(context).secondaryReverse,
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
                      padding: const EdgeInsets.only(right: 10),
                      child: Badge(
                        offset: Offset(8, -3),
                        label: Text('${AppState().cart.length}'),
                        textColor: Colors.white,
                        backgroundColor: MyTheme.of(context).primary,
                        child: Badge(
                          offset: Offset(8, -3),
                          label: Text('${AppState().cart.length}'),
                          textColor: Colors.white,
                          backgroundColor: MyTheme.of(context).primary,
                          child: SvgPicture.asset(
                            'assets/icons/Cart Icon.svg', // grid-2
                            width: 30,
                            color: MyTheme.of(context).secondaryReverse,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
