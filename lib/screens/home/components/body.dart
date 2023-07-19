import 'package:flutter/material.dart';
import 'package:blueraymarket/tools/size_config.dart';

import 'categories.dart';
import 'discount_banner.dart';
import 'home_header.dart';
import 'popular_product.dart';
import 'special_offers.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: getProportionateScreenHeight(10)),
              HomeHeader(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: getProportionateScreenWidth(10)),
                      DiscountBanner(),
                      Categories(),
                      SpecialOffers(),
                      SizedBox(height: getProportionateScreenWidth(30)),
                      PopularProducts(),
                      SizedBox(height: getProportionateScreenWidth(30)),
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
