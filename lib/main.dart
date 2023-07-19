import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blueraymarket/screens/splash/splash_screen.dart';
import 'package:blueraymarket/tools/nav/routes.dart';

import 'auth/auth_util.dart';
import 'auth/firebase_user_provider.dart';
import 'backend/firebase/firebase_config.dart';
import 'tools/app_state.dart';
import 'tools/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  AppState appState = AppState();
  appState.initialize();
  runApp(ChangeNotifierProvider(create: (context) => appState, child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final authUserSub = authenticatedUserStream.listen((_) {});
  late Stream<FirebaseUserProvider> userStream;
  late AppStateNotifier _appStateNotifier;

  @override
  void initState() {
    _appStateNotifier = AppStateNotifier();
    userStream = firebaseUserProviderStream()
      ..listen((user) => _appStateNotifier.update(user));
    super.initState();
  }

  @override
  void dispose() {
    authUserSub.cancel();
    // TODO: implement dispose
    super.dispose();
  }

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


//   
