import 'package:blueraymarket/backend/schema/product/product_record.dart';
import 'package:blueraymarket/tools/app_state.dart';
import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:blueraymarket/screens/details/details_screen.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:go_router/go_router.dart';

import '../tools/constants.dart';
import '../tools/nav/serializer.dart';

class ProductCard extends StatelessWidget {
  ProductCard({
    Key? key,
    this.aspectRetio = 1.02,
    required this.product,
  }) : super(key: key);

  final double aspectRetio;
  final ProductRecord product;
  final AppState appState = AppState();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(context, 20)),
      child: SizedBox(
        width: 200,
        height: 170,
        child: GestureDetector(
          onTap: () {
            context.pushNamed('ProductDetailsScreen', queryParameters: {
              'idproduct': serializeParam(
                product.ffRef!,
                ParamType.DocumentReference,
              ),
              'idSubCategory': serializeParam(
                product.idSubCategory,
                ParamType.DocumentReference,
              )
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: 3.8 / 2,
                child: Container(
                  padding:
                      EdgeInsets.all(getProportionateScreenWidth(context, 20)),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Hero(
                    tag: product.reference
                        .toString(), //                 // ############# edhy bch nbadlouha b product mte3na

                    child: CachedNetworkImage(
                      imageUrl: product.image!,
                      placeholder: (context, url) => Image.asset(
                          'assets/images/blue_ray_image.jpg'), // Placeholder widget
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                product.title!.toUpperCase(),
                style: MyTheme.of(context).labelLarge,
                maxLines: 2,
              ),
              SizedBox(height: 10),
              Text(
                "\$${product.price}",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(context, 18),
                  fontWeight: FontWeight.w600,
                  color: MyTheme.of(context).primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
