import 'dart:async';

import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:shimmer/shimmer.dart';

import '../../../backend/schema/discount/discount_record.dart';

class DiscountBanner extends StatefulWidget {
  DiscountBanner({Key? key, required this.discounts}) : super(key: key);
  List<DiscountRecord?> discounts;

  @override
  State<DiscountBanner> createState() => _DiscountBannerState();
}

class _DiscountBannerState extends State<DiscountBanner> {
  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  int _numberOfPages = 3; // Replace with the actual number of pages
  int _millisecondsPerScroll = 3000; // Set the time interval for auto-scrolling

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Timer.periodic(Duration(milliseconds: _millisecondsPerScroll), (timer) {
      if (!_pageController.hasClients) {
        return;
      }

      if (_currentPage < _numberOfPages - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.discounts!.length,
      allowImplicitScrolling: true,
      itemBuilder: (BuildContext context, int index) {
        int actualIndex = index % widget.discounts!.length;

        final discount = widget.discounts![actualIndex];

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            height: getProportionateScreenHeight(context, 150),
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    discount!.image!,
                  ),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Container(
              padding: EdgeInsets.all(
                getProportionateScreenWidth(context, 10),
              ),
              decoration: BoxDecoration(
                color: Color.fromARGB(100, 0, 0, 0),
                borderRadius: BorderRadius.circular(5),
              ),
              width: double.infinity,
              height: double.infinity,
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text.rich(
                  TextSpan(
                    style: TextStyle(color: Colors.white),
                    children: [
                      TextSpan(
                          text: "${discount.title}\n",
                          style: MyTheme.of(context).titleSmall.copyWith(
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.bold)),
                      TextSpan(text: "\n"),
                      TextSpan(
                          text: "${discount.description}\n",
                          style: MyTheme.of(context).labelLarge.copyWith(
                              fontFamily: 'Open Sans',
                              color: MyTheme.of(context).alternate)),
                      TextSpan(text: "\n"),
                      TextSpan(
                        text: "Cashback ${discount.discountPercent!.ceil()}%",
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(context, 16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ShimmerDiscountBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: 2,
      allowImplicitScrolling: true,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Shimmer.fromColors(
            baseColor: MyTheme.of(context).grayLight,
            highlightColor: MyTheme.of(context).grayDark,
            child: Container(
              height: getProportionateScreenHeight(context, 150),
              width: double.infinity,
              decoration: BoxDecoration(
                color: MyTheme.of(context).alternate,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Container(
                padding: EdgeInsets.all(
                  getProportionateScreenWidth(context, 10),
                ),
                decoration: BoxDecoration(
                  color: Color.fromARGB(100, 0, 0, 0),
                  borderRadius: BorderRadius.circular(5),
                ),
                width: double.infinity,
                height: double.infinity,
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(color: Colors.white),
                      children: [],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
