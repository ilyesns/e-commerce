import 'package:blueraymarket/backend/schema/discount/discount_record.dart';
import 'package:blueraymarket/backend/schema/product/product_record.dart';
import 'package:blueraymarket/tools/app_state.dart';
import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:blueraymarket/tools/util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:blueraymarket/screens/details/details_screen.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:go_router/go_router.dart';

import '../tools/constants.dart';
import '../tools/nav/serializer.dart';

class ProductCard extends StatefulWidget {
  ProductCard({
    Key? key,
    this.aspectRetio = 1.02,
    required this.product,
  }) : super(key: key);

  final double aspectRetio;
  final ProductRecord product;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final AppState appState = AppState();
  late DiscountRecord? discount;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    discount = appState.discounts
        .where((element) => element!.reference == widget.product.idDiscount)
        .firstOrNull;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(context, 20)),
      child: SizedBox(
        width: 150,
        height: 170,
        child: GestureDetector(
          onTap: () {
            context.pushNamed('ProductDetailsScreen', queryParameters: {
              'idproduct': serializeParam(
                widget.product.ffRef!,
                ParamType.DocumentReference,
              ),
              'idSubCategory': serializeParam(
                widget.product.idSubCategory,
                ParamType.DocumentReference,
              )
            });

            setState(() {
              AppState().addToRecentlyViewed(widget.product.reference);
            });
          },
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: 3.8 / 2,
                    child: Container(
                      padding: EdgeInsets.all(
                          getProportionateScreenWidth(context, 20)),
                      decoration: BoxDecoration(
                        color: kSecondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Hero(
                        tag: widget.product.reference
                            .toString(), //                 // ############# edhy bch nbadlouha b product mte3na

                        child: CachedNetworkImage(
                          imageUrl: widget.product.image!,
                          placeholder: (context, url) => Image.asset(
                              'assets/images/blue_ray_image.jpg'), // Placeholder widget
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.product.title!.truncateText(25),
                    style: MyTheme.of(context).labelLarge,
                    maxLines: 2,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "\$${widget.product.price}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: MyTheme.of(context).primaryText,
                    ),
                  ),
                ],
              ),
              if (discount?.active != null && discount!.active == true)
                Positioned(
                    right: 5,
                    top: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: MyTheme.of(context).primary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: 35,
                      height: 35,
                      child: Center(child: Text("35%")),
                    ))
            ],
          ),
        ),
      ),
    );
  }
}
