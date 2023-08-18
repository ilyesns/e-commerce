import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:blueraymarket/tools/size_config.dart';

import '../../../backend/schema/product/product_record.dart';
import '../../../backend/schema/sub_category/sub_category_record.dart';
import 'section_title.dart';

class SpecialOffers extends StatelessWidget {
  SpecialOffers({Key? key, required this.subCategories, required this.products})
      : super(key: key);
  List<SubCategoryRecord?> subCategories;
  List<ProductRecord?> products;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(context, 20)),
          child: SectionTitle(
            title: "Special for you",
            press: () {},
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(context, 20)),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 120,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: subCategories.length,
              itemBuilder: (_, index) {
                final subCategory = subCategories[index];
                return SpecialOfferCard(
                  image: subCategory!.image!,
                  category: subCategory.subCategoryName!,
                  numOfBrands: products
                      .where((product) =>
                          product!.idSubCategory == subCategory.reference)
                      .length,
                  press: () {},
                );
              }),
        )
      ],
    );
  }
}

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key? key,
    required this.category,
    required this.image,
    required this.numOfBrands,
    required this.press,
  }) : super(key: key);

  final String category, image;
  final int numOfBrands;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(context, 20)),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: getProportionateScreenWidth(context, 242),
          height: getProportionateScreenWidth(context, 100),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                CachedNetworkImage(
                    imageUrl: image,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Image.asset(
                        'assets/images/blue_ray_image.jpg'), // Placeholder widget
                    errorWidget: (context, url, error) => Icon(Icons.error)),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF343434).withOpacity(0.4),
                        Color(0xFF343434).withOpacity(0.15),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(context, 15.0),
                    vertical: getProportionateScreenWidth(context, 10),
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "$category\n",
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(context, 18),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: "$numOfBrands Products")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
