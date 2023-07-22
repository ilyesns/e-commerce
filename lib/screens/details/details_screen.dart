import 'package:flutter/material.dart';

import 'components/body.dart';
import 'components/custom_app_bar.dart';

class ProductDetailsScreen extends StatefulWidget {
  ProductDetailsScreen();

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppBar().preferredSize.height),
        child: CustomAppBar(), // pass rating product
      ),
      body: Body(), // pass the product document reference
    );
  }
}
