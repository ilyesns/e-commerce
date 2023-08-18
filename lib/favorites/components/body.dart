import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:blueraymarket/tools/size_config.dart';

import '../../screens/cart/components/check_out_card.dart';
import 'cart_card.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig().screenWidth,
      height: SizeConfig().screenHeight,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(context, 20)),
        child: ListView.builder(
          itemCount: 0, // cart length
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Dismissible(
              key: Key("demoCarts[index].product.id.toString()"),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                setState(() {
                  //  Carts.removeAt(index);
                });
              },
              background: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Color(0xFFFFE6E6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Spacer(),
                    SvgPicture.asset("assets/icons/Trash.svg"),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                  child: Column(
                children: [CartCard(), CheckoutCard()],
              )),
            ),
          ),
        ),
      ),
    );
  }
}
