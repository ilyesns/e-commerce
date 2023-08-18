import 'dart:async';

import 'package:blueraymarket/backend/backend.dart';
import 'package:blueraymarket/backend/schema/brand/brand_record.dart';
import 'package:blueraymarket/components/default_button.dart';
import 'package:blueraymarket/screens/dashboard/manage_products/variants/colors/colors_screen.dart';
import 'package:blueraymarket/screens/dashboard/manage_products/variants/features/features_screen.dart';
import 'package:blueraymarket/tools/color_picker.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../../../auth/auth_util.dart';
import '../../../../backend/firebase_storage/storage.dart';
import '../../../../backend/schema/user/user_record.dart';
import '../../../../components/brand_manage/brand_manage.dart';
import '../../../../components/form_error.dart';
import '../../../../helper/keyboard.dart';
import '../../../../tools/nav/theme.dart';
import '../../../../tools/upload_data.dart';
import '../../../../tools/upload_file.dart';
import '../../../../tools/util.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../home/components/search_field.dart';
import 'sizes/sizes_screen.dart';

class VariantsScreen extends StatefulWidget {
  const VariantsScreen({super.key});

  @override
  State<VariantsScreen> createState() => _VariantsScreenState();
}

class _VariantsScreenState extends State<VariantsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: MyTheme.of(context).primary,
        title: Text("Variants Page"),
      ),
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  SizeConfig sizeConfig = SizeConfig();

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  List<Map<String, dynamic>> items = [
    {"title": "Color", "component": ColorsScreen(), "isExpanded": false},
    {"title": "Size", "component": SizesScreen(), "isExpanded": false},
    {"title": "Feature", "component": FeaturesScreen(), "isExpanded": false},
  ];

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_focusNode),
      child: Container(
        width: sizeConfig.screenWidth,
        height: sizeConfig.screenHeight,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              vertical: getProportionateScreenHeight(context, 20),
              horizontal: getProportionateScreenWidth(context, 20)),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ExpansionPanelList(
                elevation: 3,
                // Controlling the expansion behavior
                expansionCallback: (index, isExpanded) {
                  setState(() {
                    items[index]['isExpanded'] = !isExpanded;
                  });
                },
                animationDuration: Duration(milliseconds: 600),
                children: items
                    .map(
                      (item) => ExpansionPanel(
                        canTapOnHeader: true,
                        backgroundColor: item["isExpanded"]
                            ? MyTheme.of(context).secondaryBackground
                            : MyTheme.of(context).secondaryBackground,
                        headerBuilder: (_, isExpanded) => Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30),
                            child: Text(
                              item['title'],
                              style: TextStyle(fontSize: 20),
                            )),
                        body: item["component"],
                        isExpanded: item['isExpanded'],
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
