import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'constants.dart';

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
  late void Function({String error})? removeError;
  late void Function({String error})? addError;
  late String? error;

  late String labelText;
  late String hintText;
  bool obscureText;
  final TextEditingController? textFieldController;
  late String initValue;

  CustomTextField(
      {required this.labelText,
      required this.hintText,
      this.error,
      required this.focusNode,
      this.addError,
      this.removeError,
      this.obscureText = false,
      this.textFieldController,
      this.initValue = ''});

  late FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textFieldController,
      obscureText: obscureText,
      onSaved: (newValue) {},
      onChanged: (value) {},
      validator: (value) {
        if (value!.isEmpty) {
          addError!(error: error!);
          return "";
        } else if (value.length < 3) {
          addError!(error: error!);
          return "";
        }
        return null;
      },
      style: MyTheme.of(context).titleMedium.override(
          color: MyTheme.of(context).primaryText, fontFamily: 'Roboto'),
      decoration: InputDecoration(
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

class CustomTextFieldUpdated extends StatelessWidget {
  late void Function({String error})? removeError;
  late void Function({String error})? addError;
  late String? error;

  late String labelText;
  late String hintText;
  bool obscureText;
  late String initValue;

  CustomTextFieldUpdated(
      {required this.labelText,
      required this.hintText,
      this.error,
      required this.focusNode,
      this.addError,
      this.removeError,
      this.obscureText = false,
      this.initValue = '',
      this.onChanged});

  late FocusNode focusNode;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initValue,
      obscureText: obscureText,
      onSaved: (newValue) {},
      onChanged: onChanged,
      validator: (value) {
        if (value!.isEmpty) {
          addError!(error: error!);
          return "";
        } else if (value.length < 3) {
          addError!(error: 'At least 3 character');
          return "";
        }
        return null;
      },
      style: MyTheme.of(context).titleMedium.override(
          color: MyTheme.of(context).primaryText, fontFamily: 'Roboto'),
      decoration: InputDecoration(
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
  return Center(
    child: Container(
        width: getProportionateScreenWidth(context, 70),
        height: getProportionateScreenHeight(context, 70),
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
