import 'package:blueraymarket/backend/schema/category/category_record.dart';
import 'package:blueraymarket/components/default_button.dart';
import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_svg/svg.dart';

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

class CategoryManage extends StatefulWidget {
  CategoryManage({Key? key, required this.categoryId, required this.context})
      : super(key: key);
  final BuildContext context;
  final DocumentReference categoryId;

  @override
  _CategoryManageState createState() => _CategoryManageState();
}

class _CategoryManageState extends State<CategoryManage> {
  @override
  void initState() {
    super.initState();
    future = CategoryRecord.getDocumentOnce(widget.categoryId);
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

  late Future<CategoryRecord> future;

  String categoryname = "";

  TextEditingController? _textEditingController;
  bool isLoading = false;
  bool? displayAt;

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
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5.0,
          sigmaY: 4.0,
        ),
        child: FutureBuilder<CategoryRecord>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return loadingIndicator(context);
              }
              final categoryItem = snapshot.data!;
              if (_textEditingController == null)
                _textEditingController =
                    TextEditingController(text: categoryItem.categoryName);
              if (displayAt == null)
                displayAt = categoryItem.displayAtHome ?? false;
              return Container(
                width: MediaQuery.of(context).size.width,
                height: 600,
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
                                                    deleteFileFRomFirebase(
                                                        categoryItem.image!);
                                                    CategoryRecord.collection
                                                        .doc(categoryItem
                                                            .ffRef!.id)
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
                                                          'You deleted a category item with success!',
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
                                                        categoryItem.image!
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
                                                                        const EdgeInsets.all(
                                                                            5),
                                                                    child: SvgPicture.network(uploadedFileUrl
                                                                            .isEmpty
                                                                        ? categoryItem
                                                                            .image!
                                                                        : uploadedFileUrl)),
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
                                        text: "Upload Svg Icon",
                                        press: () async {
                                          await deleteFileFRomFirebase(
                                              categoryItem.image!);

                                          final selectedMedia =
                                              await selectMediaWithSourceBottomSheet(
                                            context: context,
                                            allowPhoto: true,
                                          );
                                          if (selectedMedia != null) {
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
                                                labelText: 'Category Name',
                                                hintText: "Enter category name",
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
                                                    "Check this if you want the category to be displayed on the home page.",
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
                                                      createCategoryRecordData(
                                                    categoryName:
                                                        _textEditingController!
                                                            .text,
                                                    image:
                                                        uploadedFileUrl.isEmpty
                                                            ? categoryItem.image
                                                            : uploadedFileUrl,
                                                    modifiedAt:
                                                        getCurrentTimestamp,
                                                  );

                                                  await categoryItem.reference
                                                      .update(category);

                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                } else {
                                                  return;
                                                }
                                                Navigator.pop(context);
                                              },
                                              text: 'Update Category'),
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