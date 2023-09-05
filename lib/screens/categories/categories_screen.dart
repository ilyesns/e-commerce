import 'dart:ffi';

import 'package:blueraymarket/backend/schema/serializers.dart';
import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';

import '../../backend/cache/hive_box.dart';
import '../../backend/schema/category/category_record.dart';
import '../../backend/schema/product/product_record.dart';
import '../../backend/schema/sub_category/sub_category_record.dart';
import '../../tools/animations.dart';
import '../../tools/nav/routes.dart';
import '../../tools/nav/serializer.dart';
import '../../tools/util.dart';
import '../home/components/home_header.dart';
import 'components/header.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _dragStartX = 0;
  double _dragEndX = 0;
  final CategoryHive categoryHive = CategoryHive();
  final SubCategoryHive subCategoryHive = SubCategoryHive();

  late Future<List> queries;
  String title = "Categories and Subcategories";
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    // Create an animation with a Tween
    _animation = Tween<double>(begin: SizeConfig().screenWidth, end: 50)
        .animate(_controller);

    queries = Future.wait([
      categoryHive.getDataFromCache(
          queryBuilder: (q) => q.orderBy('category_name', descending: false)),
      subCategoryHive.getDataFromCache(
          queryBuilder: (q) =>
              q.orderBy('sub_category_name', descending: false)),
    ]);
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleMenu() {
    setState(() {
      _controller.forward();
    });
  }

  DocumentReference? catRef;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            _controller.reverse();

            return false;
          },
          child: Column(
            children: [
              CategoryHeader(title: title),
              Expanded(
                child: RefreshIndicator(
                  color: MyTheme.of(context).primary,
                  onRefresh: () async {
                    setState(() {
                      clearCategoriesBox();
                      queries = Future.wait([
                        categoryHive.getDataFromCache(
                            queryBuilder: (q) =>
                                q.orderBy('category_name', descending: false)),
                        subCategoryHive.getDataFromCache(
                            queryBuilder: (q) => q.orderBy('sub_category_name',
                                descending: false)),
                      ]);
                    });
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        FutureBuilder<List>(
                            future: queries,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return loadingIndicator(context);
                              }
                              if (!snapshot.hasData && snapshot.data == null) {
                                return listEmpty("Home Page", context);
                              }

                              final categories =
                                  snapshot.data![0] as List<CategoryRecord?>;

                              final subCategories = snapshot.data![1]!
                                  as List<SubCategoryRecord?>;
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: Stack(
                                  children: [
                                    ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: categories.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final category = categories[index];
                                        return CategoryMenu(
                                          text: category!.categoryName!,
                                          icon: category.image,
                                          press: () {
                                            setState(() {
                                              title = category.categoryName!;
                                              catRef = category.reference;
                                              _controller.forward();
                                            });
                                          },
                                          title: title,
                                        );
                                      },
                                    ),
                                    AnimatedBuilder(
                                      animation: _controller,
                                      builder: (context, child) {
                                        return Positioned(
                                          top: 0,
                                          left: _animation.value,
                                          child: GestureDetector(
                                            onHorizontalDragStart: (details) {
                                              _dragStartX =
                                                  details.globalPosition.dx;
                                            },
                                            onHorizontalDragUpdate: (details) {
                                              _dragEndX =
                                                  details.globalPosition.dx;

                                              setState(() {
                                                _dragStartX = _dragEndX;
                                              });
                                            },
                                            onHorizontalDragEnd: (_) {
                                              if (_animation.value <= -25) {
                                                setState(() {
                                                  // Open the menu
                                                  _controller.forward();
                                                });
                                              } else {
                                                // Close the menu
                                                setState(() {
                                                  title =
                                                      "Categories and Subcategories";
                                                  _controller.reverse();
                                                });
                                              }
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  50,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              color:
                                                  MyTheme.of(context).grayDark,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: subCategories
                                                    .where((p) =>
                                                        p!.ffRef!.parent
                                                            .parent ==
                                                        catRef)
                                                    .toList()
                                                    .length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  final subItem = subCategories
                                                      .where((p) =>
                                                          p!.ffRef!.parent
                                                              .parent ==
                                                          catRef)
                                                      .toList()[index];
                                                  return SubCategoryMenu(
                                                    text: subItem!
                                                        .subCategoryName!,
                                                    press: () {
                                                      setState(() {
                                                        title =
                                                            "Categories and Subcategories";
                                                        _controller.reverse();
                                                      });
                                                      context.pushNamed(
                                                        'ListProductsPage',
                                                        queryParameters: {
                                                          'idSubCategory':
                                                              serializeParam(
                                                            subItem.reference,
                                                            ParamType
                                                                .DocumentReference,
                                                          ),
                                                          'subCategoryName':
                                                              serializeParam(
                                                            subItem
                                                                .subCategoryName,
                                                            ParamType.String,
                                                          ),
                                                        }.withoutNulls,
                                                        extra: <String,
                                                            dynamic>{
                                                          kTransitionInfoKey:
                                                              TransitionInfo(
                                                            hasTransition: true,
                                                            transitionType:
                                                                PageTransitionType
                                                                    .rightToLeftWithFade,
                                                            duration: Duration(
                                                                milliseconds:
                                                                    kTransitionDuration),
                                                          ),
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryMenu extends StatelessWidget {
  CategoryMenu(
      {Key? key,
      required this.text,
      this.icon,
      this.press,
      this.secondIcon,
      this.title})
      : super(key: key);

  final String text;
  final String? icon;
  final VoidCallback? press;
  final IconData? secondIcon;
  late String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: title == text ? MyTheme.of(context).grayDark : null,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: InkWell(
          onTap: press,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  secondIcon == null
                      ? SvgPicture.network(
                          icon!,
                          color: MyTheme.of(context).primary,
                          width: 30,
                        )
                      : Icon(
                          secondIcon!,
                          color: MyTheme.of(context).primary,
                        ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          text.toUpperCase(),
                          style: MyTheme.of(context).labelLarge,
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(context, 10),
                        ),
                        Divider(
                          height: 1,
                          color: MyTheme.of(context).primaryText,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SubCategoryMenu extends StatelessWidget {
  SubCategoryMenu({
    Key? key,
    required this.text,
    this.press,
  }) : super(key: key);

  final String text;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: MyTheme.of(context).alternate,
          padding: EdgeInsets.all(5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: press,
        child: Row(
          children: [
            Expanded(
                child: Text(
              text.toUpperCase(),
              style: MyTheme.of(context).labelLarge.copyWith(
                    fontFamily: 'Open Sans',
                    color: MyTheme.of(context).alternate,
                  ),
            )),
            Icon(
              Icons.arrow_forward_ios,
              size: 15,
              color: MyTheme.of(context).alternate,
            ),
          ],
        ),
      ),
    );
  }
}
