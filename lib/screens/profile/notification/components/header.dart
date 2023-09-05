import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../tools/nav/theme.dart';
import '../../../../tools/size_config.dart';

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
            SizedBox(
              height: getProportionateScreenWidth(context, 40),
              width: getProportionateScreenWidth(context, 40),
              child: InkWell(
                onTap: () {
                  context.pop();
                },
                child: SvgPicture.asset(
                  'assets/icons/arrow-left.svg', // grid-2
                  width: 30,
                  color: MyTheme.of(context).grayDark,
                ),
              ),
            ),
            Text(
              title,
              style: MyTheme.of(context).titleSmall.copyWith(
                  fontFamily: 'Open Sans',
                  color: MyTheme.of(context).secondaryReverse),
            ),
            Container()
          ],
        ),
      ),
    );
  }
}
