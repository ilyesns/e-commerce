import 'package:flutter/material.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:go_router/go_router.dart';

import 'categories.dart';
import 'discount_banner.dart';
import 'home_header.dart';
import 'popular_product.dart';
import 'special_offers.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  SizeConfig sizeConfig = SizeConfig();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: getProportionateScreenHeight(context, 10)),
              HomeHeader(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                          height: getProportionateScreenWidth(context, 10)),
                      InkWell(
                          onTap: () {
                            context.pushNamed('CartPage');
                          },
                          child: DiscountBanner()),
                      Categories(),
                      SpecialOffers(),
                      SizedBox(
                          height: getProportionateScreenWidth(context, 30)),
                      PopularProducts(),
                      SizedBox(
                          height: getProportionateScreenWidth(context, 30)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
