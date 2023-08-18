import 'dart:async';

import 'package:blueraymarket/backend/backend.dart';
import 'package:blueraymarket/backend/schema/discount/discount_record.dart';
import 'package:blueraymarket/backend/schema/feature/feature_record.dart';
import 'package:blueraymarket/components/default_button.dart';
import 'package:blueraymarket/components/discount_manage/discount_manage.dart';
import 'package:blueraymarket/components/variant/feature/feature_manage.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../../../../components/form_error.dart';
import '../../../../../helper/keyboard.dart';
import '../../../../../tools/nav/theme.dart';

import 'package:cached_network_image/cached_network_image.dart';

import '../../../../../tools/util.dart';

class FeaturesScreen extends StatefulWidget {
  const FeaturesScreen({super.key});

  @override
  State<FeaturesScreen> createState() => _FeaturesScreenState();
}

class _FeaturesScreenState extends State<FeaturesScreen> {
  final List<String?> errorsName = [];
  final List<String?> errorsGeometry = [];
  final List<String?> errorsWeight = [];
  final List<String?> errorsType = [];

  final _textFieldControllerFeatureName = TextEditingController();
  final _textFieldControllerFeatureGeometry = TextEditingController();
  final _textFieldControllerFeatureWeight = TextEditingController();
  final _textFieldControllerFeatureType = TextEditingController();

  final FocusNode focusNodeFeatureName = FocusNode();
  final FocusNode focusNodeFeatureGeometry = FocusNode();
  final FocusNode focusNodeFeatureWeight = FocusNode();
  final FocusNode focusNodeFeatureType = FocusNode();

  FocusNode _focusNode = FocusNode();

