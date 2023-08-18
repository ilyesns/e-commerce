import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

DateTime get getCurrentTimestamp => DateTime.now();

DateTime dateTimeFromSecondsSinceEpoch(int seconds) {
  return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
}

String dateTimeFormat(String format, DateTime? dateTime, {String? locale}) {
  if (dateTime == null) {
    return '';
  }
  if (format == 'relative') {
    return timeago.format(dateTime, locale: locale);
  }
  return DateFormat(format, locale).format(dateTime);
}

void showSnackbar(
  BuildContext context,
  String message, {
  bool loading = false,
  int duration = 4,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          if (loading)
            Padding(
              padding: EdgeInsetsDirectional.only(end: 10.0),
              child: Container(
                height: 20,
                width: 20,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          Text(message),
        ],
      ),
      duration: Duration(seconds: duration),
    ),
  );
}

extension TruncateText on String {
  String truncateText(int maxLength) {
    if (this.length <= maxLength) {
      return this;
    } else {
      return this.substring(0, maxLength - 1) + '.';
    }
  }
}

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController? textFieldController;
  final FocusNode focusNode;
  final String? error;
  final int maxLines;
  final int minLines;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String? value)? validator;
  final String? Function(String? value)? onChanged;
  final void Function({String? error})? removeError;
  final void Function({String? error})? addError;
  late Widget? suffixIcon;

  CustomTextField(
      {required this.labelText,
      required this.hintText,
      required this.focusNode,
      this.error,
      this.removeError,
      this.addError,
      this.obscureText = false,
      this.textFieldController,
      this.keyboardType = TextInputType.text,
      this.maxLines = 1,
      this.minLines = 1,
      this.validator,
      this.onChanged,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: keyboardType,
      controller: textFieldController,
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
      style: MyTheme.of(context).titleMedium.override(
          color: MyTheme.of(context).primaryText, fontFamily: 'Roboto'),
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintStyle: MyTheme.of(context)
            .titleMedium
            .override(fontSize: 14, fontFamily: 'Roboto'),
        labelText: labelText,
        hintText: hintText,
        labelStyle: TextStyle(
          color: focusNode.hasFocus ? MyTheme.of(context).primary : Colors.grey,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyTheme.of(context).primary)),
      ),
    );
  }
}

Widget loadingIndicator(context) {
  return Container(
    width: SizeConfig().screenWidth,
    height:
        SizeConfig().screenHeight - getProportionateScreenWidth(context, 200),
    child: Center(
      child: Container(
          width: getProportionateScreenWidth(context, 40),
          height: getProportionateScreenHeight(context, 40),
          child: LoadingIndicator(
            indicatorType: Indicator.ballRotateChase,
            colors: Theme.of(context).brightness == Brightness.dark
                ? [
                    Color.fromARGB(255, 245, 151, 117),
                    Color.fromARGB(255, 247, 132, 91),
                    Color(0xFFFF7643)
                  ]
                : [
                    Color.fromARGB(255, 238, 144, 144),
                    Color.fromARGB(255, 255, 105, 105),
                    Color(0xFFFE4B4B)
                  ],
            strokeWidth: 2,
          )),
    ),
  );
}

Widget listEmpty(String label, context) {
  return Center(
    child: Container(
      height: 100,
      child: Text(
        textAlign: TextAlign.center,
        "Your $label list is empty at the moment.",
        style: MyTheme.of(context).titleMedium,
      ),
    ),
  );
}

Widget searchNotAvailable(String label, context) {
  return Center(
    child: Container(
      height: 100,
      child: Text(
        textAlign: TextAlign.center,
        "Sorry, the $label you searched for is not available.",
        style: MyTheme.of(context).titleMedium,
      ),
    ),
  );
}

class CustomDropDownMenu extends StatelessWidget {
  CustomDropDownMenu(
      {super.key,
      required this.items,
      required this.hint,
      this.value,
      required this.validator,
      required this.onSaved});

  final List<String?> items;
  final String hint;
  final String? value;
  final String? Function(String?)? validator;
  final String? Function(String?)? onSaved;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      decoration: InputDecoration(
        // Add Horizontal padding using menuItemStyleData.padding so it matches
        // the menu padding when button's width is not specified.
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        // Add more decoration..
      ),
      value: value,
      hint: Text(
        hint,
        style: TextStyle(fontSize: 14),
      ),
      items: items
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item!,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
          .toList(),
      validator: validator,
      onChanged: (value) {
        //Do something when selected item is changed.
      },
      onSaved: onSaved,
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
