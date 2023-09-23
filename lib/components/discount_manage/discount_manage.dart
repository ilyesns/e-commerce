import 'package:blueraymarket/backend/schema/category/category_record.dart';
import 'package:blueraymarket/backend/schema/discount/discount_record.dart';
import 'package:blueraymarket/components/default_button.dart';
import 'package:blueraymarket/tools/app_state.dart';
import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:go_router/go_router.dart';

import '../../backend/firebase_storage/storage.dart';
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

class DiscountManage extends StatefulWidget {
  DiscountManage({Key? key, required this.discountId, required this.context})
      : super(key: key);
  final BuildContext context;
  final DocumentReference discountId;

  @override
  _DiscountManageState createState() => _DiscountManageState();
}

class _DiscountManageState extends State<DiscountManage> {
  @override
  void initState() {
    super.initState();
    future = DiscountRecord.getDocumentOnce(widget.discountId);
  }

  bool isDataUploading = false;
  String uploadedFileUrl = '';
  late UploadedFile uploadedLocalFile;

  final _formKey = GlobalKey<FormState>();

  final List<String?> errorsTitle = [];
  final List<String?> errorsDesc = [];
  final List<String?> errorsPercent = [];

  final FocusNode focusNodeDiscountTitle = FocusNode();
  final FocusNode focusNodeDiscountDescription = FocusNode();
  final FocusNode focusNodeDiscountPercent = FocusNode();

