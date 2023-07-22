import 'package:blueraymarket/tools/size_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  // static _MyAppState of(BuildContext context) =>
  //     context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  final authUserSub = authenticatedUserStream.listen((_) {});
  late Stream<FirebaseUserProvider> userStream;
  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  SizeConfig sizeConfig = SizeConfig();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sizeConfig.init(context);
    });

    _appStateNotifier = AppStateNotifier();
    _router = createRouter(_appStateNotifier);
    userStream = firebaseUserProviderStream()
      ..listen((user) => _appStateNotifier.update(user));

    Future.delayed(
      Duration(seconds: 3),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  @override
  void dispose() {
    authUserSub.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: theme(),
      routerConfig: _router,
    );
  }
}


//   
