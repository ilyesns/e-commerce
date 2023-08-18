import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:blueraymarket/tools/constants.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:go_router/go_router.dart';

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
            Spacer(),
            Row(
              children: [
                Text(
                  title,
                  style: MyTheme.of(context).headlineSmall,
                )
              ],
            ),
            Spacer(),
            Container(
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
          ],
        ),
      ),
    );
  }
}
