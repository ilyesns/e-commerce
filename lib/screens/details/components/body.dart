import 'package:flutter/material.dart';
import 'package:blueraymarket/components/default_button.dart';
import 'package:blueraymarket/tools/size_config.dart';

import 'color_dots.dart';
import 'product_description.dart';
import 'top_rounded_container.dart';
import 'product_images.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ProductImages(), // pass product
        TopRoundedContainer(
          color: Colors.white,
          child: Column(
            children: [
              ProductDescription(),
              TopRoundedContainer(
                color: Color(0xFFF6F7F9),
                child: Column(
                  children: [
                    ColorDots(),
                    TopRoundedContainer(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig().screenWidth * 0.15,
                          right: SizeConfig().screenWidth * 0.15,
                          bottom: getProportionateScreenWidth(context, 40),
                          top: getProportionateScreenWidth(context, 15),
                        ),
                        child: DefaultButton(
                          text: "Add To Cart",
                          press: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
