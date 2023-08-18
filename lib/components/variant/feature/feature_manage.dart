import 'package:blueraymarket/backend/schema/category/category_record.dart';
import 'package:blueraymarket/backend/schema/discount/discount_record.dart';
import 'package:blueraymarket/backend/schema/feature/feature_record.dart';
import 'package:blueraymarket/components/default_button.dart';
import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:dotted_border/dotted_border.dart';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../../../helper/keyboard.dart';
import '../../../tools/size_config.dart';
import '../../../tools/util.dart';
import '../../form_error.dart';

class FeatureManage extends StatefulWidget {
  FeatureManage({Key? key, required this.featureId, required this.context})
      : super(key: key);
  final BuildContext context;
  final DocumentReference featureId;

  @override
  _FeatureManageState createState() => _FeatureManageState();
}

class _FeatureManageState extends State<FeatureManage> {
  @override
  void initState() {
    super.initState();
    future = FeatureRecord.getDocumentOnce(widget.featureId);
  }

  final _formKey = GlobalKey<FormState>();
  FocusNode _focusNode = FocusNode();

  final List<String?> errorsName = [];
  final List<String?> errorsGeometry = [];
  final List<String?> errorsWeight = [];
  final List<String?> errorsType = [];

  TextEditingController? _textFieldControllerFeatureName;
  TextEditingController? _textFieldControllerFeatureGeometry;
  TextEditingController? _textFieldControllerFeatureWeight;
  TextEditingController? _textFieldControllerFeatureType;

  final FocusNode focusNodeFeatureName = FocusNode();
  final FocusNode focusNodeFeatureGeometry = FocusNode();
  final FocusNode focusNodeFeatureWeight = FocusNode();
  final FocusNode focusNodeFeatureType = FocusNode();

