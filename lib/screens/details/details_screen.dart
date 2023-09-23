import 'package:another_flushbar/flushbar.dart';
import 'package:blueraymarket/backend/backend.dart';
import 'package:blueraymarket/backend/cache/hive_box.dart';
import 'package:blueraymarket/backend/schema/product/product_record.dart';
import 'package:blueraymarket/backend/schema/size/size_record.dart';
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
import '../../components/rounded_icon_btn.dart';
import '../../tools/constants.dart';
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
  Color? selectedColor;
  DocumentReference? colorId;
  String? selectedSize;
  int quantity = 0;
  int? currentQuantity = 0;

  final PageController _pageController =
      PageController(viewportFraction: 0.8, initialPage: 1);

  List<SizeRecord?>? sizes;
  late List<ProductRecord?> products;
  VariantRecord? variantRecord;
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
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
                final colors = getColorsFromVariants(variants);

                if (variantRecord == null) variantRecord = variants.firstOrNull;

                if (sizes == null) {
                  sizes = getSizesFromVariants(variants
                      .where(
                        (element) => element!.idColor == variantRecord!.idColor,
                      )
                      .toList());
                }
                return Expanded(
                  child: Stack(children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                getProportionateScreenWidth(context, 10)),
                        child: Column(
                          children: [
                            ProductImages(
                              images: variantRecord == null
                                  ? []
                                  : variantRecord!.images!.toList(),
                              // ignore: unnecessary_null_comparison
                              image: variantRecord != null &&
                                      variantRecord!.images!.first != null
                                  ? variantRecord!.images!.first
                                  : product!.image!,
                            ), // pass product
                            Container(
                              width: MediaQuery.sizeOf(context).width,
                              //height: MediaQuery.sizeOf(context).height,
                              child: ProductDescription(
                                product: product,
                              ),
                            ),
                            if (colors!.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Divider(
                                    height: 1,
                                    color: MyTheme.of(context).grayDark,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      'COLOR',
                                      style: MyTheme.of(context)
                                          .labelMedium
                                          .copyWith(
                                              fontFamily: 'Outfit',
                                              color:
                                                  MyTheme.of(context).grayDark),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      ...List.generate(
                                          colors.length,
                                          (index) => InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    variantRecord = variants
                                                        .where((v) =>
                                                            v!.idColor ==
                                                            colors[index]!
                                                                .reference)
                                                        .first;
                                                  });
                                                  sizes = getSizesFromVariants(
                                                      variants
                                                          .where(
                                                            (element) =>
                                                                element!
                                                                    .idColor ==
                                                                variantRecord!
                                                                    .idColor,
                                                          )
                                                          .toList());
                                                },
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(right: 7),
                                                  height:
                                                      getProportionateScreenWidth(
                                                          context, 33),
                                                  width:
                                                      getProportionateScreenWidth(
                                                          context, 33),
                                                  decoration: BoxDecoration(
                                                      color: colors[index]!
                                                          .colorCode!,
                                                      shape: BoxShape.rectangle,
                                                      border: Border.all(
                                                          width: 2,
                                                          color: variantRecord!
                                                                      .idColor ==
                                                                  colors[index]!
                                                                      .reference
                                                              ? MyTheme.of(
                                                                      context)
                                                                  .grayLight
                                                              : Colors
                                                                  .transparent),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8))),
                                                ),
                                              )).reversed,
                                      SizedBox(
                                        height: getProportionateScreenHeight(
                                            context, 20),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            if (sizes != null && sizes!.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: getProportionateScreenHeight(
                                        context, 10),
                                  ),
                                  Divider(
                                    height: 1,
                                    color: MyTheme.of(context).grayDark,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      'SIZE',
                                      style: MyTheme.of(context)
                                          .labelMedium
                                          .copyWith(
                                              fontFamily: 'Outfit',
                                              color:
                                                  MyTheme.of(context).grayDark),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      ...List.generate(
                                          sizes!.length,
                                          (index) => Container(
                                                margin:
                                                    EdgeInsets.only(right: 7),
                                                padding: EdgeInsets.all(
                                                    getProportionateScreenWidth(
                                                        context, 10)),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    border: Border.all(
                                                        width: 2,
                                                        color:
                                                            MyTheme.of(context)
                                                                .grayLight),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                8))),
                                                child: Center(
                                                  child: Text(sizes![index]!
                                                      .sizeCode!
                                                      .toUpperCase()),
                                                ),
                                              )).reversed,
                                      SizedBox(
                                        height: getProportionateScreenHeight(
                                            context, 20),
                                      ),
                                    ],
                                  )
                                ],
                              ),
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
                                    horizontal: getProportionateScreenWidth(
                                        context, 15)),
                                width: MediaQuery.sizeOf(context).width,
                                height:
                                    getProportionateScreenHeight(context, 220),
                                child: PageView.builder(
                                    controller: _pageController,
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
                                                  products[index]!
                                                      .idSubCategory,
                                                  ParamType.DocumentReference,
                                                )
                                              });
                                        },
                                        child: Container(
                                          color: MyTheme.of(context).accent4,
                                          width: getProportionateScreenWidth(
                                              context, 180),
                                          margin: EdgeInsets.only(right: 10),
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: SizedBox(
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
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                      imageUrl: products[index]!
                                                          .image!,
                                                    ),
                                                  ),
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
                                                          products[index]!
                                                              .title!
                                                              .truncateText(20),
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
                                AppState().cart.containsKey(product!.ffRef) &&
                                        (colors.isEmpty && sizes!.isEmpty)
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
                                                        product.ffRef!,
                                                        variantRecord!
                                                            .reference);
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
                                                    '${AppState().cart[product.reference] != null ? AppState().cart[product.reference]![variantRecord!.reference] : '0'}',
                                                    style: MyTheme.of(context)
                                                        .bodyLarge
                                                        .copyWith(
                                                            fontFamily:
                                                                'OutFit',
                                                            color: MyTheme.of(
                                                                    context)
                                                                .primaryText),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      if (AppState().cart[product
                                                                  .reference]![
                                                              variantRecord!
                                                                  .reference]! <
                                                          quantity)
                                                        AppState()
                                                            .increaseQuantity(
                                                                product.ffRef!,
                                                                variantRecord!
                                                                    .reference!);
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
                                            press: () async {
                                              if (colors.isEmpty &&
                                                  sizes!.isEmpty) {
                                                if (variantRecord != null) {
                                                  quantity =
                                                      variantRecord!.quantity ??
                                                          0;
                                                  setState(() {
                                                    AppState().addToCart(
                                                        product!.ffRef!,
                                                        variantRecord!
                                                            .reference,
                                                        1);
                                                  });
                                                } else {
                                                  Flushbar(
                                                    backgroundColor:
                                                        MyTheme.of(context)
                                                            .warning,
                                                    message:
                                                        "We're sorry, but this item is currently out of stock.",
                                                    icon: Icon(
                                                      Icons
                                                          .production_quantity_limits,
                                                      size: 28.0,
                                                      color: Colors.white,
                                                    ),
                                                    duration:
                                                        Duration(seconds: 3),
                                                    leftBarIndicatorColor:
                                                        MyTheme.of(context)
                                                            .accent4,
                                                  )..show(context);
                                                }
                                              } else {
                                                setState(() {
                                                  AppState().addToCart(
                                                      product!.ffRef!,
                                                      variantRecord!.reference,
                                                      1);
                                                });
                                                selectedColor =
                                                    variantRecord!.colorCode;
                                                selectedSize =
                                                    variantRecord!.sizeCode;
                                                colorId =
                                                    variantRecord!.idColor;
                                                String? textColor = '';
                                                textColor = AppState()
                                                    .colors
                                                    .where(
                                                      (element) =>
                                                          element!.colorCode ==
                                                          selectedColor,
                                                    )
                                                    .first!
                                                    .colorName;
                                                sizes = getSizesFromVariants(
                                                    variants
                                                        .where(
                                                          (element) =>
                                                              element!
                                                                  .idColor ==
                                                              variantRecord!
                                                                  .idColor,
                                                        )
                                                        .toList());
                                                if ((colors.isNotEmpty &&
                                                        sizes!.isEmpty) ||
                                                    (colors.isEmpty &&
                                                        sizes!.isNotEmpty)) {
                                                  quantity =
                                                      variantRecord!.quantity!;
                                                } else if (colors.isNotEmpty &&
                                                    sizes!.isNotEmpty) {
                                                  quantity = variants
                                                      .where((element) =>
                                                          element!.colorCode ==
                                                              selectedColor &&
                                                          element.sizeCode ==
                                                              selectedSize)
                                                      .first!
                                                      .quantity!;
                                                }

                                                await showModalBottomSheet(
                                                        context: context,
                                                        builder: (context) {
                                                          return StatefulBuilder(
                                                              builder: (context,
                                                                  setState) {
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          15),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: <Widget>[
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        vertical:
                                                                            15,
                                                                        horizontal:
                                                                            25),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                          'Choose an option',
                                                                          style:
                                                                              MyTheme.of(context).labelLarge,
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            context.pop();
                                                                          },
                                                                          child:
                                                                              Icon(Icons.close),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  if (colors!
                                                                      .isNotEmpty)
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              25),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                EdgeInsets.symmetric(vertical: 5),
                                                                            child:
                                                                                Text(
                                                                              'Color : ${textColor?.capitalize()}',
                                                                              style: MyTheme.of(context).labelMedium,
                                                                            ),
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              ...List.generate(
                                                                                  colors.length,
                                                                                  (index) => InkWell(
                                                                                        onTap: () {
                                                                                          setState(() {
                                                                                            AppState().cart[product.reference]![variantRecord!.reference] = 1;

                                                                                            selectedColor = colors[index]!.colorCode;
                                                                                            textColor = colors[index]!.colorName;
                                                                                            sizes = getSizesFromVariants(variants
                                                                                                .where(
                                                                                                  (element) => element!.colorCode == selectedColor,
                                                                                                )
                                                                                                .toList());
                                                                                            colorId = colors[index]!.reference;
                                                                                            selectedSize = sizes!.last!.sizeCode!;

                                                                                            quantity = variants.where((element) => element!.colorCode == selectedColor && element.sizeCode == selectedSize).first!.quantity!;
                                                                                          });
                                                                                        },
                                                                                        child: Container(
                                                                                          margin: EdgeInsets.only(right: 7),
                                                                                          height: getProportionateScreenWidth(context, 33),
                                                                                          width: getProportionateScreenWidth(context, 33),
                                                                                          decoration: BoxDecoration(color: colors[index]!.colorCode!, shape: BoxShape.rectangle, border: Border.all(width: 2, color: selectedColor! == colors[index]!.colorCode ? MyTheme.of(context).grayLight : Colors.transparent), borderRadius: BorderRadius.all(Radius.circular(8))),
                                                                                        ),
                                                                                      )).reversed,
                                                                              SizedBox(
                                                                                height: getProportionateScreenHeight(context, 20),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  if (sizes !=
                                                                          null &&
                                                                      sizes!
                                                                          .isNotEmpty)
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              25),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          SizedBox(
                                                                            height:
                                                                                getProportionateScreenHeight(context, 10),
                                                                          ),
                                                                          Divider(
                                                                            height:
                                                                                1,
                                                                            color:
                                                                                MyTheme.of(context).grayDark,
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                EdgeInsets.symmetric(vertical: 5),
                                                                            child:
                                                                                Text(
                                                                              'SIZE',
                                                                              style: MyTheme.of(context).labelMedium.copyWith(fontFamily: 'Outfit', color: MyTheme.of(context).grayDark),
                                                                            ),
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              ...List.generate(
                                                                                  sizes!.length,
                                                                                  (index) => InkWell(
                                                                                        onTap: () {
                                                                                          setState(() {
                                                                                            selectedSize = sizes![index]!.sizeCode;
                                                                                            quantity = variants.where((element) => element!.colorCode == selectedColor && element.sizeCode == selectedSize).first!.quantity!;
                                                                                            AppState().cart[product.reference]![variantRecord!.reference] = 1;
                                                                                          });
                                                                                        },
                                                                                        child: Container(
                                                                                          margin: EdgeInsets.only(right: 7),
                                                                                          padding: EdgeInsets.all(getProportionateScreenWidth(context, 10)),
                                                                                          decoration: BoxDecoration(shape: BoxShape.rectangle, color: selectedSize == sizes![index]!.sizeCode ? MyTheme.of(context).grayDark.withAlpha(60) : Colors.transparent, border: Border.all(width: 1, color: MyTheme.of(context).grayDark), borderRadius: BorderRadius.all(Radius.circular(8))),
                                                                                          child: Center(
                                                                                            child: Text(sizes![index]!.sizeCode!.toUpperCase()),
                                                                                          ),
                                                                                        ),
                                                                                      )).reversed,
                                                                              SizedBox(
                                                                                height: getProportionateScreenHeight(context, 20),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            25),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Text(" $quantity items only", style: MyTheme.of(context).labelMedium.copyWith(fontFamily: 'Open Sans', color: MyTheme.of(context).error))
                                                                                ],
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  InkWell(
                                                                                    onTap: () {
                                                                                      setState(() {
                                                                                        AppState().decreaseQuantity(product.ffRef!, variantRecord!.reference!);
                                                                                        if (AppState().cart[product.reference] == null) context.pop();
                                                                                      });
                                                                                    },
                                                                                    child: Container(
                                                                                      width: getProportionateScreenWidth(context, 25),
                                                                                      height: getProportionateScreenHeight(context, 25),
                                                                                      decoration: BoxDecoration(color: MyTheme.of(context).primary, border: Border.all(color: MyTheme.of(context).primary), borderRadius: BorderRadius.all(Radius.circular(5))),
                                                                                      child: Center(
                                                                                        child: Icon(
                                                                                          Icons.remove,
                                                                                          color: MyTheme.of(context).alternate,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    width: getProportionateScreenWidth(context, 25),
                                                                                    height: getProportionateScreenHeight(context, 25),
                                                                                    child: Center(
                                                                                      child: Text(
                                                                                        '${AppState().cart[product.reference] != null ? AppState().cart[product.reference]![variantRecord!.reference] : '0'}',
                                                                                        style: MyTheme.of(context).bodyLarge.copyWith(fontFamily: 'OutFit', color: MyTheme.of(context).primaryText),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  InkWell(
                                                                                      onTap: () {
                                                                                        setState(() {
                                                                                          if (AppState().cart[product.reference]![variantRecord!.reference]! < quantity) AppState().increaseQuantity(product.ffRef!, variantRecord!.reference!);
                                                                                        });
                                                                                      },
                                                                                      child: Container(
                                                                                        width: getProportionateScreenWidth(context, 25),
                                                                                        height: getProportionateScreenHeight(context, 25),
                                                                                        decoration: BoxDecoration(color: MyTheme.of(context).primary, border: Border.all(color: MyTheme.of(context).primary), borderRadius: BorderRadius.all(Radius.circular(5))),
                                                                                        child: Center(
                                                                                          child: Icon(
                                                                                            Icons.add,
                                                                                            color: MyTheme.of(context).alternate,
                                                                                          ),
                                                                                        ),
                                                                                      )),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Divider(
                                                                    color: MyTheme.of(
                                                                            context)
                                                                        .grayDark,
                                                                    height: 2,
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            10),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              MediaQuery.sizeOf(context).width,
                                                                          height: getProportionateScreenHeight(
                                                                              context,
                                                                              50),
                                                                          child:
                                                                              DefaultButton(
                                                                            bgColor:
                                                                                MyTheme.of(context).primary,
                                                                            textColor:
                                                                                MyTheme.of(context).alternate,
                                                                            text:
                                                                                'Proceed to purchase',
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              MediaQuery.sizeOf(context).width,
                                                                          height: getProportionateScreenHeight(
                                                                              context,
                                                                              50),
                                                                          child:
                                                                              DefaultButton(
                                                                            bgColor:
                                                                                MyTheme.of(context).alternate,
                                                                            textColor:
                                                                                MyTheme.of(context).primary,
                                                                            text:
                                                                                'Continue your purchase',
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          });
                                                        })
                                                    .then((value) =>
                                                        setState(() {}));
                                              }
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
