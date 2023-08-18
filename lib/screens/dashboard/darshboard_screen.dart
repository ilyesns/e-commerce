import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';

import '../../backend/cache/hive_box.dart';
import '../../tools/nav/routes.dart';
import '../../tools/size_config.dart';
import 'components/header.dart';
import 'components/manage_item.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    clearSubcategoryBox();
    clearDiscountsBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}

class Body extends StatelessWidget {
  const Body({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: MyTheme.of(context).primaryBackground,
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2.6,
            decoration: BoxDecoration(
              gradient: MyTheme.of(context).linearGradient,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(70),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                  top: getProportionateScreenHeight(context, 60),
                  left: getProportionateScreenWidth(context, 20),
                  right: getProportionateScreenWidth(context, 20)),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Header(),
                    SizedBox(
                      height: getProportionateScreenHeight(context, 30),
                    ),
                    Container(
                      height: SizeConfig().screenHeight / 1.5,
                      child: DefaultTabController(
                        length: 4,
                        initialIndex: 0,
                        child: Column(
                          children: [
                            TabBar(
                              isScrollable: true,
                              labelColor: MyTheme.of(context).alternate,
                              unselectedLabelColor:
                                  MyTheme.of(context).secondary,
                              labelPadding: EdgeInsets.symmetric(
                                  horizontal:
                                      getProportionateScreenWidth(context, 30)),
                              labelStyle: MyTheme.of(context).titleMedium,
                              indicatorColor: Colors.transparent,
                              indicatorWeight: 3.0,
                              tabs: [
                                Tab(
                                  text: 'Manage Product',
                                ),
                                Tab(
                                  text: 'Manage Orders',
                                ),
                                Tab(
                                  text: 'Manage Teams',
                                ),
                                Tab(
                                  text: 'Statistics',
                                ),
                              ],
                            ),
                            SizedBox(
                              height: getProportionateScreenWidth(context, 10),
                            ),
                            Expanded(
                              // Use Expanded here to occupy remaining height
                              child: TabBarView(
                                physics:
                                    ClampingScrollPhysics(), // Use ClampingScrollPhysics here

                                children: [
                                  SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
// Use ClampingScrollPhysics here

                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                getProportionateScreenWidth(
                                                    context, 10)),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                ManageItem(
                                                  nameItem: "Brands",
                                                  pathSvg:
                                                      'assets/icons/brandfolder.svg',
                                                  onPress: () {
                                                    context.pushNamed(
                                                      'BrandsPage',
                                                      extra: <String, dynamic>{
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
                                                ),
                                                ManageItem(
                                                  nameItem: "Categories",
                                                  pathSvg:
                                                      'assets/icons/category.svg',
                                                  onPress: () {
                                                    context.pushNamed(
                                                      'CategoriesPage',
                                                      extra: <String, dynamic>{
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
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      context, 20),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                ManageItem(
                                                  nameItem: "Sub Categories",
                                                  pathSvg:
                                                      'assets/icons/subcategory.svg',
                                                  onPress: () {
                                                    context.pushNamed(
                                                      'SubCategoriesPage',
                                                      extra: <String, dynamic>{
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
                                                ),
                                                ManageItem(
                                                  nameItem: 'Products',
                                                  pathSvg:
                                                      'assets/icons/product.svg',
                                                  onPress: () {
                                                    context.pushNamed(
                                                      'ProductsPage',
                                                      extra: <String, dynamic>{
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
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      context, 20),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                ManageItem(
                                                  nameItem: 'Variants',
                                                  pathSvg:
                                                      'assets/icons/variation.svg',
                                                  onPress: () {
                                                    context.pushNamed(
                                                      'VariantsPage',
                                                      extra: <String, dynamic>{
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
                                                ),
                                                ManageItem(
                                                  nameItem: 'Discounts',
                                                  pathSvg:
                                                      'assets/icons/discounts.svg',
                                                  onPress: () {
                                                    context.pushNamed(
                                                      'DiscountsPage',
                                                      extra: <String, dynamic>{
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
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      context, 20),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                ManageItem(
                                                  nameItem:
                                                      'Products / Variants',
                                                  pathSvg:
                                                      'assets/icons/variation.svg',
                                                  onPress: () {
                                                    context.pushNamed(
                                                      'ProductsVariantsPage',
                                                      extra: <String, dynamic>{
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
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                  ),
                                  SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
// Use ClampingScrollPhysics here

                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                getProportionateScreenHeight(
                                                    context, 10),
                                            horizontal:
                                                getProportionateScreenWidth(
                                                    context, 10)),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                ManageItem(
                                                  nameItem:
                                                      "View Orders List and Details",
                                                  pathSvg:
                                                      'assets/icons/orders.svg',
                                                  onPress: () {},
                                                ),
                                                ManageItem(
                                                  nameItem:
                                                      "Update Orders Status",
                                                  pathSvg:
                                                      'assets/icons/update.svg',
                                                  onPress: () {},
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      context, 20),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                ManageItem(
                                                  nameItem:
                                                      "Manage Returns and Refunds",
                                                  pathSvg:
                                                      'assets/icons/app-manage.svg',
                                                  onPress: () {},
                                                ),
                                                ManageItem(
                                                  nameItem:
                                                      'Handle Order Issues',
                                                  pathSvg:
                                                      'assets/icons/cancle-order.svg',
                                                  onPress: () {},
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      context, 20),
                                            ),
                                          ],
                                        )),
                                  ),
                                  SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                getProportionateScreenHeight(
                                                    context, 10),
                                            horizontal:
                                                getProportionateScreenWidth(
                                                    context, 10)),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                ManageItem(
                                                  nameItem:
                                                      "View Teams Members",
                                                  pathSvg:
                                                      'assets/icons/teamwork.svg',
                                                  onPress: () {},
                                                ),
                                                ManageItem(
                                                  nameItem:
                                                      "Teams Permission Management",
                                                  pathSvg:
                                                      'assets/icons/team-per.svg',
                                                  onPress: () {},
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      context, 20),
                                            ),
                                          ],
                                        )),
                                  ),
                                  SingleChildScrollView(
                                    physics: BouncingScrollPhysics(),
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical:
                                                getProportionateScreenHeight(
                                                    context, 10),
                                            horizontal:
                                                getProportionateScreenWidth(
                                                    context, 10)),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                ManageItem(
                                                  nameItem:
                                                      "View Sales And Revenues",
                                                  pathSvg:
                                                      'assets/icons/sales.svg',
                                                  onPress: () {},
                                                ),
                                                ManageItem(
                                                  nameItem:
                                                      "Monitor Invetory Statistics",
                                                  pathSvg:
                                                      'assets/icons/monitor.svg',
                                                  onPress: () {},
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      context, 20),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                ManageItem(
                                                  nameItem:
                                                      "Generate Customized Reports",
                                                  pathSvg:
                                                      'assets/icons/business-documents.svg',
                                                  onPress: () {},
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      context, 20),
                                            ),
                                          ],
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
