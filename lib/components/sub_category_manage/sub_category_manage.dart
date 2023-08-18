import 'package:blueraymarket/backend/backend.dart';
import 'package:blueraymarket/backend/schema/category/category_record.dart';
import 'package:blueraymarket/components/default_button.dart';
import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../backend/cache/hive_box.dart';
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

class SubCategoryManage extends StatefulWidget {
  SubCategoryManage(
      {Key? key,
      required this.subcategoryId,
      required this.categoryId,
      required this.context})
      : super(key: key);
  final BuildContext context;
  final DocumentReference subcategoryId;
  final DocumentReference categoryId;

  @override
  _SubCategoryManageState createState() => _SubCategoryManageState();
}

class _SubCategoryManageState extends State<SubCategoryManage> {
  @override
  void initState() {
    super.initState();
    future = SubCategoryRecord.getDocumentOnce(widget.subcategoryId);
    futureCat = queryCategoriesRecordOnce();
  }

  @override
  void dispose() {
    super.dispose();
    focusNodeCategory.dispose();
  }

  bool isDataUploading = false;
  String uploadedFileUrl = '';
  late UploadedFile uploadedLocalFile;

  final _formKey = GlobalKey<FormState>();

  final List<String?> errors = [];

  final FocusNode focusNodeCategory = FocusNode();

  late Future<SubCategoryRecord> future;
  late Future<List<CategoryRecord>> futureCat;

  late DocumentReference? categoryRef;
  TextEditingController? _textEditingController;
  bool isLoading = false;

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

  String? selectCategory;
  bool? displayAt;
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5.0,
          sigmaY: 4.0,
        ),
        child: FutureBuilder<SubCategoryRecord>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return loadingIndicator(context);
              }
              final subCategoryItem = snapshot.data!;

              if (_textEditingController == null)
                _textEditingController = TextEditingController(
                    text: subCategoryItem.subCategoryName);
              if (displayAt == null)
                displayAt = subCategoryItem.displayAtHome ?? false;
              return Container(
                width: MediaQuery.of(context).size.width,
                height: 700,
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
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsetsDirectional.all(
                              getProportionateScreenWidth(context, 12)),
                          child: Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height / 1.6,
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
                                                  title:
                                                      'Delete Sub Category Item',
                                                  desc:
                                                      'You want delete this item! \n Note: this item may be related by another product items',
                                                  btnOkOnPress: () async {
                                                    if (subCategoryItem
                                                        .image!.isNotEmpty)
                                                      deleteFileFRomFirebase(
                                                          subCategoryItem
                                                              .image!);
                                                    subCategoryItem.reference
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
                                                          'You deleted a sub category item with success!',
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
                                                        subCategoryItem.image!
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
                                                                        Image(image: NetworkImage(uploadedFileUrl.isEmpty ? subCategoryItem.image! : uploadedFileUrl))
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
                                          if (subCategoryItem.image!.isNotEmpty)
                                            await deleteFileFRomFirebase(
                                                subCategoryItem.image!);

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
                                                    _textEditingController,
                                                focusNode: focusNodeCategory,
                                                labelText: 'Sub Category Name',
                                                hintText:
                                                    "Enter sub category name",
                                                error: "This field is required",
                                                addError: addError,
                                                removeError: removeError,
                                                onChanged: (value) {
                                                  if (value!.isNotEmpty) {
                                                    removeError(
                                                        error:
                                                            "This field is required");
                                                  }
                                                  if (value.length > 3) {
                                                    removeError(
                                                        error:
                                                            "At least 3 characters");
                                                  }
                                                  return null;
                                                },
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    addError(
                                                        error:
                                                            "This field is required");
                                                    return "";
                                                  }
                                                  if (value.length < 3) {
                                                    addError(
                                                        error:
                                                            "At least 3 characters");
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
                                            FutureBuilder<List<CategoryRecord>>(
                                              future: futureCat,
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting)
                                                  loadingIndicator(context);
                                                if (snapshot.data == null)
                                                  return listEmpty(
                                                      "Categories", context);
                                                final categories =
                                                    snapshot.data;
                                                if (selectCategory == null &&
                                                    categories!.isNotEmpty) {
                                                  // Initialize the selectedCategory with the first category
                                                  selectCategory = categories
                                                      .where((element) =>
                                                          element.ffRef ==
                                                          widget.categoryId)
                                                      .first
                                                      .categoryName;
                                                  categoryRef =
                                                      widget.categoryId;
                                                }
                                                return Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: CustomDropDownMenu(
                                                    value: selectCategory!,
                                                    hint: "Select a category",
                                                    items: categories!
                                                        .map((element) =>
                                                            element
                                                                .categoryName!)
                                                        .toList(),
                                                    validator: (value) {
                                                      if (value == null) {
                                                        return 'Please select a category.';
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (value) {
                                                      categoryRef = categories
                                                          .where((category) =>
                                                              category
                                                                  .categoryName ==
                                                              value)
                                                          .first
                                                          .ffRef;
                                                      selectCategory = value;
                                                    },
                                                  ),
                                                );
                                              },
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
                                                    "Check this if you want the sub category to be displayed on the home page.",
                                                    style: MyTheme.of(context)
                                                        .labelMedium,
                                                  ),
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
                                              context, 180),
                                          height: getProportionateScreenHeight(
                                              context, 50),
                                          child: DefaultButton(
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
                                                  final subcategory = createSubCategoryRecordData(
                                                      subCategoryName:
                                                          _textEditingController!
                                                              .text,
                                                      image: uploadedFileUrl
                                                              .isEmpty
                                                          ? subCategoryItem
                                                              .image
                                                          : uploadedFileUrl,
                                                      createdAt: subCategoryItem
                                                          .createdAt,
                                                      createdBy: subCategoryItem
                                                          .createdBy,
                                                      modifiedAt:
                                                          getCurrentTimestamp,
                                                      displayAtHome:
                                                          displayAt!);

                                                  if (widget.categoryId !=
                                                      categoryRef) {
                                                    await SubCategoryRecord
                                                            .createDoc(
                                                                categoryRef!)
                                                        .set(subcategory)
                                                        .then((value) {
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                    });
                                                    await subCategoryItem
                                                        .reference
                                                        .delete();
                                                  } else {
                                                    subCategoryItem.reference
                                                        .update(subcategory);
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                  }
                                                } else {
                                                  return;
                                                }
                                                Navigator.pop(context);
                                              },
                                              text: 'Update Sub Category'),
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