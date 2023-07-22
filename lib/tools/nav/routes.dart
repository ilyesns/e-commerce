import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:blueraymarket/screens/cart/cart_screen.dart';
import 'package:blueraymarket/screens/complete_profile/complete_profile_screen.dart';
import 'package:blueraymarket/screens/details/details_screen.dart';
import 'package:blueraymarket/screens/forgot_password/forgot_password_screen.dart';
import 'package:blueraymarket/screens/home/home_screen.dart';
import 'package:blueraymarket/screens/login_success/login_success_screen.dart';
import 'package:blueraymarket/screens/otp/otp_screen.dart';
import 'package:blueraymarket/screens/profile/profile_screen.dart';
import 'package:blueraymarket/screens/login/login.dart';
import 'package:blueraymarket/screens/splash/splash_screen.dart';
import 'package:go_router/go_router.dart';

import '../../auth/auth_util.dart';
import '../../auth/firebase_user_provider.dart';
import '../../auth/firebase_user_provider.dart';
import 'serializer.dart';

const kTransitionInfoKey = '__transition_info__';

class AppStateNotifier extends ChangeNotifier {
  FirebaseUserProvider? initialUser;
  FirebaseUserProvider? user;
  bool showSplashImage = true;
  String? _redirectLocation;

  bool notifyOnAuthChange = true;

  bool get loading => user == null || showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;
  bool get currrentUserEmailVerif => currentUserEmailVerified;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(FirebaseUserProvider newUser) {
    initialUser ??= newUser;
    user = newUser;
    // Refresh the app on auth change unless explicitly marked otherwise.
    if (notifyOnAuthChange) {
      notifyListeners();
    }
    // Once again mark the notifier as needing to update on auth change
    // (in order to catch sign in / out events).
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    refreshListenable: appStateNotifier,
    errorBuilder: (context, _) =>
        appStateNotifier.loggedIn ? HomeScreen() : SplashScreen(),
    routes: [
      MyRoute(
        name: 'initialize',
        path: '/',
        builder: (context, state) =>
            appStateNotifier.loggedIn ? HomeScreen() : SplashScreen(),
        routes: [
          MyRoute(
            name: 'Login',
            path: 'login',
            builder: (context, state) => Login(),
          ),
          MyRoute(
            name: 'CompleteProfile',
            path: 'completeProfile',
            builder: (context, state) => CompleteProfileScreen(),
          ),
          MyRoute(
            name: 'HomePage',
            path: 'homePage',
            builder: (context, state) => HomeScreen(),
          ),
          MyRoute(
            name: 'ProductDetailsScreen',
            path: 'productDetailsScreen',
            builder: (context, state) => ProductDetailsScreen(),
          ),
          MyRoute(
            name: 'CartPage',
            path: 'cartPage',
            requireAuth: true,
            builder: (context, state) => CartScreen(),
          ),
        ].map((r) => r.toRoute(appStateNotifier)).toList(),
      ),
    ].map((r) => r.toRoute(appStateNotifier)).toList(),
  );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : goNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : pushNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier? get appState => AppStateNotifier();
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState!.hasRedirect() && !ignoreRedirect
          ? null
          : appState!.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) =>
      !ignoreRedirect && appState!.hasRedirect();
  void clearRedirectLocation() => appState!.clearRedirectLocation();
  void setRedirectLocationIfUnset(String location) =>
      appState!.updateNotifyOnAuthChange(false);
}

class MyRoute {
  const MyRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, Parameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        redirect: (context, state) {
          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            appStateNotifier.clearRedirectLocation();
            return redirectLocation;
          }

          if (requireAuth && !appStateNotifier.loggedIn) {
            appStateNotifier.setRedirectLocationIfUnset(state.location);
            return '/login';
          }
          return null;
        },
        pageBuilder: (context, state) {
          final Params = Parameters(state, asyncParams);
          final page = Params.hasFutures
              ? FutureBuilder(
                  future: Params.completeFutures(),
                  builder: (context, _) => builder(context, Params),
                )
              : builder(context, Params);
          final child = appStateNotifier.loading
              ? Container(
                  color: Colors.transparent,
                  child: Center(
                    child: Image.asset(
                      'assets/images/splash_1.png',
                      width: 150.0,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                )
              : page;

          return MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class Parameters {
  Parameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.extraMap.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, [
    bool isList = false,
    List<String>? collectionNamePath,
  ]) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(param, type, isList,
        collectionNamePath: collectionNamePath);
  }
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(queryParameters)
    ..addAll(extraMap);
}
