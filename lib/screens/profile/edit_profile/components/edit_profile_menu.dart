import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../tools/nav/theme.dart';

class EditProfileMenu extends StatelessWidget {
  const EditProfileMenu({Key? key, required this.text, this.press})
      : super(key: key);

  final String text;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: MyTheme.of(context).primary,
          padding: EdgeInsets.all(15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Color(0xFFF5F6F9),
        ),
        onPressed: press,
        child: Row(
          children: [
            Expanded(child: Text(text)),
          ],
        ),
      ),
    );
  }
}
