import 'package:blueraymarket/auth/auth_util.dart';
import 'package:blueraymarket/auth/firebase_user_provider.dart';
import 'package:blueraymarket/backend/schema/user/user_record.dart';
import 'package:blueraymarket/tools/nav/routes.dart';
import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:flutter/material.dart';
import 'package:blueraymarket/screens/cart/cart_screen.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../home/components/search_field.dart';

class ListProductsHeader extends StatefulWidget {
  ListProductsHeader(
      {Key? key, required this.subname, this.onTap, this.switchGrid = true})
      : super(key: key);
  final String? subname;
  late void Function()? onTap;
  bool switchGrid;
  @override
  State<ListProductsHeader> createState() => _ListProductsHeaderState();
}

class _ListProductsHeaderState extends State<ListProductsHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: MyTheme.of(context).secondaryBackground,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: getProportionateScreenHeight(context, 10),
          horizontal: getProportionateScreenWidth(context, 7),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: getProportionateScreenHeight(context, 5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      context.pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: SvgPicture.asset(
                        'assets/icons/arrow-left.svg', // grid-2
                        width: 30,
                        color: MyTheme.of(context).grayDark,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                        height: getProportionateScreenHeight(context, 40),
                        child: SearchField(
                            initValue: widget.subname,
                            disable: true,
                            onChanged: (string) {},
                            hintText: "Search bar")),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: getProportionateScreenHeight(context, 10),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Products',
                    style: MyTheme.of(context)
                        .titleSmall
                        .copyWith(color: MyTheme.of(context).primary),
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: widget.onTap,
                      child: SvgPicture.asset(
                        widget.switchGrid
                            ? 'assets/icons/grid.svg'
                            : 'assets/icons/category.svg',
                        color: MyTheme.of(context).primaryText,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 1,
                      height: getProportionateScreenHeight(context, 15),
                      color: Colors.black,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: InkWell(
                        onTap: () {},
                        child: Text(
                          'Filter',
                          style: MyTheme.of(context).labelLarge,
                        ),
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
