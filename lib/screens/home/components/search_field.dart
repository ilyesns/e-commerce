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
      this.initValue,
      this.controller})
      : super(key: key);
  final ValueChanged<String> onChanged;
  final String hintText;
  final bool disable;
  final String? initValue;
  final TextEditingController? controller;
  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MyTheme.of(context).reverse,
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        controller: widget.controller,
        readOnly: widget.disable,
        focusNode: focusNode,
        onChanged: widget.onChanged,
        style: MyTheme.of(context).labelLarge.override(
            color: MyTheme.of(context).secondaryBackground,
            fontFamily: 'Open Sans'),
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            fillColor: Colors.white,
            contentPadding:
                EdgeInsets.all(getProportionateScreenHeight(context, 15)),
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            floatingLabelAlignment: FloatingLabelAlignment.start,
            labelStyle: TextStyle(
              color: Colors.grey,
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            hintText: widget.hintText,
            hintStyle: MyTheme.of(context)
                .titleMedium
                .override(fontSize: 14, fontFamily: 'Roboto'),
            prefixIcon: InkWell(
              onTap: () {
                KeyboardUtil.hideKeyboard(context);
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Icon(
                Icons.search,
                color: MyTheme.of(context).grayDark,
              ),
            )),
      ),
    );
  }
}
