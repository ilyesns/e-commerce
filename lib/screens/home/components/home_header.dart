import 'package:blueraymarket/auth/auth_util.dart';
import 'package:blueraymarket/auth/firebase_user_provider.dart';
import 'package:blueraymarket/backend/schema/user/user_record.dart';
import 'package:blueraymarket/tools/nav/routes.dart';
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
    return FutureBuilder<UserRecord>(
        future: !currentUser!.loggedIn
            ? null
            : UserRecord.getDocumentOnce(currentUserRef!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return Container(
              child: Text("no users "),
            );
          }

          final userRecord = snapshot.data!;

          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(context, 20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //SearchField(),
                Text("user name ${userRecord.name} "),
                IconBtnWithCounter(
                  svgSrc: "assets/icons/Cart Icon.svg",
                  press: () =>
                      Navigator.pushNamed(context, CartScreen.routeName),
                ),
                IconBtnWithCounter(
                  svgSrc: "assets/icons/Bell.svg",
                  numOfitem: 3,
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
        });
  }
}
