import 'package:another_flushbar/flushbar.dart';
import 'package:blueraymarket/auth/firebase_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../auth/auth_util.dart';
import '../../../../backend/schema/user/user_record.dart';
import '../../../../components/default_button.dart';
import '../../../../components/form_error.dart';
import '../../../../tools/constants.dart';
import '../../../../tools/nav/routes.dart';
import '../../../../tools/nav/theme.dart';
import '../../../../tools/size_config.dart';
import '../../../../tools/util.dart';
import '../../components/profile_menu.dart';
import '../components/logo_header.dart';

class BaseInfosScreen extends StatefulWidget {
  @override
  State<BaseInfosScreen> createState() => _BaseInfosScreenState();
}

class _BaseInfosScreenState extends State<BaseInfosScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Body()),
    );
  }
}

class Body extends StatefulWidget {
  Body();
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();

  final List<String?> errors = [];

  final List<String?> errorsName = [];
  final List<String?> errorsBirthday = [];
  final List<String?> errorsPhone = [];
  final List<String?> errorsGender = [];

  final _textFieldControllerUserName =
      TextEditingController(text: currentUserDisplayName);
  final _textFieldControllerEmail =
      TextEditingController(text: currentUserEmail);
  final _textFieldControllerGender =
      TextEditingController(text: currentUserGender);
  final _textFieldControllerBirthday =
      TextEditingController(text: dateTimeFormat('yMMMd', currentUserBirthday));
  final _textFieldControllerPhoneNumber =
      TextEditingController(text: currentPhoneNumber);

  final FocusNode focusNodeUserName = FocusNode();
  final FocusNode focusNodePhoneNumber = FocusNode();
  final FocusNode focusNodeAddress = FocusNode();

