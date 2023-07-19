import 'package:flutter/widgets.dart';
import 'package:blueraymarket/screens/cart/cart_screen.dart';
import 'package:blueraymarket/screens/complete_profile/complete_profile_screen.dart';
import 'package:blueraymarket/screens/details/details_screen.dart';
import 'package:blueraymarket/screens/forgot_password/forgot_password_screen.dart';
import 'package:blueraymarket/screens/home/home_screen.dart';
import 'package:blueraymarket/screens/login_success/login_success_screen.dart';
import 'package:blueraymarket/screens/otp/otp_screen.dart';
import 'package:blueraymarket/screens/profile/profile_screen.dart';
import 'package:blueraymarket/screens/sign_in/sign_in_screen.dart';
import 'package:blueraymarket/screens/splash/splash_screen.dart';

import '../../auth/firebase_user_provider.dart';
import '../../screens/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  DetailsScreen.routeName: (context) => DetailsScreen(),
  CartScreen.routeName: (context) => CartScreen(),
  ProfileScreen.routeName: (context) => ProfileScreen(),
};

class AppStateNotifier extends ChangeNotifier {
  FirebaseUserProvider? initialUser;
  FirebaseUserProvider? user;

  bool notifyOnAuthChange = true;

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
}
