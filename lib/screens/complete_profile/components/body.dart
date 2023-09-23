import 'package:another_flushbar/flushbar.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:blueraymarket/tools/constants.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';

import '../../../auth/auth_util.dart';
import '../../../backend/firebase_storage/storage.dart';
import '../../../backend/schema/user/user_record.dart';
import '../../../components/default_button.dart';
import '../../../components/form_error.dart';
import '../../../tools/internationalization.dart';
import '../../../tools/nav/routes.dart';
import '../../../tools/nav/theme.dart';
import '../../../tools/upload_data.dart';
import '../../../tools/upload_file.dart';
import '../../../tools/util.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];

  final List<String?> errorsName = [];
  final List<String?> errorsPhone = [];
  final List<String?> errorsGender = [];
  final List<String?> errorsBirthday = [];

  final _textFieldControllerUserName = TextEditingController();
  final _textFieldControllerPhoneNumber = TextEditingController();
  final _textFieldControllerPrefix = TextEditingController();
  String gender = '';
  final _textFieldControllerBirthday = TextEditingController();

  final FocusNode focusNodeUserName = FocusNode();
  final FocusNode focusNodePrefix = FocusNode();
  final FocusNode focusNodePhoneNumber = FocusNode();
  final FocusNode focusNodeGender = FocusNode();
  final FocusNode focusNodeBirthday = FocusNode();

  bool isLoading = false;

  bool isDataUploading = false;

  late UploadedFile uploadedLocalFile;

  String uploadedFileUrl = '';

  bool _uploadImage = false;

  bool get uploadImage => _uploadImage;

  DateTime? birthdary;
  set uploadImage(b) => _uploadImage = b;
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

  List<String> numberPrefixes = [
    '+1', // United States, Canada, and several other countries in the Americas
    '+44', // United Kingdom
    '+33', // France
    '+49', // Germany
    '+81', // Japan
    '+86', // China
    '+91', // India
    '+61', // Australia
    '+7', // Russia
    '+55', // Brazil
    '+34', // Spain
    '+39', // Italy
    '+52', // Mexico
    '+65', // Singapore
    '+82', // South Korea
    '+64', // New Zealand
    '+31', // Netherlands
    '+41', // Switzerland
    '+46', // Sweden
    '+971', // United Arab Emirates
    '+966', // Saudi Arabia
    '+972', // Israel
    '+20', // Egypt
    '+234', // Nigeria
    '+27', // South Africa
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(context, 20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig().screenHeight * 0.03),
                Text(MyLocalizations.of(context).getText('C8pP6'),
                    style: headingStyle),
                Text(
                  MyLocalizations.of(context).getText('C5mY7'),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig().screenHeight * 0.06),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        child: CustomTextField(
                          textFieldController: _textFieldControllerUserName,
                          focusNode: focusNodeUserName,
                          labelText:
                              MyLocalizations.of(context).getText('F5lN8'),
                          hintText:
                              MyLocalizations.of(context).getText('E7rF1'),
                          onChanged: (value) {
                            if (value != null && value.isNotEmpty) {
                              removeError(
                                  error: MyLocalizations.of(context)
                                      .getText('T6sF4'),
                                  list: errorsName);
                            }
                            if (value != null && value.length > 3) {
                              removeError(
                                  error: MyLocalizations.of(context)
                                      .getText('A9tL2'),
                                  list: errorsName);
                            }
                            return null;
                          },
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              addError(
                                  error: MyLocalizations.of(context)
                                      .getText('T6sF4'),
                                  list: errorsName);
                              return "";
                            }
                            if (value != null && value.length < 3) {
                              addError(
                                  error: MyLocalizations.of(context)
                                      .getText('A9tL2'),
                                  list: errorsName);
                              return "";
                            }
                            return null;
                          },
                        ),
                      ),
                      FormError(errors: errorsName),
                      SizedBox(
                        height: getProportionateScreenHeight(context, 20),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: getProportionateScreenWidth(context, 100),
                            height: 80,
                            child: CustomDropDownMenu(
                              hint:
                                  MyLocalizations.of(context).getText('P5sP9'),
                              items: numberPrefixes,
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  addError(
                                      error: MyLocalizations.of(context)
                                          .getText('T6sF4'),
                                      list: errorsPhone);
                                  return "";
                                }

                                return null;
                              },
                              onChange: (value) {
                                _textFieldControllerPrefix.text = value!;
                              },
                            ),
                          ),
                          SizedBox(
                            width: getProportionateScreenWidth(context, 10),
                          ),
                          Expanded(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 80,
                              child: CustomTextField(
                                textFieldController:
                                    _textFieldControllerPhoneNumber,
                                focusNode: focusNodePhoneNumber,
                                labelText: MyLocalizations.of(context)
                                    .getText('P6hN8'),
                                hintText: MyLocalizations.of(context)
                                    .getText('N4mP7'),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  if (value!.isNotEmpty) {
                                    removeError(
                                        error: MyLocalizations.of(context)
                                            .getText('T6sF4'),
                                        list: errorsPhone);
                                  }

                                  return null;
                                },
                                validator: (value) {
                                  if (value != null && value.isEmpty) {
                                    addError(
                                        error: MyLocalizations.of(context)
                                            .getText('T6sF4'),
                                        list: errorsPhone);
                                    return "";
                                  }

                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      FormError(errors: errorsPhone),
                      SizedBox(
                        height: getProportionateScreenHeight(context, 20),
                      ),
                      Container(
                        child: CustomDropDownMenu(
                          hint: MyLocalizations.of(context).getText('P8sG5'),
                          items: [
                            MyLocalizations.of(context).getText('M4lE1'),
                            MyLocalizations.of(context).getText('F5mL2')
                          ],
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              addError(
                                  error: MyLocalizations.of(context)
                                      .getText('T6sF4'),
                                  list: errorsGender);
                              return "";
                            }

                            return null;
                          },
                          onChange: (value) {
                            gender = value!;
                            return null;
                          },
                        ),
                      ),
                      FormError(errors: errorsGender),
                      SizedBox(
                        height: getProportionateScreenHeight(context, 20),
                      ),
                      Container(
                        child: CustomTextField(
                          readOnly: true,
                          textFieldController: _textFieldControllerBirthday,
                          focusNode: focusNodeBirthday,
                          labelText:
                              MyLocalizations.of(context).getText('B7rT3'),
                          hintText:
                              MyLocalizations.of(context).getText('E8rY2'),
                          onChanged: (value) {
                            if (value!.isNotEmpty) {
                              removeError(
                                  error: MyLocalizations.of(context)
                                      .getText('T6sF4'),
                                  list: errorsBirthday);
                            }

                            return null;
                          },
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              addError(
                                  error: MyLocalizations.of(context)
                                      .getText('T6sF4'),
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
                              String formattedDate =
                                  dateTimeFormat('yyyy-MM-dd', pickedDate);
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
                          height: getProportionateScreenHeight(context, 40)),
                      Container(
                        height: getProportionateScreenHeight(context, 50),
                        child: DefaultButton(
                          isLoading: isLoading,
                          text: MyLocalizations.of(context).getText('C8nE1'),
                          press: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              final user = createUserRecordData(
                                  name: _textFieldControllerUserName.text,
                                  phoneNumber:
                                      '${_textFieldControllerPrefix.text} ${_textFieldControllerPhoneNumber.text}',
                                  gender: gender,
                                  birthday: birthdary,
                                  role: roleUser);
                              print(user);

                              currentUserReference!.update(user);

                              context.pushReplacementNamed('NavBarPage',
                                  extra: <String, dynamic>{
                                    kTransitionInfoKey: TransitionInfo(
                                        hasTransition: true,
                                        duration: kAnimationDuration,
                                        transitionType: PageTransitionType
                                            .rightToLeftWithFade)
                                  });

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
                SizedBox(height: getProportionateScreenHeight(context, 30)),
                Text(
                  MyLocalizations.of(context).getText('B4yC7'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
