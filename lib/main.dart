import 'package:blueraymarket/backend/cache/hive_box.dart';
import 'package:blueraymarket/tools/animations.dart';
import 'package:blueraymarket/tools/internationalization.dart';
import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:blueraymarket/tools/nav/routes.dart';

import 'auth/auth_util.dart';
import 'auth/firebase_user_provider.dart';
import 'screens/categories/categories_screen.dart';
import 'screens/favorites/favorites_screen.dart';
import 'screens/cart/cart_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'tools/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(SubCategoryHiveAdapter());
  Hive.registerAdapter(ProductHiveAdapter());
  Hive.registerAdapter(CategoryHiveAdapter());
  Hive.registerAdapter(DiscountHiveAdapter());
  Hive.registerAdapter(DocumentReferenceHiveAdapter());
  AppState appState = AppState();
  appState.initialize();
  MyTheme.initialize();

  runApp(ChangeNotifierProvider(create: (context) => appState, child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static _MyAppState? myAppState;

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
  Locale? _locale;

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
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

  void setLocale(String language) {
    setState(() => _locale = createLocale(language));
  }

  @override
  void dispose() {
    Hive.box<ProductHive>('subcategories').close();
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
      localizationsDelegates: [
        MyLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
        Locale('fr'),
      ],
    );
  }
}

class NavBarPage extends StatefulWidget {
  NavBarPage({Key? key, this.initialPage, this.page}) : super(key: key);

  final String? initialPage;
  final Widget? page;

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

/// This is the private State class that goes with NavBarPage.
class _NavBarPageState extends State<NavBarPage> {
  String _currentPageName = 'HomePage';
  late Widget? _currentPage;
  late int totalNotifications;

  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;
  }

  @override
  void dispose() {
    super.dispose();
    clearSubcategoryBox();
    clearDiscountsBox();
  }

  Color getIconColor(BuildContext context, int index, int currentIndex) {
    final selectedColor = MyTheme.of(context).primary;
    final unselectedColor = MyTheme.of(context).grayDark;

    return index == currentIndex ? selectedColor : unselectedColor;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      'HomePage': HomeScreen(),
      'CategoriesPage': CategoriesScreen(),
      'FavoritePage': FavoritesScreen(),
      'ProfilePage': ProfileScreen()
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);

    return Scaffold(
      body: _currentPage ?? tabs[_currentPageName],
      bottomNavigationBar: BottomNavigationBar(
        useLegacyColorScheme: false,
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        selectedLabelStyle: MyTheme.of(context).labelMedium.copyWith(
              color: MyTheme.of(context).primary,
              fontFamily: 'Open Sans',
            ),
        unselectedLabelStyle: MyTheme.of(context).labelMedium.copyWith(
              color: MyTheme.of(context).accent2,
              fontFamily: 'Open Sans',
            ),
        currentIndex: currentIndex,
        elevation: 0,
        onTap: (i) => setState(() {
          _currentPage = null;
          _currentPageName = tabs.keys.toList()[i];
        }),
        backgroundColor: MyTheme.of(context).secondaryBackground,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedIconTheme: IconThemeData(
          color: MyTheme.of(context).primary,
        ),
        unselectedIconTheme: IconThemeData(
          color: MyTheme.of(context).grayDark,
        ),
        unselectedItemColor: MyTheme.of(context).grayDark,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/icons/Shop Icon.svg",
                color: getIconColor(context, 0, currentIndex)),
            tooltip: '',
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset("assets/icons/category.svg",
                color: getIconColor(context, 1, currentIndex)),
            label: "Categories",
            tooltip: '',
          ),
          BottomNavigationBarItem(
            label: "Favorites",
            icon: SvgPicture.asset("assets/icons/Heart Icon.svg",
                color: getIconColor(context, 2, currentIndex)),
            tooltip: '',
          ),
          BottomNavigationBarItem(
            label: "Account",
            icon: SvgPicture.asset("assets/icons/User Icon.svg",
                color: getIconColor(context, 3, currentIndex)),
            tooltip: '',
          ),
        ],
      ),
    );
  }
}
