import 'package:blueraymarket/backend/backend.dart';
import 'package:blueraymarket/backend/cache/hive_box.dart';
import 'package:blueraymarket/backend/schema/product/product_record.dart';
import 'package:blueraymarket/backend/schema/variant/variant_record.dart';
import 'package:blueraymarket/tools/app_state.dart';
import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:blueraymarket/tools/util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import '../../components/default_button.dart';
import '../../tools/nav/serializer.dart';
import '../../tools/size_config.dart';
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

  late List<ProductRecord?> products;
  @override
  void initState() {
    super.initState();

    products = AppState()
        .products
        .where((element) =>
            element!.idSubCategory == widget.idSubCategory &&
            element.reference != widget.idproduct)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AppState>();

    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          CustomAppBar(title: 'Details'),
          FutureBuilder<List>(
              future: Future.wait([
                ProductRecord.getDocumentOnce(widget.idproduct!),
                queryVariantsRecordOnce(parent: widget.idproduct)
              ]),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return loadingIndicator(context);
                }

                final ProductRecord? product = snapshot.data![0];
                final List<VariantRecord?> variants = snapshot.data![1];
                return Expanded(
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
                                  getProportionateScreenHeight(context, 220),
                              child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (_, index) => SizedBox(
                                        width: 20,
                                      ),
                                  itemCount: products.length,
                                  itemBuilder: (_, index) {
                                    return Container(
                                        child: InkWell(
                                      onTap: () {
                                        context.pushNamed(
                                            'ProductDetailsScreen',
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
                                                    placeholder: (context,
                                                            url) =>
                                                        Image.asset(
                                                            'assets/images/blue_ray_image.jpg'),
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
                                                    child: Center(
                                                      child: Text(
                                                        products[index]!.title!,
                                                        style: MyTheme.of(
                                                                context)
                                                            .bodyLarge
                                                            .copyWith(
                                                                fontFamily:
                                                                    'Open Sans',
                                                                fontSize: 18),
                                                      ),
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
                        bottom: 0,
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            width: MediaQuery.sizeOf(context).width,
                            height: 70,
                            color: MyTheme.of(context).alternate,
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  MyTheme.of(context).primary),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Icon(
                                        Icons.home_rounded,
                                        color: MyTheme.of(context).primary,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  MyTheme.of(context).primary),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Icon(
                                        Icons.phone,
                                        color: MyTheme.of(context).primary,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                AppState().cart.containsKey(product.ffRef)
                                    ? Expanded(
                                        child: Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    AppState().decreaseQuantity(
                                                        product.ffRef!);
                                                    print(AppState()
                                                        .cart
                                                        .values
                                                        .length);
                                                  });
                                                },
                                                child: Container(
                                                  width:
                                                      getProportionateScreenWidth(
                                                          context, 50),
                                                  height:
                                                      getProportionateScreenHeight(
                                                          context, 50),
                                                  decoration: BoxDecoration(
                                                      color: MyTheme.of(context)
                                                          .primary,
                                                      border: Border.all(
                                                          color: MyTheme.of(
                                                                  context)
                                                              .primary),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5))),
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.remove,
                                                      color: MyTheme.of(context)
                                                          .alternate,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width:
                                                    getProportionateScreenWidth(
                                                        context, 50),
                                                height:
                                                    getProportionateScreenHeight(
                                                        context, 50),
                                                child: Center(
                                                  child: Text(
                                                    '${AppState().cart[product.reference]}',
                                                    style: MyTheme.of(context)
                                                        .bodyLarge
                                                        .copyWith(
                                                            fontFamily:
                                                                'OutFit',
                                                            color: MyTheme.of(
                                                                    context)
                                                                .secondaryReverse),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      AppState()
                                                          .increaseQuantity(
                                                              product.ffRef!);
                                                      print(AppState()
                                                          .cart
                                                          .values
                                                          .length);
                                                    });
                                                  },
                                                  child: Container(
                                                    width:
                                                        getProportionateScreenWidth(
                                                            context, 50),
                                                    height:
                                                        getProportionateScreenHeight(
                                                            context, 50),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            MyTheme.of(context)
                                                                .primary,
                                                        border: Border.all(
                                                            color: MyTheme.of(
                                                                    context)
                                                                .primary),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5))),
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.add,
                                                        color:
                                                            MyTheme.of(context)
                                                                .alternate,
                                                      ),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Expanded(
                                        child: Container(
                                          width: getProportionateScreenWidth(
                                              context, 200),
                                          height: getProportionateScreenHeight(
                                              context, 50),
                                          child: DefaultButton(
                                            text: "Add To Cart",
                                            press: () {
                                              setState(() {
                                                AppState().addToCart(
                                                    product!.ffRef!, 1);
                                                print(AppState()
                                                    .cart
                                                    .values
                                                    .length);
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                              ],
                            )))
                  ]),
                );
              }),
        ],
      ),
    ));
  }
}
