import 'package:blueraymarket/tools/app_state.dart';
import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../tools/size_config.dart';
import '../notification/components/header.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.watch<AppState>();
    return Scaffold(
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late bool themeMode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    themeMode = MyTheme.themeMode == ThemeMode.dark ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AppState>();
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SafeArea(
          child: CustomAppBar(
            title: 'Settings',
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: getProportionateScreenHeight(context, 30),
                ),
                ItemSettings(title: 'Language', value: 'English '),
                ItemSettings(title: 'Currency', value: 'USD'),
                buildSwitchTile(
                  themeMode ? 'Dark Mode' : 'Light Mode',
                  themeMode,
                  (value) {
                    setState(() {
                      themeMode = value;
                      print(themeMode);
                    });
                    if (Theme.of(context).brightness == Brightness.light) {
                      setDarkModeSetting(context, ThemeMode.dark);
                    } else
                      setDarkModeSetting(context, ThemeMode.light);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSwitchTile(
      String title, bool value, ValueChanged<bool> onChanged) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            title,
            style: MyTheme.of(context).bodyLarge,
          ),
          trailing: Switch(
            activeColor: MyTheme.of(context).primary,
            value: value,
            onChanged: onChanged,
          ),
        ),
        Divider(
          thickness: 1, // Adjust the thickness as needed
        ),
      ],
    );
  }
}

class ItemSettings extends StatelessWidget {
  const ItemSettings({super.key, required this.title, required this.value});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(context, 20)),
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: MyTheme.of(context).bodyLarge,
              ),
              Row(
                children: [
                  Text(
                    value,
                    style: MyTheme.of(context).bodySmall,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SvgPicture.asset(
                    'assets/icons/arrow_right.svg',
                    color: MyTheme.of(context).secondaryText,
                  )
                ],
              ),
            ],
          ),
        ),
        Divider(
          thickness: 1, // Adjust the thickness as needed
        ),
      ],
    );
  }
}
