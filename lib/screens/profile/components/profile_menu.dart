import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../tools/constants.dart';

class ProfileMenu extends StatelessWidget {
  ProfileMenu(
      {Key? key,
      required this.text,
      this.icon,
      this.press,
      this.secondIcon,
      this.toggle = false})
      : super(key: key);

  final String text;
  final String? icon;
  final VoidCallback? press;
  final IconData? secondIcon;
  bool toggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
            secondIcon == null
                ? SvgPicture.asset(
                    icon!,
                    color: MyTheme.of(context).primary,
                    width: 22,
                  )
                : Icon(
                    secondIcon!,
                    color: MyTheme.of(context).primary,
                  ),
            SizedBox(width: 20),
            Expanded(child: Text(text)),
            if (!toggle) Icon(Icons.keyboard_arrow_right),
            if (toggle) Icon(Icons.keyboard_arrow_down_sharp),
          ],
        ),
      ),
    );
  }
}
