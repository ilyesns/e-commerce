import 'package:blueraymarket/auth/auth_util.dart';
import 'package:blueraymarket/auth/firebase_user_provider.dart';
import 'package:blueraymarket/backend/schema/user/user_record.dart';
import 'package:blueraymarket/tools/internationalization.dart';
import 'package:blueraymarket/tools/nav/routes.dart';
import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:flutter/material.dart';
import 'package:blueraymarket/screens/cart/cart_screen.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../tools/app_state.dart';
import 'icon_btn_with_counter.dart';
import 'search_field.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: MyTheme.of(context).secondaryBackground,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(
              getProportionateScreenWidth(context, 10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                      width: getProportionateScreenWidth(context, 240),
                      height: getProportionateScreenHeight(context, 40),
                      child: SearchField(
                          disable: true,
                          onChanged: (string) {},
                          hintText:
                              MyLocalizations.of(context).getText('S6hB8'))),
                ),
                SizedBox(
                  width: 7,
                ),
                InkWell(
                  onTap: () => context.pushNamed('CartPage'),
                  child: Badge(
                    offset: Offset(8, -3),
                    label: Text('${AppState().cart.length}'),
                    textColor: Colors.white,
                    backgroundColor: MyTheme.of(context).primary,
                    child: SvgPicture.asset(
                      'assets/icons/Cart Icon.svg', // grid-2
                      color: MyTheme.of(context).primaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.sizeOf(context).width,
            height: getProportionateScreenHeight(context, 40),
            color: MyTheme.of(context).primary,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(context, 30)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      child: Text(
                        MyLocalizations.of(context).getText('F4rO1'),
                        style: MyTheme.of(context)
                            .titleMedium
                            .copyWith(color: MyTheme.of(context).alternate),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
