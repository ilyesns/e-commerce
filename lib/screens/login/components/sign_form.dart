import 'package:blueraymarket/screens/home/home_screen.dart';
import 'package:blueraymarket/tools/internationalization.dart';
import 'package:blueraymarket/tools/nav/routes.dart';
import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import '../../../tools/util.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final AppState appState = AppState();
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  final _textFieldControllerEmail = TextEditingController();
  final _textFieldControllerPassword = TextEditingController();

  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodePassword = FocusNode();

  bool isHidden = true;
  final List<String?> errorsPassword = [];
  final List<String?> errorsEmail = [];

  bool isLoading = false;
  void addError({String? error, required List<String?> list}) {
    if (!list.contains(error))
      setState(() {
        list.add(error!);
      });
  }

  void removeError({String? error, required List<String?> list}) {
    if (list.contains(error))
      setState(() {
        list.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: CustomTextField(
                suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
                textFieldController: _textFieldControllerEmail,
                focusNode: focusNodeEmail,
                labelText: 'Email',
                hintText: "Enter Your Email",
                onChanged: (value) {
                  if (value != null && value.isNotEmpty) {
                    removeError(
                        error: "This field is required", list: errorsEmail);
                  }
                  if (emailRegex.hasMatch(value!)) {
                    removeError(
                        error: "Please enter a valid email", list: errorsEmail);
                    return "";
                  }
                  return null;
                },
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    addError(
                        error: "This field is required", list: errorsEmail);
                    return "";
                  }
                  if (!emailRegex.hasMatch(value!)) {
                    addError(
                        error: "Please enter a valid email", list: errorsEmail);
                    return "";
                  }
                  return null;
                },
              ),
            ),
            FormError(errors: errorsEmail),
            SizedBox(height: getProportionateScreenHeight(context, 30)),
            Container(
              child: CustomTextField(
                obscureText: isHidden,
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      isHidden = !isHidden;
                    });
                  },
                  child: CustomSurffixIcon(
                      svgIcon: isHidden
                          ? 'assets/icons/eye.svg'
                          : 'assets/icons/eye-slash.svg'),
                ),
                textFieldController: _textFieldControllerPassword,
                focusNode: focusNodePassword,
                labelText: 'Password',
                hintText: "Enter Your Password",
                onChanged: (value) {
                  if (value != null && value.isNotEmpty) {
                    removeError(
                        error: "This field is required", list: errorsPassword);
                  }
                  if (value != null && value.length > 3) {
                    removeError(
                        error: "At least 3 characters", list: errorsPassword);
                  }
                  return null;
                },
                validator: (value) {
                  if (value != null && value!.isEmpty) {
                    addError(
                        error: "This field is required", list: errorsPassword);
                    return "";
                  }

                  return null;
                },
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(context, 30)),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushNamed(
                      context, ForgotPasswordScreen.routeName),
                  child: Text(
                    MyLocalizations.of(context)
                        .getText('D9zP6'), // Forget Password
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
            FormError(errors: errorsPassword),
            SizedBox(height: getProportionateScreenHeight(context, 20)),
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: getProportionateScreenHeight(context, 50),
              child: DefaultButton(
                text: MyLocalizations.of(context).getText('A2bX7'), // "Sign in"
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
                      _textFieldControllerEmail.text!,
                      _textFieldControllerPassword.text!,
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
              height: getProportionateScreenHeight(context, 50),
              child: DefaultButton(
                text: MyLocalizations.of(context).getText('E5yQ8'),
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
              children: [
                Expanded(
                    child: Container(
                  width: 100,
                  height: 1,
                  color: MyTheme.of(context).primary,
                )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(MyLocalizations.of(context).getText('F4wR7')),
                ),
                Expanded(
                    child: Container(
                  width: 100,
                  height: 1,
                  color: MyTheme.of(context).primary,
                )),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(context, 20)),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: getProportionateScreenWidth(context, 150),
                      height: getProportionateScreenHeight(context, 40),
                      color: Color.fromARGB(255, 23, 128, 214),
                      child: Row(
                        children: [
                          SocalCard(
                            icon: "assets/icons/google-icon.svg",
                            press: () {},
                          ),
                          Text(
                            'Sign in with Google',
                            style: MyTheme.of(context).bodyLarge.copyWith(
                                fontFamily: 'Outfit',
                                fontSize: 12,
                                color: MyTheme.of(context).alternate),
                          ),
                          SizedBox(
                            width: 5,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: getProportionateScreenWidth(context, 150),
                      height: getProportionateScreenHeight(context, 40),
                      color: Color.fromARGB(255, 4, 81, 145),
                      child: Row(
                        children: [
                          SocalCard(
                            icon: "assets/icons/facebook-2.svg",
                            press: () {},
                          ),
                          Text(
                            MyLocalizations.of(context).getText('F2vS9'),
                            style: MyTheme.of(context).bodyLarge.copyWith(
                                fontFamily: 'Outfit',
                                fontSize: 12,
                                color: MyTheme.of(context).secondaryReverse),
                          ),
                          SizedBox(
                            width: 5,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: getProportionateScreenWidth(context, 150),
                  height: getProportionateScreenHeight(context, 40),
                  color: MyTheme.of(context).reverse,
                  child: Row(
                    children: [
                      SocalCard(
                        icon: "assets/icons/Phone.svg",
                        press: () {},
                      ),
                      Text(
                        MyLocalizations.of(context).getText('P5hN7'),
                        style: MyTheme.of(context).bodyLarge.copyWith(
                            fontFamily: 'Outfit',
                            fontSize: 13,
                            color: MyTheme.of(context).secondaryReverse),
                      ),
                      SizedBox(
                        width: 5,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
