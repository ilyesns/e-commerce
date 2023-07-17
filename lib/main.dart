import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/splash/splash_screen.dart';
import 'package:shop_app/tools/nav/routes.dart';

import 'tools/app_state.dart';
import 'tools/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppState appState = AppState();
  appState.initialize();
  runApp(ChangeNotifierProvider(create: (context) => appState, child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: theme(),
      // home: SplashScreen(),
      // We use routeName so that we dont need to remember the name
      initialRoute: SplashScreen.routeName,
      routes: routes,
    );
  }
}
