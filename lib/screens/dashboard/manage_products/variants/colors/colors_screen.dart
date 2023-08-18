import 'dart:async';

import 'package:blueraymarket/backend/backend.dart';
import 'package:blueraymarket/backend/schema/brand/brand_record.dart';
import 'package:blueraymarket/backend/schema/color/color_record.dart';
import 'package:blueraymarket/components/default_button.dart';
import 'package:blueraymarket/tools/color_picker.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../../../../components/form_error.dart';
import '../../../../../components/variant/color/color_manage.dart';
import '../../../../../helper/keyboard.dart';
import '../../../../../tools/nav/theme.dart';
import '../../../../../tools/util.dart';

import 'package:cached_network_image/cached_network_image.dart';

class ColorsScreen extends StatefulWidget {
  const ColorsScreen({super.key});

  @override
  State<ColorsScreen> createState() => _ColorsScreenState();
}

class _ColorsScreenState extends State<ColorsScreen> {
  final _formKey = GlobalKey<FormState>();

  final List<String?> errors = [];
  final _textFieldControllerColor = TextEditingController();

  final FocusNode focusNodeColor = FocusNode();

  FocusNode _focusNode = FocusNode();

  SizeConfig sizeConfig = SizeConfig();
  late Stream<List<ColorRecord>>? stream;

  String search = '';
  @override
  void initState() {
    super.initState();
    stream = queryColorsRecord();
  }

  Color? selectedColor;
  bool selectColor = false;
  @override
  void dispose() {
    super.dispose();
    focusNodeColor.dispose();
    _focusNode.dispose();

    _textFieldControllerColor.dispose();
  }

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
        height: sizeConfig.screenHeight / 2,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              vertical: getProportionateScreenHeight(context, 20),
              horizontal: getProportionateScreenWidth(context, 20)),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        child: CustomTextField(
                          textFieldController: _textFieldControllerColor,
                          focusNode: focusNodeColor,
                          labelText: 'Color Code',
                          hintText: "Enter Color code",
                          onChanged: (value) {
                            if (value!.isNotEmpty) {
                              removeError(error: "This field is required");
                            }
                            if (value.length > 3) {
                              removeError(error: "At least 3 characters");
                            }
                            return null;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              addError(error: "This field is required");
                              return "";
                            }
                            if (value.length < 3) {
                              addError(error: "At least 3 characters");
                              return "";
                            }
                            return null;
                          },
                        ),
                      ),
                      FormError(errors: errors),
                    ],
                  )),
              SizedBox(
                height: getProportionateScreenHeight(context, 20),
              ),
              Container(
                width: getProportionateScreenWidth(context, 150),
                height: getProportionateScreenHeight(context, 50),
                child: DefaultButton(
                    press: () async {
                      print(selectedColor);
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        enableDrag: false,
                        context: context,
                        builder: (bottomSheetContext) {
                          return Padding(
                            padding:
                                MediaQuery.of(bottomSheetContext).viewInsets,
                            child: CustomColorPicker(
                              context: bottomSheetContext,
                              onChange: (color) {
                                print(color);
                                setState(() {
                                  selectedColor = color;
                                });
                              },
                            ),
                          );
                        },
                      ).then((value) => setState(() {}));
                    },
                    text: 'PickUp a color'),
              ),
              SizedBox(
                height: getProportionateScreenHeight(context, 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (selectColor)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Please pick a color",
                        style: MyTheme.of(context).bodyMedium.override(
                            color: MyTheme.of(context).error,
                            fontFamily: 'Roboto'),
                      ),
                    ),
                ],
              ),
              SizedBox(
                height: getProportionateScreenHeight(context, 20),
              ),
              Container(
                width: getProportionateScreenWidth(context, 120),
                height: getProportionateScreenHeight(context, 50),
                child: DefaultButton(
                    isLoading: isLoading,
                    press: () async {
                      if (selectedColor == null) {
                        setState(() {
                          selectColor = true;
                        });
                      } else {
                        setState(() {
                          selectColor = false;
                        });
                      }
                      if (_formKey.currentState!.validate() &&
                          selectedColor != null) {
                        setState(() {
                          isLoading = true;
                        });
                        _formKey.currentState!.save();
                        KeyboardUtil.hideKeyboard(context);
                        FocusManager.instance.primaryFocus?.unfocus();
                        print(selectedColor.runtimeType);
                        try {
                          final color = createColorRecordData(
                              colorName: _textFieldControllerColor.text,
                              colorCode: selectedColor);

                          await ColorRecord.collection.add(color);
                          setState(() {
                            isLoading = false;

                            _textFieldControllerColor.clear();
                            selectColor = false;
                            selectedColor = null;
                          });
                        } catch (e) {
                          print(e.toString());
                        }
                        ScaffoldMessenger.of(_context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'You added a color item with success!',
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
                  height: getProportionateScreenHeight(context, 150),
                  child: listItemsComponent(context, _context))
            ],
          ),
        ),
      ),
    );
  }

  Widget listItemsComponent(BuildContext context, BuildContext _context) {
    return StreamBuilder<List<ColorRecord>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingIndicator(context);
          }
          if (snapshot.data!.isEmpty) {
            return listEmpty("Color", context);
          }
          final colors = snapshot.data;

          return ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: colors!.length,
              itemBuilder: (context, index) {
                final colorItem = colors[index];
                return Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: getProportionateScreenHeight(context, 10),
                      horizontal: getProportionateScreenWidth(context, 10)),
                  child: Container(
                    width: getProportionateScreenHeight(context, 100),
                    height: getProportionateScreenWidth(context, 40),
                    decoration: BoxDecoration(
                      color: MyTheme.of(context).primaryBackground,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                color: colorItem.colorCode,
                              ),
                              SizedBox(
                                width: getProportionateScreenWidth(context, 10),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Color name : ${colorItem.colorName as String}",
                                    style: MyTheme.of(context)
                                        .labelLarge
                                        .override(
                                            fontSize: 15, fontFamily: 'Roboto'),
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(
                                        context, 3),
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
                                    child: ColorManage(
                                      colorId: colorItem.reference,
                                      context: _context,
                                    ),
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
        });
  }
}
