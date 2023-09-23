import 'package:blueraymarket/tools/internationalization.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:shimmer/shimmer.dart';

import '../../../backend/schema/product/product_record.dart';
import '../../../backend/schema/sub_category/sub_category_record.dart';
import '../../../tools/nav/theme.dart';
import 'section_title.dart';

class SpecialOffers extends StatefulWidget {
  SpecialOffers({Key? key, required this.subCategories, required this.products})
      : super(key: key);
  List<SubCategoryRecord?> subCategories;
  List<ProductRecord?> products;

  @override
  State<SpecialOffers> createState() => _SpecialOffersState();
}

class _SpecialOffersState extends State<SpecialOffers> {
  final PageController _pageController =
      PageController(viewportFraction: 0.8, initialPage: 1);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle(
          title: MyLocalizations.of(context).getText('S8lF3'),
          press: () {},
        ),
        SizedBox(height: getProportionateScreenWidth(context, 20)),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 100,
          child: PageView.builder(
              controller: _pageController,
              itemCount: widget.subCategories.length,
              itemBuilder: (_, index) {
                final subCategory = widget.subCategories[index];
                return SpecialOfferCard(
                  image: subCategory!.image!,
                  category: subCategory.subCategoryName!,
                  numOfBrands: widget.products
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
          width: getProportionateScreenWidth(context, 150),
          height: getProportionateScreenWidth(context, 100),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
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
                        TextSpan(
                            text:
                                "$numOfBrands ${MyLocalizations.of(context).getText('P5sS1')}")
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

class ShimmerSpecialOffers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShimmerSectionTitle(),
        SizedBox(height: getProportionateScreenWidth(context, 20)),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 120,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              itemBuilder: (_, index) {
                return ShimmerSpecialOfferCard();
              }),
        )
      ],
    );
  }
}

class ShimmerSpecialOfferCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(context, 20)),
      child: SizedBox(
        width: getProportionateScreenWidth(context, 242),
        height: getProportionateScreenWidth(context, 100),
        child: Shimmer.fromColors(
          baseColor: MyTheme.of(context).grayLight,
          highlightColor: MyTheme.of(context).grayDark,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Stack(
              children: [
                Container(),
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
                      children: [],
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
