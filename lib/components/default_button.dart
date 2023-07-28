import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:flutter/material.dart';
import 'package:blueraymarket/tools/size_config.dart';

import '../tools/constants.dart';

// ignore: must_be_immutable
class DefaultButton extends StatelessWidget {
  DefaultButton(
      {Key? key,
      this.text,
      this.press,
      this.bgColor,
      this.textColor = Colors.white})
      : super(key: key);
  final String? text;
  final Function? press;
  Color? bgColor;
  Color textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: TextButton(
        style: TextButton.styleFrom(
          side: BorderSide(),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: bgColor ?? MyTheme.of(context).primary,
        ),
        onPressed: press as void Function()?,
        child: Text(text!,
            style: MyTheme.of(context)
                .titleMedium
                .override(color: textColor, fontFamily: 'Roboto')),
      ),
    );
  }
}
