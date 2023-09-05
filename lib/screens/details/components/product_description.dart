import 'package:blueraymarket/tools/app_state.dart';
import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:blueraymarket/tools/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:provider/provider.dart';

import '../../../backend/schema/product/product_record.dart';
import '../../../tools/constants.dart';

class ProductDescription extends StatefulWidget {
  ProductDescription({required this.product, this.pressOnSeeMore});

  final ProductRecord? product;
  final GestureTapCallback? pressOnSeeMore;

  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  bool seeMore = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(context, 20)),
          child: Text(
            widget.product!.title!.capitalize(), // product title
            style: MyTheme.of(context).titleLarge,
          ),
        ),
        SizedBox(
          height: getProportionateScreenHeight(context, 20),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(context, 20)),
          child: Text(
            'US\$ ${widget.product!.price.toString()}', // product title
            style: MyTheme.of(context).titleLarge.copyWith(
                fontFamily: 'Open Sans', color: MyTheme.of(context).primary),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () {
              setState(() {
                if (!AppState().favorite.contains(widget.product!.reference))
                  AppState().addToFavorite(widget.product!.reference);
                else
                  AppState().removeFromFavorite(widget.product!.ffRef!);
              });
            },
            child: Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(context, 15)),
              width: getProportionateScreenWidth(context, 64),
              decoration: BoxDecoration(
                color: AppState().favorite.contains(widget.product!.reference)
                    ? Color(0xFFFFE6E6)
                    : Color(0xFFF5F6F9),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: SvgPicture.asset(
                "assets/icons/Heart Icon_2.svg",
                color: AppState().favorite.contains(widget.product!.reference)
                    ? Color(0xFFFF4848)
                    : Color(0xFFDBDEE4),
                height: getProportionateScreenWidth(context, 16),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(context, 20),
            right: getProportionateScreenWidth(context, 64),
          ),
          child: Text(
            overflow: seeMore ? null : TextOverflow.ellipsis,
            widget.product!.description!,
            maxLines: seeMore ? null : 3,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(context, 20),
            vertical: 10,
          ),
          child: GestureDetector(
            onTap: () {
              setState(() {
                seeMore = !seeMore;
              });
            },
            child: Row(
              children: [
                if (!seeMore)
                  Text(
                    "See More Detail",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: kPrimaryColor),
                  ),
                if (!seeMore) SizedBox(width: 5),
                if (!seeMore)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: kPrimaryColor,
                  ),
                if (seeMore)
                  Text(
                    "See Less Detail",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: kPrimaryColor),
                  ),
                if (seeMore) SizedBox(width: 5),
                if (seeMore)
                  Icon(
                    Icons.arrow_back_ios,
                    size: 12,
                    color: kPrimaryColor,
                  ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
