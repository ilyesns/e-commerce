import 'dart:async';
import 'package:blueraymarket/backend/cache/hive_box.dart';
import 'package:blueraymarket/screens/details/details_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:blueraymarket/backend/backend.dart';
import 'package:blueraymarket/backend/schema/product/product_record.dart';
import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:blueraymarket/tools/util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../tools/nav/serializer.dart';
import 'components/header.dart';

class ListProductsScreen extends StatefulWidget {
  ListProductsScreen({this.idSubCategory, this.subCategoryName});
  final DocumentReference? idSubCategory;
  final String? subCategoryName;

  @override
  _ListProductsScreenState createState() => _ListProductsScreenState();
}

class _ListProductsScreenState extends State<ListProductsScreen> {
  late Future<List<ProductRecord?>> future;
  double maxCrossAxisExtent = 450;
  double childAspectRatio = 1.9;
  bool switchGrid = false;
  late ScrollController controller;
  bool isload = false;
  int limit = 5;

  @override
  void initState() {
    super.initState();

    future = ProductHive().getDataFromCache();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            ListProductsHeader(
              subname: widget.subCategoryName,
              switchGrid: switchGrid,
              onTap: () {
                setState(() {
                  switchGrid = !switchGrid;

                  maxCrossAxisExtent = maxCrossAxisExtent == 450 ? 300 : 450;
                  childAspectRatio = childAspectRatio == 1.9 ? 0.55 : 1.9;
                });
              },
            ),
            Expanded(
              child: RefreshIndicator(
                color: MyTheme.of(context).primary,
                onRefresh: () async {
                  setState(() {
                    clearProductsBox();
                    future = ProductHive().getDataFromCache();
                  });
                },
                child: SingleChildScrollView(
                  // controller: controller,
                  child: FutureBuilder<List<ProductRecord?>>(
                    future: future,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return ShimmerGridView(
                          switchGrid: switchGrid,
                          childAspectRatio: childAspectRatio,
                          maxCrossAxisExtent: maxCrossAxisExtent,
                        );
                      }
                      if (!snapshot.hasData || snapshot.data == null) {
                        return listEmpty("List Products Page", context);
                      }
                      final products = snapshot.data!
                          .where((element) =>
                              element!.idSubCategory == widget.idSubCategory)
                          .toList();
                      final itemCount =
                          products.length < limit ? products.length : limit;
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(
                                getProportionateScreenWidth(context, 10)),
                            child: Row(
                              children: [
                                Text(
                                  'All ${products.length} Products',
                                  style: MyTheme.of(context).labelMedium,
                                ),
                              ],
                            ),
                          ),
                          GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: maxCrossAxisExtent,
                              childAspectRatio: childAspectRatio,
                              crossAxisSpacing: 5.0,
                              mainAxisSpacing: 5.0,
                            ),
                            shrinkWrap: true,
                            itemCount: itemCount,
                            itemBuilder: (context, index) {
                              return InkWell(
                                  onTap: () {
                                    context.pushNamed('ProductDetailsScreen',
                                        queryParameters: {
                                          'idproduct': serializeParam(
                                            products[index]!.ffRef!,
                                            ParamType.DocumentReference,
                                          ),
                                          'idSubCategory': serializeParam(
                                            products[index]!.idSubCategory,
                                            ParamType.DocumentReference,
                                          )
                                        });
                                  },
                                  child: switchGrid
                                      ? ProductItemMedium(
                                          product: products[index]!,
                                        )
                                      : ProductItemLarge(
                                          product: products[index]!,
                                        ));
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductItemLarge extends StatelessWidget {
  ProductItemLarge({
    required this.product,
    super.key,
  });

  final ProductRecord product;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyTheme.of(context).secondaryBackground,
      width: MediaQuery.sizeOf(context).width,
      height: getProportionateScreenHeight(context, 170),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: Container(
                  padding: EdgeInsets.only(right: 10),
                  width: getProportionateScreenWidth(context, 120),
                  height: getProportionateScreenHeight(context, 100),
                  child: Center(
                    child: CachedNetworkImage(
                        imageUrl: product.image!,
                        placeholder: (context, url) => Image.asset(
                            'assets/images/blue_ray_image.jpg'), // Placeholder widget
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error)),
                  )),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title!,
                    style: MyTheme.of(context).bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Open Sans',
                        color: MyTheme.of(context).grayLight),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(context, 10),
                  ),
                  Text(
                    'US\$ ${product.price} ',
                    style: MyTheme.of(context).titleSmall.copyWith(
                        fontFamily: 'Open Sans',
                        color: MyTheme.of(context).primary),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(context, 10),
                  ),
                  ExpandableTextWidget(
                    text: product.description!,
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(context, 10),
                  ),
                  Row(
                    children: [
                      Text("rating", // rating
                          style: MyTheme.of(context).bodyMedium.copyWith(
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600)),
                      SizedBox(width: 5),
                      Row(
                        children: [
                          SvgPicture.asset("assets/icons/Star Icon.svg"),
                          SizedBox(
                            width: 3,
                          ),
                          SvgPicture.asset("assets/icons/Star Icon.svg"),
                          SizedBox(
                            width: 3,
                          ),
                          SvgPicture.asset("assets/icons/Star Icon.svg"),
                        ],
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ProductItemMedium extends StatelessWidget {
  ProductItemMedium({
    required this.product,
    super.key,
  });

  final ProductRecord product;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyTheme.of(context).secondaryBackground,
      width: MediaQuery.sizeOf(context).width,
      height: getProportionateScreenHeight(context, 170),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Container(
                  padding: EdgeInsets.only(right: 10),
                  width: getProportionateScreenWidth(context, 120),
                  height: getProportionateScreenHeight(context, 100),
                  child: Center(
                    child: CachedNetworkImage(
                        imageUrl: product.image!,
                        placeholder: (context, url) => Image.asset(
                            'assets/images/blue_ray_image.jpg'), // Placeholder widget
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error)),
                  )),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title!,
                    style: MyTheme.of(context).bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Open Sans',
                        color: MyTheme.of(context).grayLight),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(context, 10),
                  ),
                  Text(
                    'US\$ ${product.price} ',
                    style: MyTheme.of(context).titleSmall.copyWith(
                        fontFamily: 'Open Sans',
                        color: MyTheme.of(context).primary),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(context, 10),
                  ),
                  ExpandableTextWidget(
                    text: product.description!,
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(context, 10),
                  ),
                  Row(
                    children: [
                      Text("rating", // rating
                          style: MyTheme.of(context).bodyMedium.copyWith(
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.w600)),
                      SizedBox(width: 5),
                      Row(
                        children: [
                          SvgPicture.asset("assets/icons/Star Icon.svg"),
                          SizedBox(
                            width: 3,
                          ),
                          SvgPicture.asset("assets/icons/Star Icon.svg"),
                          SizedBox(
                            width: 3,
                          ),
                          SvgPicture.asset("assets/icons/Star Icon.svg"),
                        ],
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ExpandableTextWidget extends StatefulWidget {
  final String text;

  ExpandableTextWidget({required this.text});

  @override
  _ExpandableTextWidgetState createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.text,
              maxLines: expanded ? 4 : 2,
              overflow: TextOverflow.ellipsis,
              style: MyTheme.of(context).bodySmall.copyWith(
                  fontFamily: 'Open Sans',
                  color: MyTheme.of(context).grayLight)),
          if (widget.text.length > 30)
            GestureDetector(
              onTap: () {
                setState(() {
                  expanded = !expanded;
                });
              },
              child: Text(expanded ? "See Less" : "See More",
                  overflow: TextOverflow.visible,
                  style: MyTheme.of(context).bodySmall.copyWith(
                      fontFamily: 'Open Sans',
                      color: MyTheme.of(context).primary)),
            ),
        ],
      ),
    );
  }
}

class ShimmerGridView extends StatelessWidget {
  ShimmerGridView(
      {this.maxCrossAxisExtent = 450,
      this.childAspectRatio = 1.9,
      required this.switchGrid});

