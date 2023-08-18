import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:flutter/material.dart';
import 'package:blueraymarket/tools/size_config.dart';

import '../../../helper/keyboard.dart';
import '../../../tools/constants.dart';

class SearchField extends StatefulWidget {
  SearchField(
      {Key? key,
      required this.onChanged,
      required this.hintText,
      this.disable = false,
      this.initValue})
      : super(key: key);
  final ValueChanged<String> onChanged;
  final String hintText;
  final bool disable;
  final String? initValue;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kSecondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: TextField(
        controller: TextEditingController(text: widget.initValue),
        readOnly: widget.disable,
        focusNode: focusNode,
        onChanged: widget.onChanged,
        style: MyTheme.of(context).labelLarge.override(
            color: MyTheme.of(context).primaryText, fontFamily: 'Open Sans'),
        decoration: InputDecoration(
            contentPadding:
                EdgeInsets.all(getProportionateScreenHeight(context, 15)),
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyTheme.of(context).primary),
                borderRadius: BorderRadius.all(Radius.circular(100))),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            floatingLabelAlignment: FloatingLabelAlignment.start,
            labelStyle: TextStyle(
              color: focusNode.hasFocus
                  ? MyTheme.of(context).primary
                  : Colors.grey,
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            hintText: widget.hintText,
            hintStyle: MyTheme.of(context)
                .titleMedium
                .override(fontSize: 14, fontFamily: 'Roboto'),
            suffixIcon: InkWell(
              onTap: () {
                KeyboardUtil.hideKeyboard(context);
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Icon(
                Icons.search,
                color: focusNode.hasFocus
                    ? MyTheme.of(context).primary
                    : MyTheme.of(context).secondaryText,
              ),
            )),
      ),
    );
  }
}
