import 'package:another_flushbar/flushbar.dart';
import 'package:blueraymarket/tools/app_state.dart';
import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:blueraymarket/tools/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../backend/schema/product/product_record.dart';
import '../../../components/default_button.dart';
import '../../../tools/constants.dart';

class FavoriteCard extends StatelessWidget {
  FavoriteCard({required this.favoriteItem, required this.favorites});

  final ProductRecord favoriteItem;
  final List<ProductRecord?> favorites;
  @override
  Widget build(BuildContext context) {
    Map<DocumentReference?, int> productCountMap = {};

    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: getProportionateScreenHeight(context, 150),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 88,
                child: AspectRatio(
                  aspectRatio: 0.88,
                  child: Container(
                    padding: EdgeInsets.all(
                        getProportionateScreenWidth(context, 10)),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F6F9),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.network(favoriteItem.image!), // product
                  ),
                ),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    favoriteItem.title!, // cart title
                    style: MyTheme.of(context).bodyLarge,
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: 150,
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      favoriteItem.description!, // cart title
                      style: MyTheme.of(context).bodyMedium,
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "\$ ${favoriteItem.price}",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                        fontSize: 22),
                  )
                ],
              ),
            ],
          ),
          Container(
            width: getProportionateScreenWidth(context, 100),
            height: getProportionateScreenHeight(context, 50),
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(context, 10)),
            child: DefaultButton(
                text: 'Buy Now'.truncateText(15),
                press: () async {
                  //  AppState().addToCart(favoriteItem.reference, 1);
                  Flushbar(
                    backgroundColor: MyTheme.of(context).success,
                    message: "Cart updated with success",
                    icon: Icon(
                      Icons.check,
                      size: 28.0,
                      color: Colors.white,
                    ),
                    duration: Duration(seconds: 3),
                    leftBarIndicatorColor: MyTheme.of(context).accent4,
                  )..show(context);
                }),
          ),
        ],
      ),
    );
  }
}

class RecentlyViewedCard extends StatelessWidget {
  RecentlyViewedCard({required this.item});

  final ProductRecord item;
  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
