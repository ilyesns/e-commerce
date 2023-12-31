import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../tools/app_state.dart';
import '../../../tools/nav/theme.dart';
import '../../../tools/size_config.dart';
import '../../home/components/search_field.dart';

class CategoryHeader extends StatelessWidget {
  CategoryHeader({
    required this.title,
    Key? key,
  }) : super(key: key);
  late String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: MyTheme.of(context).secondaryBackground,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(
              getProportionateScreenWidth(context, 10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                      width: getProportionateScreenWidth(context, 240),
                      height: getProportionateScreenHeight(context, 40),
                      child: SearchField(
                          controller: TextEditingController(text: title),
                          disable: true,
                          onChanged: (string) {},
                          hintText: "Search on Blue Ray")),
                ),
                SizedBox(
                  width: 7,
                ),
                InkWell(
                  onTap: () => context.pushNamed('CartPage'),
                  child: Badge(
                    offset: Offset(8, -3),
                    label: Text('${AppState().cart.length}'),
                    textColor: Colors.white,
                    backgroundColor: MyTheme.of(context).primary,
                    child: SvgPicture.asset(
                      'assets/icons/Cart Icon.svg', // grid-2
                      color: MyTheme.of(context).primaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.sizeOf(context).width,
            height: getProportionateScreenHeight(context, 40),
            color: MyTheme.of(context).primary,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(context, 30)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      child: Text(
                        'For Ordering Call +974 50 38 06 40',
                        style: MyTheme.of(context)
                            .titleMedium
                            .copyWith(color: MyTheme.of(context).alternate),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
