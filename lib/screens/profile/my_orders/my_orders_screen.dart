import 'package:blueraymarket/auth/auth_util.dart';
import 'package:blueraymarket/auth/firebase_user_provider.dart';
import 'package:blueraymarket/backend/backend.dart';
import 'package:blueraymarket/backend/schema/order_details/order_details_record.dart';
import 'package:blueraymarket/backend/schema/order_item/order_item_record.dart';
import 'package:blueraymarket/tools/app_state.dart';
import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:blueraymarket/tools/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../../components/default_button.dart';
import '../../../tools/nav/routes.dart';
import '../../../tools/nav/serializer.dart';
import 'components/header.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  const Body({
    super.key,
  });

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AppState>();
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            CustomAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: SizeConfig().screenHeight / 1.5,
                      child: DefaultTabController(
                        length: 2,
                        initialIndex: 0,
                        child: Column(
                          children: [
                            TabBar(
                              isScrollable: true,
                              labelColor: MyTheme.of(context).primary,
                              unselectedLabelColor:
                                  MyTheme.of(context).grayLight,
                              labelPadding: EdgeInsets.symmetric(
                                  horizontal:
                                      getProportionateScreenWidth(context, 20)),
                              labelStyle:
                                  MyTheme.of(context).titleMedium.copyWith(
                                        fontFamily: 'Outfit',
                                      ),
                              indicatorColor: MyTheme.of(context).primary,
                              indicatorWeight: 3.0,
                              tabs: [
                                Tab(
                                  text: 'successful order'.toUpperCase(),
                                ),
                                Tab(
                                  text: 'command failed'.toUpperCase(),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: getProportionateScreenWidth(context, 10),
                            ),
                            Expanded(
                              // Use Expanded here to occupy remaining height
                              child: FutureBuilder(
                                  future: Future.wait([
                                    queryOrderDetailsRecordOnce(
                                        queryBuilder: (q) => q.where("user_id",
                                            isEqualTo: currentUserReference)),
                                    queryOrderItemsRecordOnce(
                                        queryBuilder: (q) => q.where('user_id',
                                            isEqualTo: currentUserReference))
                                  ]),
                                  builder: (_, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting)
                                      return loadingIndicator(context);

                                    if (!snapshot.hasData ||
                                        snapshot.data![0].isEmpty)
                                      return Container(
                                        width: MediaQuery.sizeOf(context).width,
                                        height: getProportionateScreenHeight(
                                            context, 300),
                                        child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                width:
                                                    getProportionateScreenWidth(
                                                        context, 100),
                                                height:
                                                    getProportionateScreenHeight(
                                                        context, 100),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50))),
                                                child: Container(
                                                  padding: EdgeInsets.all(20),
                                                  width: 30,
                                                  height: 30,
                                                  child: SvgPicture.asset(
                                                    'assets/icons/cart.svg',
                                                    color: MyTheme.of(context)
                                                        .primary,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        context, 20),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'You have no pending orders',
                                                    style: MyTheme.of(context)
                                                        .titleMedium
                                                        .copyWith(
                                                            fontFamily:
                                                                'Open Sans',
                                                            color: MyTheme.of(
                                                                    context)
                                                                .primaryText,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                  )
                                                ],
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
                                                      'Your orders will be saved here to access their status at any time',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: MyTheme.of(context)
                                                          .bodyLarge
                                                          .copyWith(
                                                            fontFamily:
                                                                'Open Sans',
                                                            color: MyTheme.of(
                                                                    context)
                                                                .primaryText,
                                                          ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        context, 20),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height:
                                                    getProportionateScreenHeight(
                                                        context, 50),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: DefaultButton(
                                                    text: 'Start Shopping',
                                                    press: () {
                                                      context
                                                          .pushReplacementNamed(
                                                              'NavBarPage',
                                                              queryParameters: {
                                                            'initialPage':
                                                                serializeParam(
                                                              'CategoriesPage',
                                                              ParamType.String,
                                                            ),
                                                          },
                                                              extra: {
                                                            kTransitionInfoKey:
                                                                TransitionInfo(
                                                                    hasTransition:
                                                                        true,
                                                                    duration:
                                                                        250.ms,
                                                                    transitionType:
                                                                        PageTransitionType
                                                                            .bottomToTop)
                                                          });
                                                    }),
                                              ),
                                            ]),
                                      );
                                    final ordersDetails = snapshot.data![0]
                                        as List<OrderDetailsRecord>;
                                    final ordersItems = snapshot.data![1]
                                        as List<OrderItemRecord>;
                                    final orders = ordersItems.where(
                                      (element) => ordersDetails
                                          .contains(element.orderDetailsId),
                                    );

                                    return TabBarView(
                                      physics:
                                          ClampingScrollPhysics(), // Use ClampingScrollPhysics here

                                      children: [
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    getProportionateScreenWidth(
                                                        context, 10)),
                                            child: Container(
                                              child: Column(
                                                children: [],
                                              ),
                                            )),
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
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [],
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        getProportionateScreenHeight(
                                                            context, 20),
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [],
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
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
