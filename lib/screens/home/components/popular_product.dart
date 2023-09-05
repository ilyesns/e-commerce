import 'package:blueraymarket/backend/schema/product/product_record.dart';
import 'package:blueraymarket/backend/schema/sub_category/sub_category_record.dart';
import 'package:flutter/material.dart';
import 'package:blueraymarket/components/product_card.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:shimmer/shimmer.dart';

import '../../../tools/nav/theme.dart';
import '../../../tools/util.dart';
import 'section_title.dart';

class SubCategoriesSection extends StatelessWidget {
  SubCategoriesSection({required this.subcategory, required this.products});
  final SubCategoryRecord? subcategory;

  late List<ProductRecord?> products;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getProportionateScreenWidth(context, 50),
      child: Column(
        children: [
          SectionTitle(
              title: subcategory!.subCategoryName as String, press: () {}),
          SizedBox(height: getProportionateScreenWidth(context, 20)),
          Container(
            width: SizeConfig().screenWidth,
            height: getProportionateScreenHeight(context, 170),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final productItem = products[index];
                  return ProductCard(
                    product: productItem!,
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class ShimmerSubCategoriesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: getProportionateScreenWidth(context, 50),
      child: Column(
        children: [
          ShimmerSectionTitle(),
          SizedBox(height: getProportionateScreenWidth(context, 20)),
          Container(
            width: SizeConfig().screenWidth,
            height: getProportionateScreenHeight(context, 170),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 2,
                itemBuilder: (context, index) {
                  return ShimmerProductCard();
                }),
          ),
        ],
      ),
    );
  }
}

class ShimmerProductCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(context, 20)),
      child: SizedBox(
        width: 200,
        height: 170,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Shimmer.fromColors(
              baseColor: MyTheme.of(context).grayLight,
              highlightColor: MyTheme.of(context).grayDark,
              child: Container(
                width: 150,
                height: 100,
                padding:
                    EdgeInsets.all(getProportionateScreenWidth(context, 20)),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: MyTheme.of(context).alternate),
              ),
            ),
            SizedBox(height: 10),
            Shimmer.fromColors(
              baseColor: MyTheme.of(context).grayLight,
              highlightColor: MyTheme.of(context).grayDark,
              child: Container(
                width: 60,
                height: 15,
                decoration: BoxDecoration(color: MyTheme.of(context).alternate),
              ),
            ),
            SizedBox(height: 10),
            Shimmer.fromColors(
              baseColor: MyTheme.of(context).grayLight,
              highlightColor: MyTheme.of(context).grayDark,
              child: Container(
                width: 40,
                height: 15,
                decoration: BoxDecoration(color: MyTheme.of(context).alternate),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
