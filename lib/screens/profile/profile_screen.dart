import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:flutter/material.dart';
import 'package:blueraymarket/components/coustom_bottom_nav_bar.dart';
import 'package:blueraymarket/tools/enums.dart';

import '../../backend/schema/user/user_record.dart';
import 'components/body.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  late UserRecord currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.of(context).primary,
        title: Text("Profile"),
      ),
      body: Body(),
    );
  }
}
