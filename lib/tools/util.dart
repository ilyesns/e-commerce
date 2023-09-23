import 'package:blueraymarket/backend/schema/color/color_record.dart';
import 'package:blueraymarket/backend/schema/size/size_record.dart';
import 'package:blueraymarket/tools/app_state.dart';
import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../backend/schema/discount/discount_record.dart';
import '../backend/schema/variant/variant_record.dart';

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
      return this.substring(0, maxLength - 1) + '..';
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
  final bool readOnly;
  final void Function()? onTap;
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
      this.suffixIcon,
      this.readOnly = false,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readOnly,
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
    child: Center(
      child: Container(
          width: getProportionateScreenWidth(context, 30),
          height: getProportionateScreenHeight(context, 30),
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
      this.onSaved,
      this.onChange,
      this.disable = false});

  final List<String?> items;
  final String hint;
  final String? value;
  final String? Function(String?)? validator;
  final String? Function(String?)? onSaved;
  final String? Function(String?)? onChange;
  final bool disable;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: disable,
      child: DropdownButtonFormField2<String>(
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
        onChanged: onChange,
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
      ),
    );
  }
}

// ############# RegEx for email

final emailRegex = RegExp(
  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
);

extension CapitalizeFirstLetter on String {
  String capitalize() {
    if (this == null || this.isEmpty) {
      return this;
    }
    // Convert the first character to uppercase and concatenate it with the rest of the string.
    return this[0].toUpperCase() + this.substring(1);
  }
}

DiscountRecord? getDiscountRecord(DocumentReference<Object?> id) {
  return AppState()
      .discounts
      .where((element) => element!.reference == id)
      .firstOrNull;
}

List<ColorRecord?>? getColorsFromVariants(List<VariantRecord?> variants) {
  List<ColorRecord?>? list = [];
  if (variants.isNotEmpty)
    list = AppState()
        .colors
        .where((color) => variants.any((v) => v!.idColor == color?.reference))
        .toList();

  return list;
}

List<SizeRecord?>? getSizesFromVariants(List<VariantRecord?> variants) {
  List<SizeRecord?>? list = [];
  if (variants.isNotEmpty)
    list = AppState()
        .sizes
        .where((size) => variants.any((v) => v!.idSize == size!.reference))
        .toList();

  return list;
}
