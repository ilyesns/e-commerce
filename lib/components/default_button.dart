import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:flutter/material.dart';
import 'package:blueraymarket/tools/size_config.dart';

import '../tools/constants.dart';

// ignore: must_be_immutable
class DefaultButton extends StatefulWidget {
  DefaultButton(
      {Key? key,
      this.text,
      this.press,
      this.bgColor,
      this.textColor = Colors.white,
      this.isLoading = false})
      : super(key: key);
  final String? text;
  final Function? press;
  Color? bgColor;
  Color textColor;
  bool isLoading;

  @override
  State<DefaultButton> createState() => _DefaultButtonState();
}

class _DefaultButtonState extends State<DefaultButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      decoration: BoxDecoration(
        color: MyTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          side: BorderSide(color: Colors.transparent),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: widget.bgColor ?? MyTheme.of(context).primary,
        ),
        onPressed: widget.press as void Function()?,
        child: widget.isLoading
            ? CircularProgressIndicator(
                color: widget.textColor,
              )
            : Text(widget.text!,
                style: MyTheme.of(context)
                    .titleMedium
                    .override(color: widget.textColor, fontFamily: 'Roboto')),
      ),
    );
  }
}
