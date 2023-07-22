import 'package:blueraymarket/auth/auth_util.dart';
import 'package:blueraymarket/backend/schema/brand/brand_record.dart';
import 'package:blueraymarket/tools/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:blueraymarket/components/default_button.dart';
import 'package:blueraymarket/tools/size_config.dart';

import '../../../backend/schema/product/product_record.dart';
import '../../../tools/constants.dart';

class CheckoutCard extends StatelessWidget {
  const CheckoutCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenWidth(context, 15),
        horizontal: getProportionateScreenWidth(context, 30),
      ),
      // height: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  height: getProportionateScreenWidth(context, 40),
                  width: getProportionateScreenWidth(context, 40),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F6F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SvgPicture.asset("assets/icons/receipt.svg"),
                ),
                Spacer(),
                Text("Add voucher code"),
                const SizedBox(width: 10),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: kTextColor,
                )
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(context, 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: "Total:\n",
                    children: [
                      TextSpan(
                        text: "\$337.15",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(context, 190),
                  child: DefaultButton(
                    text: "Check Out",
                    press: () async {
                      final brand = createProductRecordData(
                        title: 'producttest2',
                        createdAt: getCurrentTimestamp,
                        createdBy: currentUserDocument!.ffRef,
                      );
                      final result = await ProductRecord.collection.add(brand);
                      print(result);
                      final r = await ProductRecord.getDocumentOnce(result);
                      print(r.title);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
