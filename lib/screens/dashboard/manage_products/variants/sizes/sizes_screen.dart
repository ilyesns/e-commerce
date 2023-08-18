import 'dart:async';

import 'package:blueraymarket/backend/backend.dart';
import 'package:blueraymarket/backend/schema/color/color_record.dart';
import 'package:blueraymarket/backend/schema/size/size_record.dart';
import 'package:blueraymarket/components/default_button.dart';
import 'package:blueraymarket/tools/color_picker.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../components/form_error.dart';
import '../../../../../components/variant/color/color_manage.dart';
import '../../../../../components/variant/size/size_manage.dart';
import '../../../../../helper/keyboard.dart';
import '../../../../../tools/nav/theme.dart';
import '../../../../../tools/util.dart';

class SizesScreen extends StatefulWidget {
  const SizesScreen({super.key});

  @override
  State<SizesScreen> createState() => _SizesScreenState();
}

class _SizesScreenState extends State<SizesScreen> {
  final _formKey = GlobalKey<FormState>();

  final List<String?> errors = [];
  final _textFieldControllerColor = TextEditingController();

  final FocusNode focusNodeSize = FocusNode();

  FocusNode _focusNode = FocusNode();

  SizeConfig sizeConfig = SizeConfig();
  late Stream<List<SizeRecord>>? stream;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    stream = querySizesRecord();
  }

  @override
  void dispose() {
    super.dispose();
    focusNodeSize.dispose();
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
                          focusNode: focusNodeSize,
                          labelText: 'Size Code',
                          hintText: "Enter Size code",
                          onChanged: (value) {
                            if (value!.isNotEmpty) {
                              removeError(error: "This field is required");
                            }

                            return null;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              addError(error: "This field is required");
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
                width: getProportionateScreenWidth(context, 120),
                height: getProportionateScreenHeight(context, 50),
                child: DefaultButton(
                    isLoading: isLoading,
                    press: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        _formKey.currentState!.save();
                        KeyboardUtil.hideKeyboard(context);
                        FocusManager.instance.primaryFocus?.unfocus();
                        try {
                          final size = createSizeRecordData(
                            sizeName: _textFieldControllerColor.text,
                          );

                          await SizeRecord.collection.add(size);
                          setState(() {
                            isLoading = false;

                            _textFieldControllerColor.clear();
                          });
                        } catch (e) {
                          print(e.toString());
                        }
                        ScaffoldMessenger.of(_context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'You added a size item with success!',
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
                  height: getProportionateScreenHeight(context, 100),
                  child: listItemsComponent(context, _context))
            ],
          ),
        ),
      ),
    );
  }

  Widget listItemsComponent(BuildContext context, BuildContext _context) {
    return StreamBuilder<List<SizeRecord>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingIndicator(context);
          }
          if (snapshot.data!.isEmpty) {
            return listEmpty("Size", context);
          }
          final sizes = snapshot.data;

          return ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: sizes!.length,
              itemBuilder: (context, index) {
                final sizeItem = sizes[index];
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
                              Text(
                                "Size code : ${sizeItem.sizeCode as String}",
                                style: MyTheme.of(context).labelLarge.override(
                                    fontSize: 15, fontFamily: 'Roboto'),
                              ),
                              SizedBox(
                                height:
                                    getProportionateScreenHeight(context, 3),
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
                                    child: SizeManage(
                                      sizeId: sizeItem.reference,
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
