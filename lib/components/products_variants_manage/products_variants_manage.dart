import 'package:blueraymarket/backend/backend.dart';
import 'package:blueraymarket/backend/schema/brand/brand_record.dart';
import 'package:blueraymarket/backend/schema/category/category_record.dart';
import 'package:blueraymarket/backend/schema/color/color_record.dart';
import 'package:blueraymarket/backend/schema/discount/discount_record.dart';
import 'package:blueraymarket/backend/schema/feature/feature_record.dart';
import 'package:blueraymarket/backend/schema/product/product_record.dart';
import 'package:blueraymarket/backend/schema/size/size_record.dart';
import 'package:blueraymarket/backend/schema/variant/variant_record.dart';
import 'package:blueraymarket/components/default_button.dart';
import 'package:blueraymarket/components/products_variants_manage/products_variants_edit.dart';
import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:built_collection/built_collection.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_svg/svg.dart';

import '../../backend/firebase_storage/storage.dart';
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

class ProductsVariantsManage extends StatefulWidget {
  ProductsVariantsManage(
      {Key? key,
      required this.productId,
      required this.discountId,
      required this.context})
      : super(key: key);
  final BuildContext context;
  final DocumentReference productId;
  final DocumentReference discountId;

  @override
  _ProductsVariantsManageState createState() => _ProductsVariantsManageState();
}

class _ProductsVariantsManageState extends State<ProductsVariantsManage> {
  @override
  void initState() {
    super.initState();
    future = ProductRecord.getDocumentOnce(widget.productId);
    futureColor = queryColorsRecordOnce();
    futureSize = querySizesRecordOnce();
    futureFeature = queryFeaturesRecordOnce();
    streamVariant = queryVariantsRecord();
    futureDiscount = DiscountRecord.getDocumentOnce(widget.discountId);
  }

  bool isDataUploading = false;
  List<String> uploadedFileUrl = [];
  late UploadedFile uploadedLocalFile;

  final _formKey = GlobalKey<FormState>();

  late Future<ProductRecord> future;

  late Future<DiscountRecord> futureDiscount;

  late DocumentReference? colorRef;
  late DocumentReference? sizeRef;
  late DocumentReference? featureRef;

  late Future<List<ColorRecord>> futureColor;
  late Future<List<SizeRecord>> futureSize;
  late Future<List<FeatureRecord>> futureFeature;
  late Stream<List<VariantRecord>> streamVariant;

  bool isLoading = false;
  bool isLoadingDeleted = false;
  bool isEmpty = false;
  final TextEditingController _textEditingController = TextEditingController();

  final List<String?> errors = [];

  final FocusNode focusNode = FocusNode();

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
  void dispose() {
    super.dispose();
    focusNode.dispose();
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
        child: FutureBuilder<ProductRecord>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return loadingIndicator(context);
              }
              final productItem = snapshot.data!;

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
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                          padding: EdgeInsetsDirectional.all(
                              getProportionateScreenWidth(context, 12)),
                          child: Container(
                            width: double.infinity,
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
                                                            });
                                                            uploadedFileUrl
                                                                .remove(
                                                                    imageItem);
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
                                    Container(
                                      width: getProportionateScreenWidth(
                                          context, 250),
                                      height: getProportionateScreenHeight(
                                          context, 220),
                                      child:
                                          listItemsComponent(context, context),
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
                                                    createdAt:
                                                        getCurrentTimestamp,
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

                                                  await VariantRecord.createDoc(
                                                          widget.productId)
                                                      .set(variant);
                                                  setState(() {
                                                    isLoading = false;
                                                    _textEditingController
                                                        .clear();
                                                    uploadedFileUrl = [];
                                                  });
                                                } else {
                                                  return;
                                                }
                                                //Navigator.pop(context);
                                              },
                                              text: 'Add Variant'),
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

  Widget listItemsComponent(BuildContext context, BuildContext _context) {
    return StreamBuilder<List<VariantRecord>>(
        stream: streamVariant,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingIndicator(context);
          }
          if (snapshot.data!.isEmpty) {
            return listEmpty("Variants", context);
          }
          final variants = snapshot.data!;

          return ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: variants.length,
              itemBuilder: (context, index) {
                final variant = variants[index];
                return Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: getProportionateScreenHeight(context, 10),
                      horizontal: getProportionateScreenWidth(context, 10)),
                  child: Container(
                    width: getProportionateScreenHeight(context, 150),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () async {
                                  await showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    enableDrag: true,
                                    context: context,
                                    builder: (bottomSheetContext) {
                                      return Padding(
                                        padding:
                                            MediaQuery.of(bottomSheetContext)
                                                .viewInsets,
                                        child: ProductsVariantsEdit(
                                          context: _context,
                                          variantId: variant.reference,
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
                          SizedBox(
                            height: getProportionateScreenHeight(context, 10),
                          ),
                          Column(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                color: variant.colorCode,
                              ),
                              SizedBox(
                                width: getProportionateScreenWidth(context, 10),
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Quantity variant : ${variant.quantity}",
                                    style: MyTheme.of(context)
                                        .labelLarge
                                        .override(
                                            fontSize: 15, fontFamily: 'Roboto'),
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(
                                        context, 3),
                                  ),
                                  Text(
                                    "Size code : ${variant.sizeCode}",
                                    style: MyTheme.of(context)
                                        .labelLarge
                                        .override(
                                            fontSize: 15, fontFamily: 'Roboto'),
                                  ),
                                  SizedBox(
                                    height: getProportionateScreenHeight(
                                        context, 3),
                                  ),
                                  Container(
                                    width: getProportionateScreenWidth(
                                        context, 80),
                                    height: getProportionateScreenHeight(
                                        context, 50),
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: variant.images!.length,
                                      itemBuilder: (context, index) {
                                        final imageItem =
                                            variant.images![index];

                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  getProportionateScreenWidth(
                                                      context, 5)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: Image.network(
                                                                imageItem)
                                                            .image),
                                                    border: Border.all(
                                                        color:
                                                            MyTheme.of(context)
                                                                .primary)),
                                                width: 40,
                                                height: 40,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
