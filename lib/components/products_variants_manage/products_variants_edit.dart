import 'package:blueraymarket/backend/backend.dart';
import 'package:blueraymarket/backend/schema/brand/brand_record.dart';
import 'package:blueraymarket/backend/schema/category/category_record.dart';
import 'package:blueraymarket/backend/schema/product/product_record.dart';
import 'package:blueraymarket/backend/schema/variant/variant_record.dart';
import 'package:blueraymarket/components/default_button.dart';
import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../backend/firebase_storage/storage.dart';
import '../../backend/schema/color/color_record.dart';
import '../../backend/schema/feature/feature_record.dart';
import '../../backend/schema/size/size_record.dart';
import '../../backend/schema/sub_category/sub_category_record.dart';
import '../../helper/keyboard.dart';
import '../../tools/delete_data.dart';
import '../../tools/size_config.dart';
import '../../tools/upload_data.dart';
import '../../tools/upload_file.dart';
import '../../tools/util.dart';
import '../form_error.dart';

import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ProductsVariantsEdit extends StatefulWidget {
  ProductsVariantsEdit(
      {Key? key, required this.variantId, required this.context})
      : super(key: key);
  final BuildContext context;
  final DocumentReference variantId;

  @override
  _ProductsVariantsEditState createState() => _ProductsVariantsEditState();
}

class _ProductsVariantsEditState extends State<ProductsVariantsEdit> {
  @override
  void initState() {
    super.initState();
    future = VariantRecord.getDocumentOnce(widget.variantId);
    futureColor = queryColorsRecordOnce();
    futureSize = querySizesRecordOnce();
    futureFeature = queryFeaturesRecordOnce();
  }

  bool isDataUploading = false;
  List<String> uploadedFileUrl = [];
  late UploadedFile uploadedLocalFile;

  final _formKey = GlobalKey<FormState>();

  late Future<VariantRecord> future;

  late DocumentReference? colorRef;
  late DocumentReference? sizeRef;
  late DocumentReference? featureRef;

  late Future<List<ColorRecord>> futureColor;
  late Future<List<SizeRecord>> futureSize;
  late Future<List<FeatureRecord>> futureFeature;

  bool isLoading = false;
  bool isLoadingDeleted = false;
  bool isEmpty = false;
  TextEditingController? _textEditingController;

  final List<String?> errors = [];

  final FocusNode focusNode = FocusNode();
  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
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

