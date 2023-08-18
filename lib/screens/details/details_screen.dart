import 'package:blueraymarket/backend/cache/hive_box.dart';
import 'package:blueraymarket/backend/schema/product/product_record.dart';
import 'package:blueraymarket/backend/schema/variant/variant_record.dart';
import 'package:blueraymarket/tools/app_state.dart';
import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:blueraymarket/tools/util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/default_button.dart';
import '../../tools/size_config.dart';
import 'components/body.dart';
import 'components/color_dots.dart';
import 'components/custom_app_bar.dart';
import 'components/product_description.dart';
import 'components/product_images.dart';
import 'components/top_rounded_container.dart';

class ProductDetailsScreen extends StatefulWidget {
  ProductDetailsScreen({required this.idproduct, required this.idSubCategory});

  final DocumentReference? idproduct;
  final DocumentReference? idSubCategory;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late ProductRecord? product;
  bool isLoading = false;
  late List<VariantRecord?> variants;
  late List<ProductRecord?> products;
  @override
  void initState() {
    super.initState();
    variants = AppState()
        .variants
        .where((e) => e!.reference.parent.parent == widget.idproduct)
        .toList();

    products = AppState()
        .products
        .where((element) =>
            element!.idSubCategory == widget.idSubCategory &&
            element.reference != widget.idproduct)
        .toList();
    getProduct();
  }

  Future<void> getProduct() async {
    setState(() {
      isLoading = true;
    });
    final products = await ProductHive().getDataFromCache();
    setState(() {
      product =
          products.where((element) => element!.ffRef == widget.idproduct).first;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AppState>();

    return Scaffold(
        body: SafeArea(
      child: isLoading
          ? loadingIndicator(context)
          : Column(
              children: [
                CustomAppBar(title: product!.title!.toUpperCase()),
                Expanded(
                  child: Stack(children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          ProductImages(
                            image: product!.image!,
                            tag: product!.reference,
                            images: variants.isEmpty
                                ? []
                                : variants.firstOrNull!.images!.toList(),
                          ), // pass product
                          Container(
                            width: MediaQuery.sizeOf(context).width,
                            //height: MediaQuery.sizeOf(context).height,
                            child: ProductDescription(
                              product: product,
                            ),
                          ),

                          ColorDots(),
                          SizedBox(
                            height: getProportionateScreenHeight(context, 20),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'You May Like',
                                style: MyTheme.of(context).headlineSmall,
                              )
                            ],
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(context, 20),
                          ),

                          if (products.isNotEmpty)
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      getProportionateScreenWidth(context, 15)),
                              width: MediaQuery.sizeOf(context).width,
                              height:
                                  getProportionateScreenHeight(context, 200),
                              child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (_, index) => SizedBox(
                                        width: 20,
                                      ),
                                  itemCount: products.length,
                                  itemBuilder: (_, index) {
                                    return Container(
                                        child: Container(
                                      color: MyTheme.of(context).accent4,
                                      width: getProportionateScreenWidth(
                                          context, 180),
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              width:
                                                  getProportionateScreenWidth(
                                                      context, 100),
                                              height:
                                                  getProportionateScreenWidth(
                                                      context, 100),
                                              child: CachedNetworkImage(
                                                  placeholder: (context, url) =>
                                                      Image.asset(
                                                          'assets/images/blue_ray_image.jpg'), // Placeholder widget
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                  imageUrl:
                                                      products[index]!.image!,
                                                  fit: BoxFit.cover),
                                            ),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      context, 10),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    products[index]!.title!,
                                                    style: MyTheme.of(context)
                                                        .bodyLarge
                                                        .copyWith(
                                                            fontFamily:
                                                                'Open Sans',
                                                            fontSize: 18),
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      context, 10),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              height: 30,
                                              child: Center(
                                                child: Text(
                                                  'US\$ ${product!.price.toString()}',
                                                  style: MyTheme.of(context)
                                                      .titleMedium
                                                      .copyWith(
                                                          fontFamily:
                                                              'Open Sans',
                                                          color: MyTheme.of(
                                                                  context)
                                                              .primary),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ));
                                  }),
                            ),
                          SizedBox(
                            height: 100,
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: MediaQuery.sizeOf(context).width / 2 - 100,
                      child: Container(
                        width: getProportionateScreenWidth(context, 200),
                        height: getProportionateScreenHeight(context, 50),
                        child: DefaultButton(
                          text: "Add To Cart",
                          press: () {},
                        ),
                      ),
                    )
                  ]),
                ),
              ],
            ),
    ));
  }
}
