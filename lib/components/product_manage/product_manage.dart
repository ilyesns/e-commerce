import 'package:blueraymarket/backend/backend.dart';
import 'package:blueraymarket/backend/schema/brand/brand_record.dart';
import 'package:blueraymarket/backend/schema/category/category_record.dart';
import 'package:blueraymarket/backend/schema/product/product_record.dart';
import 'package:blueraymarket/components/default_button.dart';
import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../backend/firebase_storage/storage.dart';
import '../../backend/schema/discount/discount_record.dart';
import '../../backend/schema/sub_category/sub_category_record.dart';
import '../../helper/keyboard.dart';
import '../../tools/custom_functions.dart';
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

class ProductManage extends StatefulWidget {
  ProductManage(
      {Key? key,
      required this.productId,
      required this.brandId,
      required this.subcategoryId,
      required this.context})
      : super(key: key);
  final BuildContext context;
  final DocumentReference productId;
  final DocumentReference brandId;
  final DocumentReference subcategoryId;

  @override
  _ProductManageState createState() => _ProductManageState();
}

class _ProductManageState extends State<ProductManage> {
  @override
  void initState() {
    super.initState();
    future = ProductRecord.getDocumentOnce(widget.productId);
    futureSubCat = querySubCategoriesRecordOnce();
    futureBrand = queryBrandsRecordOnce();
    focusNodeProductTitle = FocusNode();
    focusNodeProductDescription = FocusNode();
    focusNodeProductPrice = FocusNode();
  }

  bool isDataUploading = false;
  String uploadedFileUrl = '';
  late UploadedFile uploadedLocalFile;

  final _formKey = GlobalKey<FormState>();

  final List<String?> errorsTitle = [];
  final List<String?> errorsDesc = [];
  final List<String?> errorsPrice = [];

  FocusNode? focusNodeProductTitle;
  FocusNode? focusNodeProductDescription;
  FocusNode? focusNodeProductPrice;

  late Future<ProductRecord> future;

  late DocumentReference? brandRef;
  late DocumentReference? subcategoryRef;

  late Future<List<SubCategoryRecord>> futureSubCat;
  late Future<List<BrandRecord>> futureBrand;

