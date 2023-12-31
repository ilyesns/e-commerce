import 'package:blueraymarket/backend/schema/serializers.dart';
import 'package:blueraymarket/tools/app_state.dart';
import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../../backend/schema/product/product_record.dart';
import '../../../components/default_button.dart';
import '../../../components/product_card.dart';
import '../../../tools/nav/routes.dart';
import '../../../tools/nav/serializer.dart';
import '../../cart/components/cart_card.dart';
import 'favorite_item.dart' as favoriteItem;
import 'header.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late List<ProductRecord?> favorites;
  late Map<DocumentReference, int> cartNumber;
  late List<ProductRecord?> recentlyViewed;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    favorites = AppState()
        .products
        .where((element) => AppState().favorite.contains(element!.reference))
        .toList();
    recentlyViewed = AppState()
        .products
        .where(
            (element) => AppState().recentlyViewed.contains(element!.reference))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AppState>();
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SafeArea(
          child: CustomAppBar(
            title: 'My wish list',
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            color: MyTheme.of(context).primary,
            backgroundColor: Colors.white,
            onRefresh: () async {
              setState(() {
                favorites = favorites = AppState()
                    .products
                    .where((element) =>
                        AppState().favorite.contains(element!.reference))
                    .toList();
              });
              print("hey");
            },
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: getProportionateScreenHeight(context, 20),
                  ),
                  if (favorites.isNotEmpty)
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  getProportionateScreenWidth(context, 10)),
                          itemCount: favorites.length, // cart length
                          itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                setState(() {
                                  AppState()
                                      .favorite
                                      .remove(favorites[index]!.reference);
                                  favorites = favorites = AppState()
                                      .products
                                      .where((element) => AppState()
                                          .favorite
                                          .contains(element!.reference))
                                      .toList();
                                });
                              },
                              background: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFFE6E6),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    Spacer(),
                                    SvgPicture.asset("assets/icons/Trash.svg"),
                                  ],
                                ),
                              ),
                              child: favoriteItem.FavoriteCard(
                                  favoriteItem: favorites[index]!,
                                  favorites: favorites),
                            ),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(
                    height: getProportionateScreenHeight(context, 30),
                  ),
                  if (favorites.isEmpty)
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      height: getProportionateScreenHeight(context, 300),
                      child: Column(mainAxisSize: MainAxisSize.max, children: [
                        Container(
                          width: getProportionateScreenWidth(context, 100),
                          height: getProportionateScreenHeight(context, 100),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            width: 30,
                            height: 30,
                            child: SvgPicture.asset(
                              'assets/icons/favourite.svg',
                              color: MyTheme.of(context).primary,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(context, 20),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'You haven\'t put an article aside yet',
                              style: MyTheme.of(context).titleMedium.copyWith(
                                  fontFamily: 'Open Sans',
                                  color: MyTheme.of(context).primaryText,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(context, 10),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                'Tap the heart icon in your favorite items and save them here to buy them later',
                                textAlign: TextAlign.center,
                                style: MyTheme.of(context).bodyLarge.copyWith(
                                      fontFamily: 'Open Sans',
                                      color: MyTheme.of(context).primaryText,
                                    ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(context, 20),
                        ),
                        Container(
                          width: double.infinity,
                          height: getProportionateScreenHeight(context, 50),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: DefaultButton(
                              text: 'Start Shopping',
                              press: () {
                                context.pushReplacementNamed('NavBarPage',
                                    queryParameters: {
                                      'initialPage': serializeParam(
                                        'CategoriesPage',
                                        ParamType.String,
                                      ),
                                    },
                                    extra: {
                                      kTransitionInfoKey: TransitionInfo(
                                          hasTransition: true,
                                          duration: 250.ms,
                                          transitionType:
                                              PageTransitionType.bottomToTop)
                                    });
                              }),
                        ),
                      ]),
                    ),
                  if (recentlyViewed.isNotEmpty)
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      height: getProportionateScreenHeight(context, 250),
                      color: MyTheme.of(context).secondaryBackground,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Recently viewed',
                                    style: MyTheme.of(context).bodyLarge,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      context.pushNamed(
                                        'ListProductsPage',
                                        queryParameters: {
                                          'idSubCategory': serializeParam(
                                            recentlyViewed.first!.idSubCategory,
                                            ParamType.DocumentReference,
                                          ),
                                          'subCategoryName': serializeParam(
                                            recentlyViewed
                                                .first!.subcategoryName,
                                            ParamType.String,
                                          ),
                                        }.withoutNulls,
                                        extra: <String, dynamic>{
                                          kTransitionInfoKey: TransitionInfo(
                                            hasTransition: true,
                                            transitionType: PageTransitionType
                                                .rightToLeftWithFade,
                                            duration: Duration(
                                                milliseconds:
                                                    kTransitionDuration),
                                          ),
                                        },
                                      );
                                    },
                                    child: Text(
                                      'See more',
                                      style: MyTheme.of(context)
                                          .labelMedium
                                          .copyWith(
                                            color: MyTheme.of(context).primary,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: getProportionateScreenHeight(context, 10),
                            ),
                            Container(
                              width: MediaQuery.sizeOf(context).width,
                              height:
                                  getProportionateScreenHeight(context, 170),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(
                                    horizontal: getProportionateScreenWidth(
                                        context, 10)),
                                itemCount: recentlyViewed.length,
                                itemBuilder: (context, index) => Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Container(
                                    margin: index != 0
                                        ? EdgeInsets.symmetric(horizontal: 5)
                                        : null,
                                    child: RecentlyViewedCard(
                                        item: recentlyViewed[index]!),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(
                    height: getProportionateScreenHeight(context, 30),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
