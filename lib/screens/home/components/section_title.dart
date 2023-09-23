import 'package:blueraymarket/tools/internationalization.dart';
import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:flutter/material.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:shimmer/shimmer.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key? key,
    required this.title,
    required this.press,
  }) : super(key: key);

  final String title;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(context, 20)),
      width: MediaQuery.sizeOf(context).width,
      height: getProportionateScreenHeight(context, 40),
      color: MyTheme.of(context).primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: MyTheme.of(context).titleMedium.copyWith(
                  fontFamily: 'Open Sans',
                  color: MyTheme.of(context).alternate)),
          GestureDetector(
            onTap: press,
            child: Text(
              MyLocalizations.of(context).getText('S4eM7'),
              style: MyTheme.of(context).bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerSectionTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(context, 20)),
      width: MediaQuery.sizeOf(context).width,
      height: getProportionateScreenHeight(context, 40),
      color: MyTheme.of(context).primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Shimmer.fromColors(
            baseColor: MyTheme.of(context).grayLight,
            highlightColor: MyTheme.of(context).grayDark,
            child: Text("text",
                style: MyTheme.of(context).titleMedium.copyWith(
                    fontFamily: 'Open Sans',
                    color: MyTheme.of(context).alternate)),
          ),
          GestureDetector(
            child: Text(
              MyLocalizations.of(context).getText('S4eM7'),
              style: MyTheme.of(context).bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