  late Future<FeatureRecord> future;

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
  void dispose() {
    super.dispose();
    focusNodeFeatureName.dispose();
    focusNodeFeatureWeight.dispose();
    focusNodeFeatureGeometry.dispose();
    _focusNode.dispose();
    focusNodeFeatureType.dispose();
    _textFieldControllerFeatureName!.dispose();
    _textFieldControllerFeatureWeight!.dispose();
    _textFieldControllerFeatureGeometry!.dispose();
    _textFieldControllerFeatureType!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5.0,
          sigmaY: 4.0,
        ),
        child: FutureBuilder<FeatureRecord>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return loadingIndicator(context);
              }
              final featureItem = snapshot.data!;
              if (_textFieldControllerFeatureName == null)
                _textFieldControllerFeatureName =
                    TextEditingController(text: featureItem.name!);
              if (_textFieldControllerFeatureGeometry == null)
                _textFieldControllerFeatureGeometry =
                    TextEditingController(text: featureItem.geometry!);
              if (_textFieldControllerFeatureType == null)
                _textFieldControllerFeatureType =
                    TextEditingController(text: featureItem.type);

              if (_textFieldControllerFeatureWeight == null)
                _textFieldControllerFeatureWeight =
                    TextEditingController(text: featureItem.weight);

              return Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0.0),
                    bottomRight: Radius.circular(0.0),
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                  shape: BoxShape.rectangle,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsetsDirectional.all(
                              getProportionateScreenWidth(context, 12)),
                          child: Container(
                            width: double.infinity,
                            constraints: BoxConstraints(
                              maxWidth: 670.0,
                            ),
                            decoration: BoxDecoration(
                              color: MyTheme.of(context).secondaryBackground,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 3.0,
                                  color: Color(0x33000000),
                                  offset: Offset(0.0, 1.0),
                                )
                              ],
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                color: MyTheme.of(context).primary,
                                width: 1.0,
                              ),
                            ),
                            child: SingleChildScrollView(
                              physics: NeverScrollableScrollPhysics(),
                              child: Padding(
                                padding: EdgeInsets.all(
                                    getProportionateScreenHeight(context, 20)),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              AwesomeDialog(
                                                  context: context,
                                                  dialogType: DialogType
                                                      .warning,
                                                  animType: AnimType.rightSlide,
                                                  headerAnimationLoop: false,
                                                  title: 'Delete Feature Item',
                                                  desc:
                                                      'You want delete this item! \n Note: this item may be related by another product items',
                                                  btnOkOnPress: () async {
                                                    featureItem.reference
                                                        .delete();

                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(
                                                            widget.context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        backgroundColor:
                                                            MyTheme.of(context)
                                                                .alternate,
                                                        content: Text(
                                                          'You deleted a feature item with success!',
                                                          style: MyTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: MyTheme.of(
                                                                          context)
                                                                      .primary),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        duration: Duration(
                                                            seconds:
                                                                3), // Set the duration for the SnackBar
                                                      ),
                                                    );
                                                  },
                                                  btnCancelOnPress: () {},
                                                  btnOkIcon: Icons.cancel,
                                                  btnOkColor:
                                                      MyTheme.of(context)
                                                          .primary,
                                                  descTextStyle:
                                                      MyTheme.of(context)
                                                          .bodyMedium
                                                          .override(
                                                              fontFamily:
                                                                  'Roboto',
                                                              fontSize: 17))
                                                ..show();
                                            },
                                            child: Icon(
                                              Icons.delete,
                                              color: MyTheme.of(context).error,
                                              size: 30,
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(
                                          context, 20),
                                    ),
                                    Form(
                                        key: _formKey,
                                        child: Column(
                                          children: [
                                            Container(
                                              child: CustomTextField(
                                                textFieldController:
                                                    _textFieldControllerFeatureName,
                                                focusNode: focusNodeFeatureName,
                                                labelText: 'Feature Name',
                                                hintText: "Enter features name",
                                                onChanged: (value) {
                                                  if (value!.isNotEmpty) {
                                                    removeError(
                                                        error:
                                                            "This field is required",
                                                        list: errorsName);
                                                  }
                                                  if (value.length > 3) {
                                                    removeError(
                                                        error:
                                                            "At least 3 characters",
                                                        list: errorsName);
                                                  }
                                                  return null;
                                                },
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    addError(
                                                        error:
                                                            "This field is required",
                                                        list: errorsName);
                                                    return "";
                                                  }
                                                  if (value.length < 3) {
                                                    addError(
                                                        error:
                                                            "At least 3 characters",
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
                                                  getProportionateScreenHeight(
                                                      context, 20),
                                            ),
                                            Container(
                                              child: CustomTextField(
                                                textFieldController:
                                                    _textFieldControllerFeatureGeometry,
                                                focusNode:
                                                    focusNodeFeatureGeometry,
                                                labelText: 'Feature Geometry',
                                                hintText:
                                                    "Enter feature geometry",
                                                onChanged: (value) {
                                                  if (value!.isNotEmpty) {
                                                    removeError(
                                                        error:
                                                            "This field is required",
                                                        list: errorsGeometry);
                                                  }

                                                  return null;
                                                },
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    addError(
                                                        error:
                                                            "This field is required",
                                                        list: errorsGeometry);
                                                    return "";
                                                  }

                                                  return null;
                                                },
                                              ),
                                            ),
                                            FormError(errors: errorsGeometry),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      context, 20),
                                            ),
                                            Container(
                                              child: CustomTextField(
                                                textFieldController:
                                                    _textFieldControllerFeatureWeight,
                                                focusNode:
                                                    focusNodeFeatureWeight,
                                                labelText: 'Feature Weight',
                                                hintText:
                                                    "Enter feature weight",
                                                onChanged: (value) {
                                                  if (value!.isNotEmpty) {
                                                    removeError(
                                                        error:
                                                            "This field is required",
                                                        list: errorsWeight);
                                                  }

                                                  return null;
                                                },
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    addError(
                                                        error:
                                                            "This field is required",
                                                        list: errorsWeight);
                                                    return "";
                                                  }

                                                  return null;
                                                },
                                              ),
                                            ),
                                            FormError(errors: errorsWeight),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      context, 20),
                                            ),
                                            Container(
                                              child: CustomTextField(
                                                textFieldController:
                                                    _textFieldControllerFeatureType,
                                                focusNode: focusNodeFeatureType,
                                                labelText: 'Feature Type',
                                                hintText: "Enter feature Type",
                                                onChanged: (value) {
                                                  if (value!.isNotEmpty) {
                                                    removeError(
                                                        error:
                                                            "This field is required",
                                                        list: errorsType);
                                                  }

                                                  return null;
                                                },
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    addError(
                                                        error:
                                                            "This field is required",
                                                        list: errorsType);
                                                    return "";
                                                  }

                                                  return null;
                                                },
                                              ),
                                            ),
                                            FormError(errors: errorsType),
                                          ],
                                        )),
                                    SizedBox(
                                      height: getProportionateScreenHeight(
                                          context, 20),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            width: getProportionateScreenWidth(
                                                context, 120),
                                            height:
                                                getProportionateScreenHeight(
                                                    context, 50),
                                            child: DefaultButton(
                                                bgColor: MyTheme.of(context)
                                                    .alternate,
                                                textColor:
                                                    MyTheme.of(context).primary,
                                                press: () async {
                                                  Navigator.pop(context);
                                                },
                                                text: 'Cancel')),
                                        Container(
                                          width: getProportionateScreenWidth(
                                              context, 150),
                                          height: getProportionateScreenHeight(
                                              context, 50),
                                          child: DefaultButton(
                                              isLoading: isLoading,
                                              press: () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  _formKey.currentState!.save();
                                                  KeyboardUtil.hideKeyboard(
                                                      context);
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                  setState(() {
                                                    isLoading = true;
                                                  });

                                                  final feature =
                                                      createFeatureRecordData(
                                                    name:
                                                        _textFieldControllerFeatureName!
                                                            .text,
                                                    geometry:
                                                        _textFieldControllerFeatureGeometry!
                                                            .text,
                                                    weight:
                                                        _textFieldControllerFeatureWeight!
                                                            .text,
                                                    type:
                                                        _textFieldControllerFeatureType!
                                                            .text,
                                                  );
                                                  await widget.featureId
                                                      .update(feature);
                                                  setState(() {
                                                    isLoading = false;

                                                    _textFieldControllerFeatureName!
                                                        .clear();
                                                    _textFieldControllerFeatureWeight!
                                                        .clear();
                                                    _textFieldControllerFeatureGeometry!
                                                        .clear();
                                                    _textFieldControllerFeatureType!
                                                        .clear();
                                                  });
                                                } else {
                                                  return;
                                                }
                                                Navigator.pop(context);
                                              },
                                              text: 'Update Feature'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              );
            }));
  }
}
