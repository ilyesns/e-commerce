import 'package:blueraymarket/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:blueraymarket/tools/app_state.dart';
import 'package:blueraymarket/components/custom_surfix_icon.dart';
import 'package:blueraymarket/components/form_error.dart';
import 'package:blueraymarket/helper/keyboard.dart';
import 'package:blueraymarket/screens/forgot_password/forgot_password_screen.dart';
import 'package:blueraymarket/screens/login_success/login_success_screen.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/credentials.dart';
import '../../../components/default_button.dart';
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
            width: 200,
            height: 100,
            child: DefaultButton(
              text: "Sign in",
              press: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // if all are valid then go to success screen
                  KeyboardUtil.hideKeyboard(context);
                  //  Navigator.pushNamed(context, LoginSuccessScreen.routeName);

                  final user = await signInWithEmail(
                    context,
                    email!,
                    password!,
                  );
                  if (user != null) {
                    print("succes auth $user");
                    context.go('HomePage');
                  } else {
                    print("failed auth");
                  }
                }
              },
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(context, 20)),
          Container(
            width: 200,
            height: 100,
            child: DefaultButton(
              text: "Skip",
              bgColor: Colors.white,
              press: () {
                context.pushNamed('HomePage');
              },
            ),
          )
        ],
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
