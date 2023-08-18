import 'package:blueraymarket/tools/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../tools/nav/theme.dart';

class ManageItem extends StatelessWidget {
  ManageItem({super.key, this.onPress, this.pathSvg, this.nameItem});
  late void Function()? onPress;
  late String? pathSvg;
  late String? nameItem;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: MyTheme.of(context).primaryBackground,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    width: 50,
                    height: 50,
                    pathSvg!,
                    color: MyTheme.of(context).primary,
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    nameItem!.truncateText(11),
                    style: MyTheme.of(context).labelLarge,
                  ),
                  SvgPicture.asset(
                    width: 20,
                    height: 20,
                    'assets/icons/arrow_right.svg',
                    color: MyTheme.of(context).primaryText,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
