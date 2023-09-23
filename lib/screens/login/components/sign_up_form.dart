import 'package:blueraymarket/tools/internationalization.dart';
import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:flutter/material.dart';
import 'package:blueraymarket/components/custom_surfix_icon.dart';
import 'package:blueraymarket/components/default_button.dart';
import 'package:blueraymarket/components/form_error.dart';
import 'package:blueraymarket/screens/complete_profile/complete_profile_screen.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';

import '../../../auth/auth_util.dart';
import '../../../auth/credentials.dart';
import '../../../tools/constants.dart';
import '../../../tools/nav/routes.dart';
import '../../../tools/util.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final _textFieldControllerEmail = TextEditingController();
  final _textFieldControllerPassword = TextEditingController();
  final _textFieldControllerConfirmPassword = TextEditingController();

  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodePassword = FocusNode();
  final FocusNode focusNodeConfirmPassword = FocusNode();

  bool isHidden = true;
  bool isHiddenC = true;
  bool checkBox = false;
  final List<String?> errorsConfirmPassword = [];
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
                  if (value!.isNotEmpty) {
                    removeError(
                        error: "This field is required", list: errorsEmail);
                  }
                  if (emailRegex.hasMatch(value)) {
                    removeError(
                        error: "Please enter a valid email", list: errorsEmail);
                    return "";
                  }
                  return null;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    addError(
                        error: "This field is required", list: errorsEmail);
                    return "";
                  }
                  if (!emailRegex.hasMatch(value)) {
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
                  if (value!.isNotEmpty) {
                    removeError(
                        error: "This field is required", list: errorsPassword);
                  }
                  if (value.length >= 8) {
                    removeError(
                        error: "At least 8 characters", list: errorsPassword);
                  }
                  return null;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    addError(
                        error: "This field is required", list: errorsPassword);
                    return "";
                  }
                  if (value.length < 8) {
                    removeError(
                        error: "At least 8 characters", list: errorsPassword);
                  }

                  return null;
                },
              ),
            ),
            FormError(errors: errorsPassword),
            SizedBox(height: getProportionateScreenHeight(context, 30)),
            Container(
              child: CustomTextField(
                obscureText: isHiddenC,
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      isHiddenC = !isHiddenC;
                    });
                  },
                  child: CustomSurffixIcon(
                      svgIcon: isHiddenC
                          ? 'assets/icons/eye.svg'
                          : 'assets/icons/eye-slash.svg'),
                ),
                textFieldController: _textFieldControllerConfirmPassword,
                focusNode: focusNodeEmail,
                labelText: 'Confirm Password',
                hintText: "Re-Enter Your Password",
                onChanged: (value) {
                  if (value!.isNotEmpty) {
                    removeError(
                        error: "This field is required",
                        list: errorsConfirmPassword);
                  }

                  if (value == _textFieldControllerPassword.text) {
                    removeError(
                        error: "Passwords do not match.",
                        list: errorsConfirmPassword);
                    return "";
                  }
                  return null;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    addError(
                        error: "This field is required",
                        list: errorsConfirmPassword);
                    return "";
                  }

                  if (value != _textFieldControllerPassword.text) {
                    addError(
                        error: "Passwords do not match.",
                        list: errorsConfirmPassword);
                    return "";
                  }
                  return null;
                },
              ),
            ),
            FormError(errors: errorsConfirmPassword),
            SizedBox(height: getProportionateScreenHeight(context, 20)),
            Row(
              children: [
                Checkbox(
                    checkColor: MyTheme.of(context).alternate,
                    activeColor: MyTheme.of(context).primary,
                    value: checkBox,
                    onChanged: (value) {
                      setState(() {
                        checkBox = value!;
                      });
                    }),
                Row(
                  children: [
                    Text(
                      MyLocalizations.of(context).getText('A9gR1'),
                      style: MyTheme.of(context)
                          .bodyMedium
                          .copyWith(fontFamily: 'Outfit', fontSize: 12),
                    ),
                    Text(
                      MyLocalizations.of(context).getText('U4rA8'),
                      style: MyTheme.of(context).bodyMedium.copyWith(
                          fontFamily: 'Outfit',
                          fontSize: 12,
                          color: MyTheme.of(context).primary),
                    ),
                    Text(
                      MyLocalizations.of(context).getText('A3nD7'),
                      style: MyTheme.of(context)
                          .bodyMedium
                          .copyWith(fontFamily: 'Outfit', fontSize: 12),
                    ),
                    Text(
                      MyLocalizations.of(context).getText('P6lI2'),
                      style: MyTheme.of(context).bodyMedium.copyWith(
                          fontFamily: 'Outfit',
                          color: MyTheme.of(context).primary,
                          fontSize: 12),
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(context, 40)),
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: getProportionateScreenHeight(context, 50),
              child: DefaultButton(
                disable: !checkBox,
                isLoading: isLoading,
                text: MyLocalizations.of(context).getText('R7gI4'),
                press: () async {
                  if (!_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    _formKey.currentState!.save();
                    GoRouter.of(context).prepareAuthEvent();
                    final user = await createAccountWithEmail(
                      context,
                      _textFieldControllerEmail.text,
                      _textFieldControllerPassword.text,
                    );

                    if (user == null) {
                      return;
                    }

                    await sendEmailVerification();
                    context.goNamedAuth('CompleteProfile', context.mounted,
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
          ],
        ),
      ),
    );
  }
}
