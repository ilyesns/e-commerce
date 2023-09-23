import 'package:blueraymarket/tools/internationalization.dart';
import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';

class CompleteProfileScreen extends StatefulWidget {
  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: MyTheme.of(context).primary,
        title: Text(MyLocalizations.of(context).getText('C8pP6')),
      ),
      body: Body(),
    );
  }
}