  TextEditingController? productTitle;
  TextEditingController? productDescription;
  TextEditingController? productPrice;
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
    focusNodeProductTitle!.dispose();
    focusNodeProductDescription!.dispose();
    focusNodeProductPrice!.dispose();
  }

  String? selectBrand;
  String? selectSubCategory;

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
              if (productTitle == null)
                productTitle = TextEditingController(text: productItem.title);
              if (productPrice == null)
                productPrice =
                    TextEditingController(text: productItem.price.toString());
              if (productDescription == null)
                productDescription =
                    TextEditingController(text: productItem.description);

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
                                                  title: 'Delete Category Item',
                                                  desc:
                                                      'You want delete this item! \n Note: this item may be related by another product items',
                                                  btnOkOnPress: () async {
                                                    if (productItem
                                                        .image!.isNotEmpty)
                                                      deleteFileFRomFirebase(
                                                          productItem.image!);
                                                    productItem.reference
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
                                                          'You deleted a product item with success!',
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
                                            isDataUploading
                                                ? loadingIndicator(context)
                                                : DottedBorder(
                                                    color: MyTheme.of(context)
                                                        .primaryText,
                                                    dashPattern: [8, 8],
                                                    borderType:
                                                        BorderType.Circle,
                                                    child:
                                                        productItem.image!
                                                                .isNotEmpty
                                                            ? Container(
                                                                width: 120,
                                                                height: 120,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            50)),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(5),
                                                                  child:
                                                                      CircleAvatar(
                                                                    backgroundImage:
                                                                        Image(image: NetworkImage(uploadedFileUrl.isEmpty ? productItem.image! : uploadedFileUrl))
                                                                            .image,
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(
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
                                                                      Image
                                                                          .asset(
                                                                        'assets/images/upload_img.png',
                                                                        width:
                                                                            50,
                                                                        height:
                                                                            50,
                                                                      ),
                                                                      Text(
                                                                        "Select an image",
                                                                        style: MyTheme.of(context)
                                                                            .labelMedium,
                                                                      )
                                                                    ]),
                                                              )),
                                          ],
                                        ),
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
                                        text: "Upload Image",
                                        press: () async {
                                          if (productItem.image!.isNotEmpty)
                                            await deleteFileFRomFirebase(
                                                productItem.image!);

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
                                                uploadedFileUrl =
                                                    downloadUrls.first;
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
                                                textFieldController:
                                                    productTitle,
                                                focusNode:
                                                    focusNodeProductTitle!,
                                                labelText: 'Product Title',
                                                hintText: "Enter Product title",
                                                error: "This field is required",
                                                onChanged: (value) {
                                                  if (value!.isNotEmpty) {
                                                    removeError(
                                                        error:
                                                            "This field is required",
                                                        list: errorsTitle);
                                                  }
                                                  if (value.length > 3) {
                                                    removeError(
                                                        error:
                                                            "At least 3 characters",
                                                        list: errorsTitle);
                                                  }
                                                  return null;
                                                },
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    addError(
                                                        error:
                                                            "This field is required",
                                                        list: errorsTitle);
                                                    return "";
                                                  }
                                                  if (value.length < 3) {
                                                    addError(
                                                        error:
                                                            "At least 3 characters",
                                                        list: errorsTitle);
                                                    return "";
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            FormError(errors: errorsTitle),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      context, 20),
                                            ),
                                            Container(
                                              child: CustomTextField(
                                                textFieldController:
                                                    productPrice,
                                                focusNode:
                                                    focusNodeProductPrice!,
                                                labelText: 'Product  Price',
                                                hintText: "Enter Product price",
                                                error: "This field is required",
                                                keyboardType:
                                                    TextInputType.number,
                                                onChanged: (value) {
                                                  if (value!.isNotEmpty) {
                                                    removeError(
                                                        error:
                                                            "This field is required",
                                                        list: errorsPrice);
                                                  }

                                                  return null;
                                                },
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    addError(
                                                        error:
                                                            "This field is required",
                                                        list: errorsPrice);
                                                    return "";
                                                  }

                                                  return null;
                                                },
                                              ),
                                            ),
                                            FormError(errors: errorsPrice),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      context, 20),
                                            ),
                                            Container(
                                              child: CustomTextField(
                                                textFieldController:
                                                    productDescription,
                                                focusNode:
                                                    focusNodeProductDescription!,
                                                labelText:
                                                    'Product Description',
                                                hintText:
                                                    "Enter Product description",
                                                maxLines: 10,
                                                minLines: 1,
                                                onChanged: (value) {
                                                  if (value!.isNotEmpty) {
                                                    removeError(
                                                        error:
                                                            "This field is required",
                                                        list: errorsDesc);
                                                  }
                                                  if (value.length >= 10) {
                                                    removeError(
                                                        error:
                                                            "At least 10 characters",
                                                        list: errorsDesc);
                                                  }
                                                  return null;
                                                },
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    addError(
                                                        error:
                                                            "This field is required",
                                                        list: errorsDesc);
                                                    return "";
                                                  }
                                                  if (value.length < 10) {
                                                    addError(
                                                        error:
                                                            "At least 10 characters",
                                                        list: errorsDesc);
                                                    return "";
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            FormError(errors: errorsDesc),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      context, 20),
                                            ),
                                            FutureBuilder<
                                                List<SubCategoryRecord>>(
                                              future: futureSubCat,
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting)
                                                  loadingIndicator(context);
                                                if (snapshot.data == null)
                                                  return listEmpty(
                                                      "Sub Categories",
                                                      context);
                                                final subcategories =
                                                    snapshot.data!;
                                                if (selectSubCategory == null &&
                                                    subcategories.isNotEmpty) {
                                                  // Initialize the selectedCategory with the first category
                                                  selectSubCategory =
                                                      subcategories
                                                          .where((element) =>
                                                              element.ffRef ==
                                                              widget
                                                                  .subcategoryId)
                                                          .first
                                                          .subCategoryName;
                                                  subcategoryRef =
                                                      widget.subcategoryId;
                                                }
                                                return Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: CustomDropDownMenu(
                                                    value: selectSubCategory!,
                                                    hint:
                                                        "Select a sub category",
                                                    items: subcategories
                                                        .map((element) => element
                                                            .subCategoryName!)
                                                        .toList(),
                                                    validator: (value) {
                                                      if (value == null) {
                                                        return 'Please select a sub category.';
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (value) {
                                                      subcategoryRef = subcategories
                                                          .where((category) =>
                                                              category
                                                                  .subCategoryName ==
                                                              value)
                                                          .first
                                                          .ffRef;
                                                      selectSubCategory = value;
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
                                            FutureBuilder<List<BrandRecord>>(
                                              future: futureBrand,
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting)
                                                  loadingIndicator(context);
                                                if (snapshot.data == null)
                                                  return listEmpty(
                                                      "Brand", context);
                                                final brands = snapshot.data!;
                                                if (selectBrand == null &&
                                                    brands.isNotEmpty) {
                                                  // Initialize the selectedCategory with the first category
                                                  selectBrand = brands
                                                      .where((element) =>
                                                          element.ffRef ==
                                                          widget.brandId)
                                                      .first
                                                      .brandName;
                                                  brandRef = widget.brandId;
                                                }
                                                return Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: CustomDropDownMenu(
                                                    value: selectBrand,
                                                    hint: "Select a brand",
                                                    items: brands
                                                        .map((element) =>
                                                            element.brandName!)
                                                        .toList(),
                                                    validator: (value) {
                                                      if (value == null) {
                                                        return 'Please select a brand.';
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (value) {
                                                      brandRef = brands
                                                          .where((category) =>
                                                              category
                                                                  .brandName ==
                                                              value)
                                                          .first
                                                          .ffRef;
                                                      selectBrand = value;
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
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  _formKey.currentState!.save();
                                                  KeyboardUtil.hideKeyboard(
                                                      context);
                                                  FocusManager
                                                      .instance.primaryFocus
                                                      ?.unfocus();

                                                  final category =
                                                      await getNameRefCategory(
                                                          subcategoryRef);
                                                  final product =
                                                      createProductRecordData(
                                                    title: productTitle!.text,
                                                    description:
                                                        productDescription!
                                                            .text,
                                                    price: double.tryParse(
                                                        productPrice!.text),
                                                    subcategoryName:
                                                        selectSubCategory,
                                                    idBrand: brandRef,
                                                    brandName: selectBrand,
                                                    idCategory: category.$1,
                                                    categoryName: category.$2,
                                                    idSubcategory:
                                                        subcategoryRef,
                                                    image:
                                                        uploadedFileUrl.isEmpty
                                                            ? productItem.image
                                                            : uploadedFileUrl,
                                                    modifiedAt:
                                                        getCurrentTimestamp,
                                                  );

                                                  widget.productId
                                                      .update(product);
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                } else {
                                                  return;
                                                }
                                                Navigator.pop(context);
                                              },
                                              text: 'Update Product'),
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