  SizeConfig sizeConfig = SizeConfig();
  late Stream<List<FeatureRecord>> stream;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    stream = queryFeaturesRecord();
  }

  @override
  void dispose() {
    super.dispose();
    focusNodeFeatureName.dispose();
    focusNodeFeatureWeight.dispose();
    focusNodeFeatureGeometry.dispose();
    _focusNode.dispose();
    focusNodeFeatureType.dispose();
    _textFieldControllerFeatureName.dispose();
    _textFieldControllerFeatureWeight.dispose();
    _textFieldControllerFeatureGeometry.dispose();
    _textFieldControllerFeatureType.dispose();
  }

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

  ScrollController scrollController = ScrollController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final BuildContext _context = context;
    sizeConfig.init(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_focusNode),
      child: Container(
        width: sizeConfig.screenWidth,
        height: getProportionateScreenHeight(context, 600),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
              vertical: getProportionateScreenHeight(context, 20),
              horizontal: getProportionateScreenWidth(context, 20)),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FormComponent(),
              SizedBox(
                height: getProportionateScreenHeight(context, 20),
              ),
              Container(
                width: getProportionateScreenWidth(context, 120),
                height: getProportionateScreenHeight(context, 50),
                child: DefaultButton(
                    isLoading: isLoading,
                    press: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        KeyboardUtil.hideKeyboard(context);
                        FocusManager.instance.primaryFocus?.unfocus();
                        setState(() {
                          isLoading = true;
                        });

                        final feature = createFeatureRecordData(
                          name: _textFieldControllerFeatureName.text,
                          geometry: _textFieldControllerFeatureGeometry.text,
                          weight: _textFieldControllerFeatureWeight.text,
                          type: _textFieldControllerFeatureType.text,
                        );
                        await FeatureRecord.collection.add(feature);
                        setState(() {
                          isLoading = false;

                          _textFieldControllerFeatureName.clear();
                          _textFieldControllerFeatureWeight.clear();
                          _textFieldControllerFeatureGeometry.clear();
                          _textFieldControllerFeatureType.clear();
                        });
                        ScaffoldMessenger.of(_context).showSnackBar(
                          SnackBar(
                            backgroundColor: MyTheme.of(context).alternate,
                            content: Text(
                              'You added a feature item with success!',
                              style: MyTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Roboto',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: MyTheme.of(context).primary),
                              textAlign: TextAlign.center,
                            ),
                            duration: Duration(
                                seconds:
                                    3), // Set the duration for the SnackBar
                          ),
                        );
                      }
                    },
                    text: 'Create'),
              ),
              SizedBox(
                height: getProportionateScreenHeight(context, 20),
              ),
              Container(
                  width: sizeConfig.screenWidth,
                  height: getProportionateScreenHeight(context, 200),
                  child: ListItemsComponent(context, _context)),
            ],
          ),
        ),
      ),
    );
  }

  Padding ListItemsComponent(BuildContext context, BuildContext _context) {
    return Padding(
      padding: EdgeInsets.only(top: getProportionateScreenHeight(context, 20)),
      child: StreamBuilder<List<FeatureRecord>>(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return loadingIndicator(context);
            }
            if (snapshot.data!.isEmpty) {
              return listEmpty("Features", context);
            }
            final features = snapshot.data!;

            return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(
                    top: getProportionateScreenHeight(context, 20)),
                shrinkWrap: true,
                itemCount: features.length,
                itemBuilder: (context, index) {
                  final featureItem = features[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: getProportionateScreenHeight(context, 10),
                        horizontal: getProportionateScreenWidth(context, 10)),
                    child: Container(
                      width: getProportionateScreenWidth(context, 200),
                      decoration: BoxDecoration(
                        color: MyTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Name: ${featureItem.name as String}'
                                          .truncateText(15),
                                      style: MyTheme.of(context)
                                          .labelLarge
                                          .override(
                                              fontSize: 15,
                                              fontFamily: 'Roboto'),
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(
                                          context, 3),
                                    ),
                                    Text(
                                      'Type: ${featureItem.type!.truncateText(15)}',
                                      style: MyTheme.of(context)
                                          .labelLarge
                                          .override(
                                              fontSize: 15,
                                              fontFamily: 'Roboto'),
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(
                                          context, 3),
                                    ),
                                    Text(
                                      'Weight: ${featureItem.weight}'
                                          .truncateText(15),
                                      style: MyTheme.of(context)
                                          .labelLarge
                                          .override(
                                              fontSize: 15,
                                              fontFamily: 'Roboto'),
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(
                                          context, 3),
                                    ),
                                    Text(
                                      'Geometry: ${featureItem.geometry}'
                                          .truncateText(15),
                                      style: MyTheme.of(context)
                                          .labelLarge
                                          .override(
                                              fontSize: 15,
                                              fontFamily: 'Roboto'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () async {
                                await showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  enableDrag: true,
                                  context: context,
                                  builder: (bottomSheetContext) {
                                    return Padding(
                                      padding: MediaQuery.of(bottomSheetContext)
                                          .viewInsets,
                                      child: FeatureManage(
                                          featureId: featureItem.reference,
                                          context: context),
                                    );
                                  },
                                ).then((value) => setState(() {}));
                              },
                              child: Container(
                                width: 20,
                                height: 20,
                                child: SvgPicture.asset(
                                  'assets/icons/edit.svg',
                                  color: MyTheme.of(context).primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }

  Form FormComponent() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              child: CustomTextField(
                textFieldController: _textFieldControllerFeatureName,
                focusNode: focusNodeFeatureName,
                labelText: 'Feature Name',
                hintText: "Enter features name",
                onChanged: (value) {
                  if (value!.isNotEmpty) {
                    removeError(
                        error: "This field is required", list: errorsName);
                  }
                  if (value.length > 3) {
                    removeError(
                        error: "At least 3 characters", list: errorsName);
                  }
                  return null;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    addError(error: "This field is required", list: errorsName);
                    return "";
                  }
                  if (value.length < 3) {
                    addError(error: "At least 3 characters", list: errorsName);
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
            Container(
              child: CustomTextField(
                textFieldController: _textFieldControllerFeatureGeometry,
                focusNode: focusNodeFeatureGeometry,
                labelText: 'Feature Geometry',
                hintText: "Enter feature geometry",
                onChanged: (value) {
                  if (value!.isNotEmpty) {
                    removeError(
                        error: "This field is required", list: errorsGeometry);
                  }

                  return null;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    addError(
                        error: "This field is required", list: errorsGeometry);
                    return "";
                  }

                  return null;
                },
              ),
            ),
            FormError(errors: errorsGeometry),
            SizedBox(
              height: getProportionateScreenHeight(context, 20),
            ),
            Container(
              child: CustomTextField(
                textFieldController: _textFieldControllerFeatureWeight,
                focusNode: focusNodeFeatureWeight,
                labelText: 'Feature Weight',
                hintText: "Enter feature weight",
                onChanged: (value) {
                  if (value!.isNotEmpty) {
                    removeError(
                        error: "This field is required", list: errorsWeight);
                  }

                  return null;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    addError(
                        error: "This field is required", list: errorsWeight);
                    return "";
                  }

                  return null;
                },
              ),
            ),
            FormError(errors: errorsWeight),
            SizedBox(
              height: getProportionateScreenHeight(context, 20),
            ),
            Container(
              child: CustomTextField(
                textFieldController: _textFieldControllerFeatureType,
                focusNode: focusNodeFeatureType,
                labelText: 'Feature Type',
                hintText: "Enter feature Type",
                onChanged: (value) {
                  if (value!.isNotEmpty) {
                    removeError(
                        error: "This field is required", list: errorsType);
                  }

                  return null;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    addError(error: "This field is required", list: errorsType);
                    return "";
                  }

                  return null;
                },
              ),
            ),
            FormError(errors: errorsType),
          ],
        ));
  }
}
