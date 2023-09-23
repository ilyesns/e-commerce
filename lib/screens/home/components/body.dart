import 'package:blueraymarket/backend/backend.dart';
import 'package:blueraymarket/backend/cache/hive_box.dart';
import 'package:blueraymarket/backend/schema/discount/discount_record.dart';
import 'package:blueraymarket/backend/schema/sub_category/sub_category_record.dart';
import 'package:blueraymarket/tools/app_state.dart';
import 'package:blueraymarket/tools/internationalization.dart';
import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:blueraymarket/tools/util.dart';
import 'package:flutter/material.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:shimmer/shimmer.dart';

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
  late List<ProductRecord?> products;
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
          child: RefreshIndicator(
            backgroundColor: Colors.white,
            color: MyTheme.of(context).primary,
            onRefresh: () async {
              AppState().products = await queryProductsRecordOnce();

              setState(() {
                products = AppState().products;
                clearDiscountsBox();
                clearSubcategoryBox();
              });
            },
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
                      return ShimmerHome();
                    }
                    if (!snapshot.hasData && snapshot.data == null) {
                      return listEmpty(
                          MyLocalizations.of(context).getText('H4mP1'),
                          context);
                    }

                    final subCategories =
                        snapshot.data![0] as List<SubCategoryRecord?>;

                    final discounts =
                        snapshot.data![1]! as List<DiscountRecord?>;

                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                width: MediaQuery.of(context).size.width,
                                height:
                                    getProportionateScreenHeight(context, 120),
                                child: DiscountBanner(
                                  discounts: discounts,
                                )),
                            Categories(),
                            SpecialOffers(
                              subCategories: subCategories,
                              products: products,
                            ),
                            SizedBox(
                                height:
                                    getProportionateScreenWidth(context, 15)),
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
                                    height: getProportionateScreenWidth(
                                        context, 10));
                              },
                            )
                          ],
                        ),
                      ],
                    );
                  }),
            ),
          ),
        )
      ],
    );
  }
}

class ShimmerHome extends StatefulWidget {
  const ShimmerHome({super.key});

  @override
  State<ShimmerHome> createState() => _ShimmerHomeState();
}

class _ShimmerHomeState extends State<ShimmerHome> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                width: MediaQuery.of(context).size.width,
                height: getProportionateScreenHeight(context, 150),
                child: ShimmerDiscountBanner()),
            ShimmerCategories(),
            ShimmerSpecialOffers(),
            SizedBox(height: getProportionateScreenWidth(context, 15)),
            ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                return ShimmerSubCategoriesSection();
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                    height: getProportionateScreenWidth(context, 10));
              },
            )
          ],
        ),
      ],
    );
  }
}