  bool isLoading = false;
  DateTime? birthdary;

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
    return Column(
      children: [
        Expanded(
            child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(children: [
                  LogoHeader(
                    title: 'Base information',
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenHeight(context, 20)),
                    child: Column(
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                child: CustomTextField(
                                  textFieldController:
                                      _textFieldControllerUserName,
                                  focusNode: focusNodeUserName,
                                  labelText: 'Full Name',
                                  hintText: "Enter full name",
                                  onChanged: (value) {
                                    if (value!.isNotEmpty) {
                                      removeError(
                                          error: "This field is required",
                                          list: errorsName);
                                    }
                                    if (value.length > 3) {
                                      removeError(
                                          error: "At least 3 characters",
                                          list: errorsName);
                                    }
                                    return null;
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      addError(
                                          error: "This field is required",
                                          list: errorsName);
                                      return "";
                                    }
                                    if (value.length < 3) {
                                      addError(
                                          error: "At least 3 characters",
                                          list: errorsName);
                                      return "";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              FormError(errors: errorsName),
                              SizedBox(
                                height:
                                    getProportionateScreenHeight(context, 20),
                              ),
                              Container(
                                child: CustomTextField(
                                  readOnly: true,
                                  textFieldController:
                                      _textFieldControllerEmail,
                                  focusNode: focusNodePhoneNumber,
                                  labelText: 'Email',
                                  hintText: "Email",
                                  keyboardType: TextInputType.number,
                                  onTap: () {
                                    Flushbar(
                                      backgroundColor:
                                          MyTheme.of(context).error,
                                      message: "You can not change your email",
                                      icon: Icon(
                                        Icons.error,
                                        size: 28.0,
                                        color: Colors.white,
                                      ),
                                      duration: Duration(seconds: 3),
                                      leftBarIndicatorColor:
                                          MyTheme.of(context).accent4,
                                    )..show(context);
                                  },
                                ),
                              ),
                              SizedBox(
                                height:
                                    getProportionateScreenHeight(context, 20),
                              ),
                              Container(
                                child: CustomDropDownMenu(
                                  value: currentUserGender.isEmpty ||
                                          (currentUserGender != 'Male' &&
                                              currentUserGender != 'Female')
                                      ? null
                                      : currentUserGender,
                                  hint: 'Please select a gender',
                                  items: ['Male', 'Female'],
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      addError(
                                          error: "This field is required",
                                          list: errorsGender);
                                      return "";
                                    }

                                    return null;
                                  },
                                  onSaved: (value) {
                                    _textFieldControllerGender.text = value!;
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height:
                                    getProportionateScreenHeight(context, 20),
                              ),
                              Container(
                                child: CustomTextField(
                                  readOnly: true,
                                  textFieldController:
                                      _textFieldControllerBirthday,
                                  focusNode: focusNodeUserName,
                                  labelText: 'Birthday',
                                  hintText: "Enter your birthday",
                                  onChanged: (value) {
                                    if (value!.isNotEmpty) {
                                      removeError(
                                          error: "This field is required",
                                          list: errorsBirthday);
                                    }

                                    return null;
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      addError(
                                          error: "This field is required",
                                          list: errorsBirthday);
                                      return "";
                                    }

                                    return null;
                                  },
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1950),
                                        //DateTime.now() - not to allow to choose before today.
                                        lastDate: DateTime(2100));

                                    if (pickedDate != null) {
                                      print(
                                          pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                      String formattedDate = dateTimeFormat(
                                          'yyyy-MM-dd', pickedDate);
                                      print(
                                          formattedDate); //formatted date output using intl package =>  2021-03-16
                                      setState(() {
                                        _textFieldControllerBirthday.text =
                                            formattedDate;
                                        birthdary = pickedDate;
                                        //set output date to TextField value.
                                      });
                                    } else {}
                                  },
                                ),
                              ),
                              FormError(errors: errorsBirthday),
                              SizedBox(
                                height:
                                    getProportionateScreenHeight(context, 20),
                              ),
                              Container(
                                child: CustomTextField(
                                  readOnly: true,
                                  textFieldController:
                                      _textFieldControllerPhoneNumber,
                                  focusNode: focusNodePhoneNumber,
                                  labelText: 'Phone Number',
                                  hintText:
                                      "Number phone etc +216 123456789...",
                                  keyboardType: TextInputType.number,
                                  onTap: () {
                                    Flushbar(
                                      backgroundColor:
                                          MyTheme.of(context).error,
                                      message:
                                          "You can not change your Number Phone from here",
                                      icon: Icon(
                                        Icons.error,
                                        size: 28.0,
                                        color: Colors.white,
                                      ),
                                      duration: Duration(seconds: 3),
                                      leftBarIndicatorColor:
                                          MyTheme.of(context).accent4,
                                    )..show(context);
                                  },
                                ),
                              ),
                              SizedBox(
                                height:
                                    getProportionateScreenHeight(context, 20),
                              ),
                              SizedBox(
                                  height: getProportionateScreenHeight(
                                      context, 40)),
                              Container(
                                width: MediaQuery.sizeOf(context).width,
                                height:
                                    getProportionateScreenHeight(context, 60),
                                child: DefaultButton(
                                  isLoading: isLoading,
                                  text: "Save",
                                  press: () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      final user = createUserRecordData(
                                          name:
                                              _textFieldControllerUserName.text,
                                          gender:
                                              _textFieldControllerGender.text,
                                          birthday: birthdary);

                                      await UserRecord.collection
                                          .doc(currentUser!.user!.uid!)
                                          .update(user);

                                      Flushbar(
                                        backgroundColor:
                                            MyTheme.of(context).success,
                                        message: "You've updated your account!",
                                        icon: Icon(
                                          Icons.check,
                                          size: 28.0,
                                          color: Colors.white,
                                        ),
                                        duration: Duration(seconds: 3),
                                        leftBarIndicatorColor:
                                            MyTheme.of(context).accent4,
                                      )..show(context);
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ])))
      ],
    );
  }
}
