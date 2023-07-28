import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:blueraymarket/tools/nav/routes.dart';

import 'auth/auth_util.dart';
import 'auth/firebase_user_provider.dart';
import 'tools/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MyTheme.initialize();
  AppState appState = AppState();
  appState.initialize();
  runApp(ChangeNotifierProvider(create: (context) => appState, child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  final authUserSub = authenticatedUserStream.listen((_) {});
  late Stream<FirebaseUserProvider> userStream;
  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  ThemeMode _themeMode = MyTheme.themeMode;

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

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
        MyTheme.saveThemeMode(mode);
      });

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
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}


//   
