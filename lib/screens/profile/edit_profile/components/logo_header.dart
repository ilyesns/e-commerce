import 'package:blueraymarket/auth/auth_util.dart';
import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogoHeader extends StatelessWidget {
  const LogoHeader({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: SizedBox(
        height: 100,
        width: 250,
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("assets/images/splash.png"),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              title,
              style: MyTheme.of(context).titleMedium.copyWith(
                  fontFamily: 'OutFit', color: MyTheme.of(context).primaryText),
            )
          ],
        ),
      ),
    );
  }
}
