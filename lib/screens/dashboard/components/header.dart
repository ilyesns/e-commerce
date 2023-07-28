import 'package:flutter/material.dart';

import '../../../auth/auth_util.dart';
import '../../../tools/constants.dart';
import '../../../tools/nav/theme.dart';
import '../../../tools/util.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Hello $currentUserDisplayName !',
              style:
                  headingStyle.copyWith(color: MyTheme.of(context).alternate),
            ),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  color: MyTheme.of(context).primaryBackground,
                  borderRadius: BorderRadius.circular(50)),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: CircleAvatar(
                  backgroundImage: currentUserPhoto.isEmpty
                      ? AssetImage(
                          "assets/images/Profile Image.png",
                        )
                      : Image(image: NetworkImage(currentUserPhoto)).image,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              "${dateTimeFormat('EEEE', getCurrentTimestamp).toUpperCase()}, ${dateTimeFormat('M/d H:mm', getCurrentTimestamp)} ",
              style: labelMediumStyle.copyWith(color: kDefaultIconLightColor),
            ),
          ],
        )
      ],
    );
  }
}
