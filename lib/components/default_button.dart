import 'package:flutter/material.dart';
import 'package:blueraymarket/tools/size_config.dart';

import '../tools/constants.dart';

// ignore: must_be_immutable
class DefaultButton extends StatelessWidget {
  DefaultButton(
      {Key? key,
      this.text,
      this.press,
      this.textColor = Colors.white,
      this.bgColor = kPrimaryColor})
      : super(key: key);
  final String? text;
  final Function? press;
  Color? textColor;
  Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child: TextButton(
        style: TextButton.styleFrom(
          side: BorderSide(),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: bgColor,
        ),
        onPressed: press as void Function()?,
        child: Text(
          text!,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18),
            color: textColor,
          ),
        ),
      ),
    );
  }
}
