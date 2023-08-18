import 'package:blueraymarket/screens/home/home_screen.dart';
import 'package:blueraymarket/tools/nav/routes.dart';
import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:flutter/material.dart';
import 'package:blueraymarket/tools/app_state.dart';
import 'package:blueraymarket/components/custom_surfix_icon.dart';
import 'package:blueraymarket/components/form_error.dart';
import 'package:blueraymarket/helper/keyboard.dart';
import 'package:blueraymarket/screens/forgot_password/forgot_password_screen.dart';
import 'package:blueraymarket/screens/login_success/login_success_screen.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';

import '../../../auth/credentials.dart';
import '../../../components/default_button.dart';
import '../../../components/socal_card.dart';
import '../../../tools/constants.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final AppState appState = AppState();
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool? remember = false;
  final List<String?> errors = [];
  bool isLoading = false;
  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildEmailFormField(),
            SizedBox(height: getProportionateScreenHeight(context, 30)),
            buildPasswordFormField(),
            SizedBox(height: getProportionateScreenHeight(context, 30)),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushNamed(
                      context, ForgotPasswordScreen.routeName),
                  child: Text(
                    "Forgot Password",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
            FormError(errors: errors),
            SizedBox(height: getProportionateScreenHeight(context, 20)),
            Container(
              width: getProportionateScreenWidth(context, 150),
              height: getProportionateScreenHeight(context, 50),
              child: DefaultButton(
                text: "Sign in",
                isLoading: isLoading,
                press: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    _formKey.currentState!.save();
                    // if all are valid then go to success screen
                    KeyboardUtil.hideKeyboard(context);
                    GoRouter.of(context).prepareAuthEvent();
                    print(context.mounted);
                    final user = await signInWithEmail(
                      context,
                      email!,
                      password!,
                    );
                    if (user == null) return;
                    context.goNamedAuth('NavBarPage', context.mounted,
                        extra: <String, dynamic>{
                          kTransitionInfoKey: TransitionInfo(
                              hasTransition: true,
                              duration: kAnimationDuration,
                              transitionType:
                                  PageTransitionType.rightToLeftWithFade)
                        });
                  }
                },
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(context, 20)),
            Container(
              width: getProportionateScreenWidth(context, 100),
              height: getProportionateScreenHeight(context, 50),
              child: DefaultButton(
                text: "Skip",
                bgColor: Colors.white,
                textColor: MyTheme.of(context).primary,
                press: () {
                  context.pushNamed('NavBarPage', extra: <String, dynamic>{
                    kTransitionInfoKey: TransitionInfo(
                        hasTransition: true,
                        duration: kAnimationDuration,
                        transitionType: PageTransitionType.rightToLeftWithFade)
                  });
                },
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(context, 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SocalCard(
                  icon: "assets/icons/google-icon.svg",
                  press: () {},
                ),
                SocalCard(
                  icon: "assets/icons/facebook-2.svg",
                  press: () {},
                ),
                SocalCard(
                  icon: "assets/icons/twitter.svg",
                  press: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 5) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
