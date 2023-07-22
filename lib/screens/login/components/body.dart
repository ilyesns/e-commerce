import 'package:blueraymarket/screens/login/components/sign_up_form.dart';
import 'package:blueraymarket/tools/constants.dart';
import 'package:flutter/material.dart';
import 'package:blueraymarket/components/socal_card.dart';
import 'package:blueraymarket/tools/size_config.dart';
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
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(context, 20)),
            child: Column(
              children: [
                SizedBox(height: widget.sizeConfig.screenHeight * 0.04),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(context, 28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Sign in with your email and password  \nor continue with social media",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: widget.sizeConfig.screenHeight * 0.08),
                Container(
                  height: widget.sizeConfig.screenHeight / 1.9,
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
                              text: 'Log In',
                            ),
                            Tab(
                              text: 'Create Account',
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
                SizedBox(height: widget.sizeConfig.screenHeight * 0.08),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocalCard(
                      icon: "assets/icons/google-icon.svg",
                      press: () {},
                    ),
                    SocalCard(
                      icon: "assets/icons/facebook-2.svg",
                      press: () {},
                    ),
                    SocalCard(
                      icon: "assets/icons/twitter.svg",
                      press: () {},
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(context, 20)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
