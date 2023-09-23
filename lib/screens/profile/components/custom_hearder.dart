import 'package:blueraymarket/auth/auth_util.dart';
import 'package:blueraymarket/auth/firebase_user_provider.dart';
import 'package:blueraymarket/components/default_button.dart';
import 'package:blueraymarket/tools/nav/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';

import '../../../tools/app_state.dart';
import '../../../tools/nav/serializer.dart';
import '../../../tools/nav/theme.dart';
import '../../../tools/size_config.dart';

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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        Text(
                          'My Account',
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
                            child: SvgPicture.asset(
                              'assets/icons/Cart Icon.svg', // grid-2
                              width: 30,
                              color: MyTheme.of(context).secondaryReverse,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: getProportionateScreenHeight(context, 15),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (currentUserReference == null)
                      Text(
                        'Good Morning!',
                        style: MyTheme.of(context).bodyLarge.copyWith(
                            fontFamily: 'Open Sans',
                            color: MyTheme.of(context).secondaryReverse),
                      ),
                    if (currentUserReference != null)
                      Text(
                        'Good Morning! $currentUserDisplayName',
                        style: MyTheme.of(context).bodyLarge.copyWith(
                            fontFamily: 'Open Sans',
                            color: MyTheme.of(context).secondaryReverse),
                      ),
                    SizedBox(
                      height: 3,
                    ),
                    if (currentUserReference != null)
                      Text(
                        '${currentUser!.user!.email}',
                        style: MyTheme.of(context).bodySmall.copyWith(
                            fontFamily: 'Open Sans',
                            color: MyTheme.of(context).secondaryReverse),
                      ),
                  ],
                ),
                if (currentUserReference == null)
                  Container(
                    width: 100,
                    height: 40,
                    child: DefaultButton(
                        text: 'Log in',
                        press: () {
                          context.pushReplacementNamed('Login');
                        }),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
