import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:blueraymarket/screens/details/details_screen.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:go_router/go_router.dart';

import '../tools/constants.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    this.width = 140,
    this.aspectRetio = 1.02,
  }) : super(key: key);

  final double width, aspectRetio;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(context, 20)),
      child: SizedBox(
        width: getProportionateScreenWidth(context, width),
        child: GestureDetector(
          onTap: () {
            // Create a builder function to build the ProductDetailsScreen widget.
            WidgetBuilder builder = (context) =>
                ProductDetailsScreen(); // ############# edhy bch nbadlouha b product mte3na

            // Navigate to the ProductDetailsScreen widget with builder.
            Navigator.push(
              context,
              MaterialPageRoute(builder: builder),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.02,
                child: Container(
                  padding:
                      EdgeInsets.all(getProportionateScreenWidth(context, 20)),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Hero(
                    tag:
                        "product.id.toString()", //                 // ############# edhy bch nbadlouha b product mte3na

                    child: Image.asset("product.images[0]"),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                " product.title",
                style: TextStyle(color: Colors.black),
                maxLines: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$${"product.price"}",
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(context, 18),
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor,
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(
                          getProportionateScreenWidth(context, 8)),
                      height: getProportionateScreenWidth(context, 28),
                      width: getProportionateScreenWidth(context, 28),
                      decoration: BoxDecoration(
                        // color: "product.isFavourite"
                        //     ? kPrimaryColor.withOpacity(0.15)
                        //     : kSecondaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        "assets/icons/Heart Icon_2.svg",
                        /*
                       " color: product.isFavourite
                            ? Color(0xFFFF4848)
                            : Color(0xFFDBDEE4)," */
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