  Color? selectColor;
  String? selectSize;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5.0,
          sigmaY: 4.0,
        ),
        child: FutureBuilder<VariantRecord>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return loadingIndicator(context);
              }
              final variantItem = snapshot.data!;
              if (_textEditingController == null)
                _textEditingController = TextEditingController(
                    text: variantItem.quantity.toString());
              if (selectColor == null) selectColor = variantItem.colorCode;
              if (uploadedFileUrl.isEmpty && selectSize == null)
                uploadedFileUrl = variantItem.images!.map((e) => e).toList();
              if (selectSize == null) selectSize = variantItem.sizeCode;

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
                                                  title: 'Delete Variant Item',
                                                  desc:
                                                      'You want delete this item! \n Note: this item may be related by another product items',
                                                  btnOkOnPress: () async {
                                                    if (variantItem
                                                        .images!.isNotEmpty) {
                                                      variantItem.images!
                                                          .forEach((image) {
                                                        deleteFileFRomFirebase(
                                                            image);
                                                      });
                                                    }

                                                    variantItem.reference
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
                                                          'You deleted a variant item with success!',
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
                                    if (uploadedFileUrl.isEmpty)
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: getProportionateScreenHeight(
                                                context, 20)),
                                        child: SizedBox(
                                          height: 115,
                                          width: 115,
                                          child: Stack(
                                            fit: StackFit.expand,
                                            clipBehavior: Clip.none,
                                            children: [
                                              Container(
                                                width: 120,
                                                height: 100,
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Image.asset(
                                                        'assets/images/upload_img.png',
                                                        width: 50,
                                                        height: 50,
                                                      ),
                                                      Text(
                                                        "Select an image",
                                                        style:
                                                            MyTheme.of(context)
                                                                .labelMedium,
                                                      )
                                                    ]),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (isEmpty)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              "Please upload an image",
                                              style: MyTheme.of(context)
                                                  .bodyMedium
                                                  .override(
                                                      color: MyTheme.of(context)
                                                          .error,
                                                      fontFamily: 'Roboto'),
                                            ),
                                          ),
                                      ],
                                    ),
                                    if (uploadedFileUrl.isNotEmpty)
                                      Container(
                                        width: getProportionateScreenWidth(
                                            context, 200),
                                        height: getProportionateScreenHeight(
                                            context, 80),
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: uploadedFileUrl.length,
                                          itemBuilder: (context, index) {
                                            final imageItem =
                                                uploadedFileUrl[index];

                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      getProportionateScreenWidth(
                                                          context, 5)),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    width: 60,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        InkWell(
                                                          onTap: () async {
                                                            setState(() {
                                                              isLoadingDeleted =
                                                                  true;
                                                            });
                                                            await deleteFileFRomFirebase(
                                                                imageItem);
                                                            setState(() {
                                                              isLoadingDeleted =
                                                                  false;
                                                              uploadedFileUrl
                                                                  .remove(
                                                                      imageItem);
                                                            });
                                                          },
                                                          child: Container(
                                                              width: 25,
                                                              height: 25,
                                                              child: isLoadingDeleted
                                                                  ? CircularProgressIndicator(
                                                                      color: MyTheme.of(
                                                                              context)
                                                                          .primary,
                                                                    )
                                                                  : Icon(
                                                                      Icons
                                                                          .delete,
                                                                      color: MyTheme.of(
                                                                              context)
                                                                          .error,
                                                                      size: 25,
                                                                    )),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: Image.network(
                                                                    imageItem)
                                                                .image),
                                                        border: Border.all(
                                                            color: MyTheme.of(
                                                                    context)
                                                                .primary)),
                                                    width: 60,
                                                    height: 60,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(
                                          context, 20),
                                    ),
                                    Container(
                                      width: getProportionateScreenWidth(
                                          context, 150),
                                      height: getProportionateScreenHeight(
                                          context, 40),
                                      child: DefaultButton(
                                        isLoading: isDataUploading,
                                        text: "Upload Image",
                                        press: () async {
                                          final selectedMedia =
                                              await selectMediaWithSourceBottomSheet(
                                            context: context,
                                            allowPhoto: true,
                                          );
                                          if (selectedMedia != null &&
                                              selectedMedia.every((m) =>
                                                  validateFileFormat(
                                                      m.storagePath,
                                                      context))) {
                                            setState(
                                                () => isDataUploading = true);
                                            var selectedUploadedFiles =
                                                <UploadedFile>[];
                                            var downloadUrls = <String>[];
                                            try {
                                              selectedUploadedFiles =
                                                  selectedMedia
                                                      .map((m) => UploadedFile(
                                                            name: m.storagePath
                                                                .split('/')
                                                                .last,
                                                            bytes: m.bytes,
                                                            height: m.dimensions
                                                                ?.height,
                                                            width: m.dimensions
                                                                ?.width,
                                                            blurHash:
                                                                m.blurHash,
                                                          ))
                                                      .toList();

                                              downloadUrls = (await Future.wait(
                                                selectedMedia.map(
                                                  (m) async => await uploadData(
                                                      m.storagePath, m.bytes),
                                                ),
                                              ))
                                                  .where((u) => u != null)
                                                  .map((u) => u!)
                                                  .toList();
                                            } finally {
                                              isDataUploading = false;
                                            }
                                            if (selectedUploadedFiles.length ==
                                                    selectedMedia.length &&
                                                downloadUrls.length ==
                                                    selectedMedia.length) {
                                              setState(() {
                                                uploadedLocalFile =
                                                    selectedUploadedFiles.first;
                                                uploadedFileUrl
                                                    .add(downloadUrls.first);
                                              });
                                            } else {
                                              setState(() {});
                                              return;
                                            }
                                          }
                                        },
                                      ),
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
                                                keyboardType:
                                                    TextInputType.number,
                                                textFieldController:
                                                    _textEditingController,
                                                focusNode: focusNode,
                                                labelText: 'Variant Quantity',
                                                hintText:
                                                    "Enter Variant Quantity",
                                                onChanged: (value) {
                                                  if (value!.isNotEmpty) {
                                                    removeError(
                                                      error:
                                                          "This field is required",
                                                    );
                                                  }

                                                  return null;
                                                },
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    addError(
                                                      error:
                                                          "This field is required",
                                                    );
                                                    return "";
                                                  }

                                                  return null;
                                                },
                                              ),
                                            ),
                                            FormError(errors: errors),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      context, 20),
                                            ),
                                            FutureBuilder<List<ColorRecord>>(
                                              future: futureColor,
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting)
                                                  loadingIndicator(context);
                                                if (snapshot.data == null)
                                                  return listEmpty(
                                                      "Colors", context);
                                                final colors = snapshot.data!;

                                                return Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: CustomDropDownMenu(
                                                    value: colors
                                                        .where((color) =>
                                                            color.colorCode ==
                                                            variantItem
                                                                .colorCode)
                                                        .first
                                                        .colorName,
                                                    hint: "Select a Color",
                                                    items: colors
                                                        .map((element) =>
                                                            element.colorName!)
                                                        .toList(),
                                                    validator: (value) {
                                                      if (value == null) {
                                                        return 'Please select a color.';
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (value) {
                                                      colorRef = colors
                                                          .where((color) =>
                                                              color.colorName ==
                                                              value)
                                                          .first
                                                          .ffRef;
                                                      selectColor = colors
                                                          .where((color) =>
                                                              color.colorName ==
                                                              value)
                                                          .first
                                                          .colorCode;
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      context, 20),
                                            ),
                                            FutureBuilder<List<SizeRecord>>(
                                              future: futureSize,
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting)
                                                  loadingIndicator(context);
                                                if (snapshot.data == null)
                                                  return listEmpty(
                                                      "Sizes", context);
                                                final sizes = snapshot.data!;

                                                return Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: CustomDropDownMenu(
                                                    value: variantItem.sizeCode,
                                                    hint: "Select a Size",
                                                    items: sizes
                                                        .map((element) =>
                                                            element.sizeCode!)
                                                        .toList(),
                                                    validator: (value) {
                                                      if (value == null) {
                                                        return 'Please select a size.';
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (value) {
                                                      sizeRef = sizes
                                                          .where((size) =>
                                                              size.sizeCode ==
                                                              value)
                                                          .first
                                                          .ffRef;
                                                      selectSize = value;
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
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
                                                setState(() {
                                                  isEmpty = true;
                                                });
                                                if (_formKey.currentState!
                                                        .validate() &&
                                                    uploadedFileUrl
                                                        .isNotEmpty) {
                                                  setState(() {
                                                    isLoading = true;
                                                    isEmpty = false;
                                                  });
                                                  _formKey.currentState!.save();
                                                  KeyboardUtil.hideKeyboard(
                                                      context);
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();
                                                  final ListBuilder<String>?
                                                      images =
                                                      ListBuilder<String>(
                                                          uploadedFileUrl);
                                                  final variant =
                                                      createVariantRecordData(
                                                    modifiedAt:
                                                        getCurrentTimestamp,
                                                    colorCode: selectColor,
                                                    sizeCode: selectSize,
                                                    idColor: colorRef,
                                                    idSize: sizeRef,
                                                    quantity: int.tryParse(
                                                        _textEditingController!
                                                            .text),
                                                    images: images,
                                                  );

                                                  widget.variantId
                                                      .update(variant);
                                                  setState(() {
                                                    isLoading = false;
                                                    _textEditingController!
                                                        .clear();
                                                    uploadedFileUrl = [];
                                                  });
                                                } else {
                                                  return;
                                                }
                                                Navigator.pop(context);
                                              },
                                              text: 'Update Variant'),
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
