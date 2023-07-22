import 'package:blueraymarket/tools/size_config.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';

class Login extends StatefulWidget {
  static String routeName = "/sign_in";

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  SizeConfig sizeConfig = SizeConfig();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}
