import 'package:blueraymarket/backend/schema/serializers.dart';
import 'package:blueraymarket/tools/app_state.dart';
import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:blueraymarket/tools/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';

import '../../../backend/schema/product/product_record.dart';
import '../../../tools/constants.dart';
import '../../../tools/nav/routes.dart';
import '../../../tools/nav/serializer.dart';

class CartCard extends StatelessWidget {
  CartCard({required this.cartItem, required this.cartNumber});

  final ProductRecord cartItem;
  late Map<DocumentReference, int> cartNumber;

  @override
  Widget build(BuildContext context) {
    Map<DocumentReference?, int> productCountMap = {};

    return Row(
      children: [
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(context, 10)),
              decoration: BoxDecoration(
                color: Color(0xFFF5F6F9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.network(cartItem.image!), // product
            ),
          ),
        ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cartItem.title!, // cart title
              style: MyTheme.of(context).bodyLarge,
              maxLines: 2,
            ),
            SizedBox(height: 10),
            Text.rich(
              TextSpan(
                text: "\$ ${cartItem.price}",
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: kPrimaryColor),
                children: [
                  TextSpan(
                      text: " x${cartNumber[cartItem.reference]}",
                      style: Theme.of(context).textTheme.bodyText1),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}

class RecentlyViewedCard extends StatelessWidget {
  RecentlyViewedCard({required this.item});

  final ProductRecord item;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pushReplacementNamed(
          'ProductDetailsScreen',
          queryParameters: {
            'idSubCategory': serializeParam(
              item.idSubCategory,
              ParamType.DocumentReference,
            ),
            'idproduct': serializeParam(
              item.reference,
              ParamType.DocumentReference,
            ),
          }.withoutNulls,
          extra: <String, dynamic>{
            kTransitionInfoKey: TransitionInfo(
              hasTransition: true,
              transitionType: PageTransitionType.rightToLeftWithFade,
              duration: Duration(milliseconds: kTransitionDuration),
            ),
          },
        );
      },
      child: Column(
        children: [
          SizedBox(
            width: 88,
            child: AspectRatio(
              aspectRatio: 0.88,
              child: Container(
                padding:
                    EdgeInsets.all(getProportionateScreenWidth(context, 10)),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.network(item.image!), // product
              ),
            ),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title!.truncateText(10), // cart title
                style: MyTheme.of(context).bodyLarge,
                maxLines: 2,
              ),
              SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  text: "\$ ${item.price}",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: kPrimaryColor),
                  children: [],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
