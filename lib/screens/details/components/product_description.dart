import 'package:blueraymarket/backend/schema/discount/discount_record.dart';
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
  DiscountRecord? _discountRecord;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _discountRecord = getDiscountRecord(widget.product!.idDiscount!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.product!.title!.capitalize(), // product title
          style: MyTheme.of(context).bodyLarge,
        ),
        SizedBox(
          height: getProportionateScreenHeight(context, 10),
        ),
        RichText(
          text: TextSpan(
            style: MyTheme.of(context)
                .labelMedium, // Default style for the entire text
            children: [
              TextSpan(text: 'Brand: ', style: MyTheme.of(context).labelMedium),
              TextSpan(
                  text:
                      '${widget.product!.brandName!.capitalize()}', // Product title
                  style: MyTheme.of(context).labelMedium.copyWith(
                        color: MyTheme.of(context).primary,
                      )),
            ],
          ),
        ),
        SizedBox(
          height: getProportionateScreenHeight(context, 10),
        ),
        Column(
          children: [
            if (_discountRecord != null && _discountRecord!.active == true)
              Row(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              '${(widget.product!.price! - (widget.product!.price! * _discountRecord!.discountPercent! / 100))} US\$ ', // product title
                          style: MyTheme.of(context).titleLarge,
                        ),
                        TextSpan(
                            text:
                                '${widget.product!.price.toString()} US\$ ', // product title
                            style: TextStyle(
                              color: MyTheme.of(context).grayDark,
                              decoration: TextDecoration
                                  .lineThrough, // Add a strikethrough line
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: getProportionateScreenWidth(context, 30),
                  ),
                  Container(
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: MyTheme.of(context).secondary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                          child: Text(
                        '${_discountRecord!.discountPercent!.floor()}%',
                        style: TextStyle(color: MyTheme.of(context).alternate),
                      )))
                ],
              ),
            if (_discountRecord != null && _discountRecord!.active == false)
              Row(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              '${widget.product!.price!} US\$ ', // product title
                          style: MyTheme.of(context).titleLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
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
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppState().favorite.contains(widget.product!.reference)
                    ? Color(0xFFFFE6E6)
                    : Color(0xFFF5F6F9),
                borderRadius: BorderRadius.all(
                  Radius.circular(50),
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
        Text(
          overflow: seeMore ? null : TextOverflow.ellipsis,
          widget.product!.description!,
          maxLines: seeMore ? null : 3,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
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
