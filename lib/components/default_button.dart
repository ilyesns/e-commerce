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
      this.isLoading = false,
      this.disable = false})
      : super(key: key);
  final String? text;
  final Function? press;
  Color? bgColor;
  Color textColor;
  bool isLoading;
  bool disable;

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
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(118, 90, 90, 90).withOpacity(0.5),
            spreadRadius: 0.5,
            blurRadius: 4,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          side: BorderSide(color: Colors.transparent),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          backgroundColor: widget.disable
              ? MyTheme.of(context).accent3
              : widget.bgColor ?? MyTheme.of(context).primary,
        ),
        onPressed: widget.disable ? null : widget.press as void Function()?,
        child: widget.isLoading
            ? CircularProgressIndicator(
                color: widget.textColor,
              )
            : Text(widget.text!,
                style: MyTheme.of(context).titleMedium.override(
                    color: widget.textColor,
                    fontFamily: 'Roboto',
                    fontSize: 16.0)),
      ),
    );
  }
}
