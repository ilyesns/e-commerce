import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:flutter/material.dart';
import 'package:blueraymarket/tools/size_config.dart';

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: MyTheme.of(context).titleMedium.copyWith(
                fontFamily: 'Open Sans', color: MyTheme.of(context).primary)),
        GestureDetector(
          onTap: press,
          child: Text(
            "See More",
            style: MyTheme.of(context).bodySmall,
          ),
        ),
      ],
    );
  }
}
