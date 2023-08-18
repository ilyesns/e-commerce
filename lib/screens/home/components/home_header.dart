import 'package:blueraymarket/auth/auth_util.dart';
import 'package:blueraymarket/auth/firebase_user_provider.dart';
import 'package:blueraymarket/backend/schema/user/user_record.dart';
import 'package:blueraymarket/tools/nav/routes.dart';
import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:flutter/material.dart';
import 'package:blueraymarket/screens/cart/cart_screen.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:go_router/go_router.dart';

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
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(15),
              bottomLeft: Radius.circular(15))),
      child: Padding(
        padding: EdgeInsets.all(
          getProportionateScreenWidth(context, 10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: getProportionateScreenWidth(context, 240),
                height: getProportionateScreenHeight(context, 40),
                child: SearchField(
                    disable: true,
                    onChanged: (string) {},
                    hintText: "Search bar")),
            IconBtnWithCounter(
              svgSrc: "assets/icons/Cart Icon.svg",
              press: () => null,
            ),
            IconBtnWithCounter(
              svgSrc: "assets/icons/Bell.svg",
              numOfitem: 3,
              press: () {},
            ),
          ],
        ),
      ),
    );
  }
}
