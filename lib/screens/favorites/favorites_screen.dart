import 'package:blueraymarket/tools/app_state.dart';
import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/body.dart';
import 'components/check_out_card.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.watch<AppState>();
    return Scaffold(
      body: Body(),
    );
  }
}
