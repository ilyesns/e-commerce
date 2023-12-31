import 'package:blueraymarket/screens/login/components/sign_up_form.dart';
import 'package:blueraymarket/tools/constants.dart';
import 'package:blueraymarket/tools/internationalization.dart';
import 'package:flutter/material.dart';
import 'package:blueraymarket/tools/size_config.dart';
import '../../../tools/nav/theme.dart';
import 'sign_form.dart';

class Body extends StatefulWidget {
  SizeConfig sizeConfig = SizeConfig();
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    widget.sizeConfig.init(context);
    return SafeArea(
      child: Container(
        width: widget.sizeConfig.screenWidth,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(context, 20)),
          child: Column(
            children: [
              SizedBox(height: widget.sizeConfig.screenHeight * 0.04),
              Text(MyLocalizations.of(context).getText('W3lC6'),
                  style: MyTheme.of(context).headlineLarge),
              Text(
                MyLocalizations.of(context).getText('S9nI8'),
                style: MyTheme.of(context).bodyMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: widget.sizeConfig.screenHeight * 0.08),
              Expanded(
                child: Container(
                  height: widget.sizeConfig.screenHeight / 1.8,
                  child: DefaultTabController(
                    length: 2,
                    initialIndex: 0,
                    child: Column(
                      children: [
                        TabBar(
                          isScrollable: true,
                          labelColor: kPrimaryColor,
                          unselectedLabelColor: kSecondaryColor,
                          labelPadding: EdgeInsetsDirectional.fromSTEB(
                              32.0, 0.0, 32.0, 0.0),
                          labelStyle: labelStyle,
                          indicatorColor: kPrimaryColor,
                          indicatorWeight: 3.0,
                          tabs: [
                            Tab(
                              text:
                                  MyLocalizations.of(context).getText('L5gI1'),
                            ),
                            Tab(
                              text:
                                  MyLocalizations.of(context).getText('C9rA2'),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          // Use Expanded here to occupy remaining height
                          child: TabBarView(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: getProportionateScreenWidth(
                                        context, 10)),
                                child: SignForm(),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: getProportionateScreenWidth(
                                        context, 10)),
                                child: SignUpForm(),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