  TextEditingController? discountTitle;
  TextEditingController? discountDescription;
  TextEditingController? discountPercent;
  late Future<DiscountRecord> future;
  bool isLoading = false;
  bool? checkbox;
  bool? displayAt;
  bool withPicture = false;

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
    focusNodeDiscountTitle.dispose();
    focusNodeDiscountDescription.dispose();
    focusNodeDiscountPercent.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5.0,
          sigmaY: 4.0,
        ),
        child: FutureBuilder<DiscountRecord>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return loadingIndicator(context);
              }
              final discountItem = snapshot.data!;
              if (discountTitle == null)
                discountTitle =
                    TextEditingController(text: discountItem.title!);
              if (discountDescription == null)
                discountDescription =
                    TextEditingController(text: discountItem.description!);
              if (discountPercent == null)
                discountPercent = TextEditingController(
                    text: discountItem.discountPercent.toString());
              if (checkbox == null) checkbox = discountItem.active ?? false;
              if (displayAt == null)
                displayAt = discountItem.displayAtHome ?? false;
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
                                                  title: 'Delete Discount Item',
                                                  desc:
                                                      'You want delete this item! \n Note: this item may be related by another product items',
                                                  btnOkOnPress: () async {
                                                    final isDiscRelated =
                                                        AppState()
                                                            .products
                                                            .where((element) =>
                                                                element!
                                                                    .idDiscount ==
                                                                discountItem
                                                                    .reference)
                                                            .firstOrNull;
                                                    if (isDiscRelated != null) {
                                                      context.pop();
                                                      ScaffoldMessenger.of(
                                                              widget.context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          backgroundColor:
                                                              MyTheme.of(
                                                                      context)
                                                                  .alternate,
                                                          content: Text(
                                                            'Discounts tied to products cannot be deleted!',
                                                            style: MyTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: MyTheme.of(
                                                                            context)
                                                                        .primary),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          duration: Duration(
                                                              seconds:
                                                                  3), // Set the duration for the SnackBar
                                                        ),
                                                      );
                                                    } else {
                                                      discountItem.reference
                                                          .delete();

                                                      if (discountItem
                                                          .image!.isNotEmpty)
                                                        deleteFileFRomFirebase(
                                                            discountItem
                                                                .image!);

                                                      Navigator.pop(context);
                                                      ScaffoldMessenger.of(
                                                              widget.context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          backgroundColor:
                                                              MyTheme.of(
                                                                      context)
                                                                  .alternate,
                                                          content: Text(
                                                            'You deleted a discount item with success!',
                                                            style: MyTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                    fontFamily:
                                                                        'Roboto',
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: MyTheme.of(
                                                                            context)
                                                                        .primary),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          duration: Duration(
                                                              seconds:
                                                                  3), // Set the duration for the SnackBar
                                                        ),
                                                      );
                                                    }
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
                                    if (withPicture)
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
                                                          discountItem.image!
                                                                  .isNotEmpty
                                                              ? Container(
                                                                  width: 120,
                                                                  height: 120,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              50)),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(5),
                                                                    child:
                                                                        CircleAvatar(
                                                                      backgroundImage:
                                                                          Image(image: NetworkImage(uploadedFileUrl.isEmpty ? discountItem.image! : uploadedFileUrl))
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
                                                                          style:
                                                                              MyTheme.of(context).labelMedium,
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
                                    if (withPicture)
                                      Container(
                                        width: getProportionateScreenWidth(
                                            context, 150),
                                        height: getProportionateScreenHeight(
                                            context, 40),
                                        child: DefaultButton(
                                          text: "Upload Image",
                                          press: () async {
                                            await deleteFileFRomFirebase(
                                                discountItem!.image!);

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
                                                        .map((m) =>
                                                            UploadedFile(
                                                              name: m
                                                                  .storagePath
                                                                  .split('/')
                                                                  .last,
                                                              bytes: m.bytes,
                                                              height: m
                                                                  .dimensions
                                                                  ?.height,
                                                              width: m
                                                                  .dimensions
                                                                  ?.width,
                                                              blurHash:
                                                                  m.blurHash,
                                                            ))
                                                        .toList();

                                                downloadUrls =
                                                    (await Future.wait(
                                                  selectedMedia.map(
                                                    (m) async =>
                                                        await uploadData(
                                                            m.storagePath,
                                                            m.bytes),
                                                  ),
                                                ))
                                                        .where((u) => u != null)
                                                        .map((u) => u!)
                                                        .toList();
                                              } finally {
                                                isDataUploading = false;
                                              }
                                              if (selectedUploadedFiles
                                                          .length ==
                                                      selectedMedia.length &&
                                                  downloadUrls.length ==
                                                      selectedMedia.length) {
                                                setState(() {
                                                  uploadedLocalFile =
                                                      selectedUploadedFiles
                                                          .first;
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
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Checkbox(
                                            activeColor:
                                                MyTheme.of(context).primary,
                                            value: withPicture,
                                            onChanged: (value) => setState(() {
                                                  withPicture = value!;
                                                })),
                                        Text(
                                          overflow: TextOverflow.visible,
                                          "Check this if you want an image for discount.",
                                          style:
                                              MyTheme.of(context).labelMedium,
                                        ),
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
                                                    discountTitle,
                                                focusNode:
                                                    focusNodeDiscountTitle,
                                                labelText: 'Discount Title',
                                                hintText:
                                                    "Enter discount title",
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
                                                    discountPercent,
                                                focusNode:
                                                    focusNodeDiscountPercent,
                                                labelText: 'Discount Percent',
                                                hintText:
                                                    "Enter discount percent",
                                                keyboardType:
                                                    TextInputType.number,
                                                onChanged: (value) {
                                                  if (value!.isNotEmpty) {
                                                    removeError(
                                                        error:
                                                            "This field is required",
                                                        list: errorsPercent);
                                                  }
                                                  if (value.length <= 6) {
                                                    removeError(
                                                        error:
                                                            "The percent must not above a 6 digits",
                                                        list: errorsPercent);
                                                  }
                                                  return null;
                                                },
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    addError(
                                                        error:
                                                            "This field is required",
                                                        list: errorsPercent);
                                                    return "";
                                                  }
                                                  if (value.length > 6) {
                                                    addError(
                                                        error:
                                                            "The percent must not above a 6 digits",
                                                        list: errorsPercent);
                                                    return "";
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            FormError(errors: errorsPercent),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      context, 20),
                                            ),
                                            Container(
                                              child: CustomTextField(
                                                textFieldController:
                                                    discountDescription,
                                                focusNode:
                                                    focusNodeDiscountDescription,
                                                labelText:
                                                    'Discount Description',
                                                hintText:
                                                    "Enter Discount description",
                                                maxLines: 10,
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
                                                      context, 10),
                                            ),
                                            Column(
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Checkbox(
                                                        activeColor:
                                                            MyTheme.of(context)
                                                                .primary,
                                                        value: checkbox,
                                                        onChanged: (value) =>
                                                            setState(() {
                                                              checkbox = value!;
                                                            })),
                                                    Expanded(
                                                      child: Text(
                                                        overflow: TextOverflow
                                                            .visible,
                                                        "Check this if you want the discount to be active.",
                                                        style:
                                                            MyTheme.of(context)
                                                                .labelMedium,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height:
                                                  getProportionateScreenHeight(
                                                      context, 10),
                                            ),
                                            Row(
                                              children: [
                                                Checkbox(
                                                    activeColor:
                                                        MyTheme.of(context)
                                                            .primary,
                                                    value: displayAt,
                                                    onChanged: (value) =>
                                                        setState(() {
                                                          displayAt = value!;
                                                        })),
                                                Expanded(
                                                  child: Text(
                                                      overflow:
                                                          TextOverflow.visible,
                                                      "Check this if you want the discount to be displayed on the home page.",
                                                      style: MyTheme.of(context)
                                                          .labelMedium),
                                                )
                                              ],
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
                                                  final discount =
                                                      createDiscountRecordData(
                                                          title: discountTitle!
                                                              .text,
                                                          description:
                                                              discountDescription!
                                                                  .text,
                                                          discountPercent: double
                                                              .tryParse(
                                                                  discountPercent!
                                                                      .text),
                                                          image:
                                                              uploadedFileUrl
                                                                      .isEmpty
                                                                  ? discountItem
                                                                      .image!
                                                                  : uploadedFileUrl,
                                                          modifiedAt:
                                                              getCurrentTimestamp,
                                                          active: checkbox,
                                                          displayAtHome:
                                                              displayAt!);

                                                  await widget.discountId
                                                      .update(discount);
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                } else {
                                                  return;
                                                }
                                                Navigator.pop(context);
                                              },
                                              text: 'Update Discount'),
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

/*
 */
