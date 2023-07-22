import 'package:flutter/material.dart';
import 'package:blueraymarket/components/product_card.dart';
import 'package:blueraymarket/tools/size_config.dart';

import 'section_title.dart';

class PopularProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(context, 20)),
          child: SectionTitle(title: "Popular Products", press: () {}),
        ),
        SizedBox(height: getProportionateScreenWidth(context, 20)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // ############# edhy bch nbadlouha b product mte3na
              // ...List.generate(
              //   demoProducts.length,
              //   (index) {
              //     if (demoProducts[index].isPopular)
              //       return InkWell(
              //           onTap: () {},
              //           child: ProductCard(product: demoProducts[index]));

              //     return SizedBox
              //         .shrink(); // here by default width and height is 0
              //   },
              // ),
              SizedBox(width: getProportionateScreenWidth(context, 20)),
            ],
          ),
        )
      ],
    );
  }
}
