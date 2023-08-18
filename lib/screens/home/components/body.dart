import 'package:blueraymarket/backend/backend.dart';
import 'package:blueraymarket/backend/cache/hive_box.dart';
import 'package:blueraymarket/backend/schema/discount/discount_record.dart';
import 'package:blueraymarket/backend/schema/sub_category/sub_category_record.dart';
import 'package:blueraymarket/tools/animations.dart';
import 'package:blueraymarket/tools/app_state.dart';
import 'package:blueraymarket/tools/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../backend/schema/product/product_record.dart';
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
  final SubCategoryHive subCategoryHive = SubCategoryHive();
  final ProductHive productHive = ProductHive();
  final DiscountHive discountHive = DiscountHive();
  late final List<ProductRecord?> products;
  @override
  void initState() {
    super.initState();
    products = AppState().products;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        HomeHeader(),
        Expanded(
          child: SingleChildScrollView(
            child: FutureBuilder<List>(
                future: Future.wait([
                  subCategoryHive.getDataFromCache(
                      limit: 5,
                      queryBuilder: (q) =>
                          q.orderBy('sub_category_name', descending: false)),
                  discountHive.getDataFromCache(
                      queryBuilder: (q) =>
                          q.where('display_at_home', isEqualTo: true))
                ]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return loadingIndicator(context);
                  }
                  if (!snapshot.hasData && snapshot.data == null) {
                    return listEmpty("Home Page", context);
                  }

                  final subCategories =
                      snapshot.data![0] as List<SubCategoryRecord?>;

                  final discounts = snapshot.data![1]! as List<DiscountRecord?>;

                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                              height: getProportionateScreenWidth(context, 10)),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              height:
                                  getProportionateScreenHeight(context, 170),
                              child: DiscountBanner(
                                discounts: discounts,
                              )),
                          Categories(),
                          SpecialOffers(
                            subCategories: subCategories,
                            products: products,
                          ),
                          SizedBox(
                              height: getProportionateScreenWidth(context, 30)),
                          ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: subCategories.length,
                            itemBuilder: (BuildContext context, int index) {
                              final subcategoryItem = subCategories[index];
                              List<ProductRecord?> productsSubcategory =
                                  products
                                      .where((product) =>
                                          product!.idSubCategory ==
                                          subcategoryItem!.reference)
                                      .toList();
                              return SubCategoriesSection(
                                  subcategory: subcategoryItem!,
                                  products: productsSubcategory);
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                  height:
                                      getProportionateScreenWidth(context, 20));
                            },
                          )
                        ],
                      ),
                    ],
                  );
                }),
          ),
        )
      ],
    );
  }
}