  double maxCrossAxisExtent;
  double childAspectRatio;
  final bool switchGrid;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: EdgeInsets.all(getProportionateScreenWidth(context, 10)),
        child: Row(
          children: [
            Container(
              width: 70,
              height: getProportionateScreenHeight(context, 15),
              child: Shimmer.fromColors(
                  baseColor: MyTheme.of(context).grayLight,
                  highlightColor: MyTheme.of(context).grayDark,
                  child: Container(
                    color: Colors.white,
                  )),
            ),
          ],
        ),
      ),
      GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: maxCrossAxisExtent,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: 3.0,
          mainAxisSpacing: 3.0,
        ),
        shrinkWrap: true,
        itemCount: 4,
        itemBuilder: (context, index) {
          return switchGrid
              ? ShimmerProductMediumItem()
              : ShimmerProductLargeItem();
        },
      )
    ]);
  }
}

class ShimmerProductLargeItem extends StatelessWidget {
  ShimmerProductLargeItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyTheme.of(context).secondaryBackground,
      width: MediaQuery.sizeOf(context).width,
      height: getProportionateScreenHeight(context, 170),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: Shimmer.fromColors(
                baseColor: MyTheme.of(context).grayLight,
                highlightColor: MyTheme.of(context).grayDark,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(right: 10),
                  width: getProportionateScreenWidth(context, 120),
                  height: getProportionateScreenHeight(context, 100),
                  child: Container(),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: getProportionateScreenHeight(context, 20),
                    child: Shimmer.fromColors(
                        baseColor: MyTheme.of(context).grayLight,
                        highlightColor: MyTheme.of(context).grayDark,
                        child: Container(
                          color: Colors.white,
                        )),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(context, 10),
                  ),
                  Container(
                    width: double.infinity,
                    height: getProportionateScreenHeight(context, 25),
                    child: Shimmer.fromColors(
                        baseColor: MyTheme.of(context).grayLight,
                        highlightColor: MyTheme.of(context).grayDark,
                        child: Container(
                          color: Colors.white,
                        )),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(context, 10),
                  ),
                  Container(
                    width: double.infinity,
                    height: getProportionateScreenHeight(context, 70),
                    child: Shimmer.fromColors(
                        baseColor: MyTheme.of(context).grayLight,
                        highlightColor: MyTheme.of(context).grayDark,
                        child: Container(
                          color: Colors.white,
                        )),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(context, 10),
                  ),
                  Container(
                    width: double.infinity,
                    height: getProportionateScreenHeight(context, 10),
                    child: Shimmer.fromColors(
                        baseColor: MyTheme.of(context).grayLight,
                        highlightColor: MyTheme.of(context).grayDark,
                        child: Container(
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ShimmerProductMediumItem extends StatelessWidget {
  ShimmerProductMediumItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyTheme.of(context).secondaryBackground,
      width: MediaQuery.sizeOf(context).width,
      height: getProportionateScreenHeight(context, 170),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Shimmer.fromColors(
                baseColor: MyTheme.of(context).grayLight,
                highlightColor: MyTheme.of(context).grayDark,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(right: 10),
                  width: getProportionateScreenWidth(context, 120),
                  height: getProportionateScreenHeight(context, 100),
                  child: Container(),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: getProportionateScreenHeight(context, 15),
                    child: Shimmer.fromColors(
                        baseColor: MyTheme.of(context).grayLight,
                        highlightColor: MyTheme.of(context).grayDark,
                        child: Container(
                          color: Colors.white,
                        )),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(context, 10),
                  ),
                  Container(
                    width: double.infinity,
                    height: getProportionateScreenHeight(context, 20),
                    child: Shimmer.fromColors(
                        baseColor: MyTheme.of(context).grayLight,
                        highlightColor: MyTheme.of(context).grayDark,
                        child: Container(
                          color: Colors.white,
                        )),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(context, 10),
                  ),
                  Container(
                    width: double.infinity,
                    height: getProportionateScreenHeight(context, 70),
                    child: Shimmer.fromColors(
                        baseColor: MyTheme.of(context).grayLight,
                        highlightColor: MyTheme.of(context).grayDark,
                        child: Container(
                          color: Colors.white,
                        )),
                  ),
                  SizedBox(
                    height: getProportionateScreenHeight(context, 10),
                  ),
                  Container(
                    width: double.infinity,
                    height: getProportionateScreenHeight(context, 10),
                    child: Shimmer.fromColors(
                        baseColor: MyTheme.of(context).grayLight,
                        highlightColor: MyTheme.of(context).grayDark,
                        child: Container(
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
