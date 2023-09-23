import 'package:blueraymarket/backend/schema/serializers.dart';
import 'package:blueraymarket/tools/app_state.dart';
import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
import 'cart_card.dart';
import 'header.dart';
import 'package:my_fatoorah/my_fatoorah.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late List<ProductRecord?> cart;
  late List<ProductRecord?> recentlyViewed;
  late List<ProductRecord?> recommanded;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    cart = AppState()
        .products
        .where((element) => AppState().cart.containsKey(element!.ffRef))
        .toList();

    recentlyViewed = AppState()
        .products
        .where(
            (element) => AppState().recentlyViewed.contains(element!.reference))
        .toList();
    recommanded = AppState().products.sublist(0, 4);
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AppState>();
    return Column(
      children: [
        SafeArea(
          child: CustomAppBar(
            title: "Cart",
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: getProportionateScreenHeight(context, 20),
                    ),
                    if (cart.isNotEmpty)
                      Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    getProportionateScreenWidth(context, 10)),
                            itemCount: cart.length, // cart length
                            itemBuilder: (context, index) => Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Dismissible(
                                key: UniqueKey(),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) {
                                  setState(() {
                                    AppState()
                                        .removeFromCart(cart[index]!.reference);
                                    cart = cart = AppState()
                                        .products
                                        .where((element) => AppState()
                                            .cart
                                            .containsKey(element!.reference))
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
                                      SvgPicture.asset(
                                          "assets/icons/Trash.svg"),
                                    ],
                                  ),
                                ),
                                child: CartCard(
                                  cartItem: cart[index]!,
                                ), // AppState().cart
                              ),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: getProportionateScreenHeight(context, 20),
                    ),
                    if (cart.isEmpty)
                      Container(
                        width: MediaQuery.sizeOf(context).width,
                        height: getProportionateScreenHeight(context, 300),
                        child: Column(children: [
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
                                child:
                                    SvgPicture.asset('assets/icons/cart.svg')),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(context, 20),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Your Cart is empty',
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
                              Text(
                                'Browse our categories and discover our best offers',
                                style: MyTheme.of(context).bodyLarge.copyWith(
                                      fontFamily: 'Open Sans',
                                      color: MyTheme.of(context).primaryText,
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
                            child: DefaultButton(text: 'Start Shopping'),
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
                                              recentlyViewed
                                                  .first!.idSubCategory,
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
                                              color:
                                                  MyTheme.of(context).primary,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height:
                                    getProportionateScreenHeight(context, 10),
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
                                    'Recommended for you',
                                    style: MyTheme.of(context).bodyLarge,
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
                                  getProportionateScreenHeight(context, 200),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(
                                    horizontal: getProportionateScreenWidth(
                                        context, 10)),
                                itemCount: recommanded.isNotEmpty
                                    ? recommanded.length
                                    : 0,
                                itemBuilder: (context, index) => Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Container(
                                    margin: index != 0
                                        ? EdgeInsets.symmetric(horizontal: 5)
                                        : null,
                                    child: ProductCard(
                                        product: recommanded[index]!),
                                  ),
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
              Positioned(
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(),
                  child: Row(
                    children: [
                      Row(children: [
                        
                      ],),
                      Container(
                        width: MediaQuery.sizeOf(context).width,
                        height: getProportionateScreenHeight(context, 50),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: DefaultButton(
                          text: 'Order Now',
                          press: () async {
                            var response = await MyFatoorah.startPayment(
                              context: context,
                              request: MyfatoorahRequest.test(
                                  currencyIso: Country.Qatar,
                                  successUrl:
                                      'https://img.freepik.com/premium-vector/transaction-approved-financial-transactions-non-cash-payment-monetary-currency-payment-nfc-concept-vector-illustration_106788-3299.jpg?w=360',
                                  errorUrl: 'https://www.google.com/',
                                  invoiceAmount: 100,
                                  language: ApiLanguage.English,
                                  token:
                                      'rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL'),
                            );
                            print("####################################");
                            print(response.paymentId.toString());
                            print(response.status);
                            print("####################################");
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
