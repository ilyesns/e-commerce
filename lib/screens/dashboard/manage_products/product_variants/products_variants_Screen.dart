import 'dart:async';

import 'package:blueraymarket/backend/backend.dart';
import 'package:blueraymarket/backend/schema/product/product_record.dart';
import 'package:blueraymarket/components/default_button.dart';
import 'package:blueraymarket/components/product_manage/product_manage.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../../../backend/firebase_storage/storage.dart';
import '../../../../backend/schema/brand/brand_record.dart';
import '../../../../backend/schema/sub_category/sub_category_record.dart';
import '../../../../components/form_error.dart';

import '../../../../components/products_variants_manage/products_variants_manage.dart';
import '../../../../helper/keyboard.dart';
import '../../../../tools/nav/theme.dart';
import '../../../../tools/upload_data.dart';
import '../../../../tools/upload_file.dart';
import '../../../../tools/util.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../home/components/search_field.dart';

class ProductsVariantsScreen extends StatefulWidget {
  const ProductsVariantsScreen({super.key});

  @override
  State<ProductsVariantsScreen> createState() => _ProductsVariantsScreenState();
}

class _ProductsVariantsScreenState extends State<ProductsVariantsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: MyTheme.of(context).primary,
        title: Text("Products / Variants Page"),
      ),
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();

  FocusNode _focusNode = FocusNode();
  final FocusNode focusNodeDiscountSearch = FocusNode();

  SizeConfig sizeConfig = SizeConfig();

  late Stream<List<ProductRecord>> stream;

  String search = '';

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    stream = queryProductsRecord();
  }

  @override
  void dispose() {
    super.dispose();

    _focusNode.dispose();

    focusNodeDiscountSearch.dispose();
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final BuildContext _context = context;
    sizeConfig.init(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_focusNode),
      child: Container(
        width: sizeConfig.screenWidth,
        height: sizeConfig.screenHeight,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              vertical: getProportionateScreenHeight(context, 20),
              horizontal: getProportionateScreenWidth(context, 20)),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Product\'s list',
                      style: MyTheme.of(context).titleMedium,
                    ),
                    Container(
                        width: getProportionateScreenWidth(context, 200),
                        height: 50,
                        child: SearchField(
                          onChanged: (value) {
                            search = value;
                          },
                          hintText: "Search product",
                        )),
                  ],
                ),
              ),
              ListItemsComponent(context, _context),
            ],
          ),
        ),
      ),
    );
  }

  Padding ListItemsComponent(BuildContext context, BuildContext _context) {
    return Padding(
      padding: EdgeInsets.only(top: getProportionateScreenHeight(context, 20)),
      child: StreamBuilder<List<ProductRecord>>(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return loadingIndicator(context);
            }
            if (snapshot.data!.isEmpty) {
              return listEmpty("Products", context);
            }
            final products = snapshot.data;
            final productAfterSearch = products!
                .where((e) =>
                    e.title!.toLowerCase().contains(search.toLowerCase()))
                .toList();

            if (productAfterSearch.isEmpty) {
              return searchNotAvailable("Products", context);
            }

            return ListView.builder(
                padding: EdgeInsets.only(
                    top: getProportionateScreenHeight(context, 20)),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: productAfterSearch.length,
                itemBuilder: (context, index) {
                  final productItem = productAfterSearch[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: getProportionateScreenHeight(context, 10)),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: MyTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  child: CachedNetworkImage(
                                    imageUrl: productItem.image!,
                                    // Placeholder widget while loading
                                    placeholder: (context, url) => Image.asset(
                                        'assets/images/blue_ray_image.jpg'), // Placeholder widget

                                    errorWidget: (context, url, error) => Icon(
                                      Icons.error,
                                      color: Colors.black,
                                    ), // Widget to display on error
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Title: ${productItem.title?.truncateText(20) as String}',
                                      style: MyTheme.of(context)
                                          .labelLarge
                                          .override(
                                              fontSize: 15,
                                              fontFamily: 'Roboto'),
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(
                                          context, 3),
                                    ),
                                    Text(
                                      'Description: ${productItem.description!.truncateText(15)}',
                                      style: MyTheme.of(context)
                                          .labelLarge
                                          .override(
                                              fontSize: 15,
                                              fontFamily: 'Roboto'),
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(
                                          context, 3),
                                    ),
                                    Text(
                                      'Price: ${productItem.price}',
                                      style: MyTheme.of(context)
                                          .labelLarge
                                          .override(
                                              fontSize: 15,
                                              fontFamily: 'Roboto'),
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(
                                          context, 3),
                                    ),
                                    Text(
                                      'Create at :${dateTimeFormat('M/d H:mm', productItem.createdAt)}',
                                      style: MyTheme.of(context)
                                          .labelLarge
                                          .override(
                                              fontSize: 14,
                                              fontFamily: 'Roboto'),
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(
                                          context, 3),
                                    ),
                                    Text(
                                      'Modify at :${dateTimeFormat('M/d H:mm', productItem.modifiedAt)}',
                                      style: MyTheme.of(context)
                                          .labelLarge
                                          .override(
                                              fontSize: 14,
                                              fontFamily: 'Roboto'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () async {
                                await showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  enableDrag: true,
                                  context: context,
                                  builder: (bottomSheetContext) {
                                    return Padding(
                                      padding: MediaQuery.of(bottomSheetContext)
                                          .viewInsets,
                                      child: ProductsVariantsManage(
                                          productId: productItem.reference,
                                          discountId: productItem.idDiscount!,
                                          context: context),
                                    );
                                  },
                                ).then((value) => setState(() {}));
                              },
                              child: Container(
                                width: 20,
                                height: 20,
                                child: SvgPicture.asset(
                                  'assets/icons/edit.svg',
                                  color: MyTheme.of(context).primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
