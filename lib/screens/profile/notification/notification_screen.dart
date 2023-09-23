import 'package:blueraymarket/tools/app_state.dart';
import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../tools/size_config.dart';
import 'components/header.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.watch<AppState>();
    return Scaffold(
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late bool promotionsAndDiscounts;
  late bool newProductArrivals;
  late bool flashSales;
  late bool limitedTimeOffers;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    promotionsAndDiscounts = true;
    newProductArrivals = true;
    flashSales = true;
    limitedTimeOffers = true;
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AppState>();
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SafeArea(
          child: CustomAppBar(
            title: 'Notifications',
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: getProportionateScreenHeight(context, 20),
                ),
                Text(
                  'Notification Preferences',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenHeight(context, 20),
                ),
                buildSwitchTile(
                  'Promotions and Discounts',
                  promotionsAndDiscounts,
                  (value) {
                    setState(() {
                      promotionsAndDiscounts = value;
                      print(promotionsAndDiscounts);
                    });
                  },
                ),
                buildSwitchTile(
                  'New Product Arrivals',
                  newProductArrivals,
                  (value) {
                    setState(() {
                      newProductArrivals = value;
                    });
                  },
                ),
                buildSwitchTile(
                  'Flash Sales',
                  flashSales,
                  (value) {
                    setState(() {
                      flashSales = value;
                    });
                  },
                ),
                buildSwitchTile(
                  'Limited-Time Offers',
                  limitedTimeOffers,
                  (value) {
                    setState(() {
                      limitedTimeOffers = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSwitchTile(
      String title, bool value, ValueChanged<bool> onChanged) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(title),
          trailing: Switch(
            activeColor: MyTheme.of(context).primary,
            value: value,
            onChanged: onChanged,
          ),
        ),
        Divider(
          thickness: 1, // Adjust the thickness as needed
        ),
      ],
    );
  }
}
