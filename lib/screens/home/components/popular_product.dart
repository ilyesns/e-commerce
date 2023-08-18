import 'package:blueraymarket/backend/schema/product/product_record.dart';
import 'package:blueraymarket/backend/schema/sub_category/sub_category_record.dart';
import 'package:flutter/material.dart';
import 'package:blueraymarket/components/product_card.dart';
import 'package:blueraymarket/tools/size_config.dart';

import '../../../tools/util.dart';
import 'section_title.dart';

class SubCategoriesSection extends StatelessWidget {
  SubCategoriesSection({required this.subcategory, required this.products});
  final SubCategoryRecord subcategory;

  late List<ProductRecord?> products;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getProportionateScreenWidth(context, 50),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(context, 20)),
            child: SectionTitle(
                title: subcategory.subCategoryName as String, press: () {}),
          ),
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
