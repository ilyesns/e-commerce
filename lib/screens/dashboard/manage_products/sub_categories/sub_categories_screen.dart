import 'dart:async';

import 'package:blueraymarket/backend/backend.dart';
import 'package:blueraymarket/backend/schema/category/category_record.dart';
import 'package:blueraymarket/components/default_button.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../../../auth/auth_util.dart';
import '../../../../backend/firebase_storage/storage.dart';
import '../../../../backend/schema/sub_category/sub_category_record.dart';
import '../../../../backend/schema/user/user_record.dart';
import '../../../../components/category_manage/category_manage.dart';
import '../../../../components/form_error.dart';
import '../../../../components/sub_category_manage/sub_category_manage.dart';
import '../../../../helper/keyboard.dart';
import '../../../../tools/nav/theme.dart';
import '../../../../tools/upload_data.dart';
import '../../../../tools/upload_file.dart';
import '../../../../tools/util.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../home/components/search_field.dart';

class SubCategoriesScreen extends StatefulWidget {
  const SubCategoriesScreen({super.key});

  @override
  State<SubCategoriesScreen> createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: MyTheme.of(context).primary,
        title: Text("Sub Categories Page"),
      ),
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();

  final List<String?> errors = [];
  final _textFieldControllerSubCategory = TextEditingController();
  final _textFieldControllerSubCategorySearch = TextEditingController();

  final FocusNode focusNodeSubCategory = FocusNode();

  FocusNode _focusNode = FocusNode();
  final FocusNode focusNodeSubcategoriesearch = FocusNode();

  SizeConfig sizeConfig = SizeConfig();
  late Stream<List<SubCategoryRecord>> stream;
  late Stream<List<CategoryRecord>> streamCat;

  late DocumentReference? categoryRef;

  bool isDataUploading = false;
  late UploadedFile uploadedLocalFile;
  String uploadedFileUrl = '';
  bool uploadImage = false;
  String search = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    stream = querySubCategoriesRecord(
        queryBuilder: (q) => q.orderBy('sub_category_name', descending: false));
    streamCat = queryCategoriesRecord();
  }

  @override
  void dispose() {
    super.dispose();
    focusNodeSubCategory.dispose();
    _focusNode.dispose();
    focusNodeSubcategoriesearch.dispose();
    _textFieldControllerSubCategory.dispose();
    _textFieldControllerSubCategorySearch.dispose();
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
        height: sizeConfig.screenHeight,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              vertical: getProportionateScreenHeight(context, 20),
              horizontal: getProportionateScreenWidth(context, 20)),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              uploadImageComponent(context),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (uploadImage)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Please upload an image",
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
                      if (uploadedFileUrl.isEmpty) {
                        setState(() {
                          uploadImage = true;
                        });
                      }
                      if (_formKey.currentState!.validate() &&
                          uploadedFileUrl.isNotEmpty) {
                        setState(() {
                          isLoading = true;
                        });
                        _formKey.currentState!.save();
                        KeyboardUtil.hideKeyboard(context);
                        FocusManager.instance.primaryFocus?.unfocus();

                        final subcategory = createSubCategoryRecordData(
                            subCategoryName:
                                _textFieldControllerSubCategory.text,
                            image: uploadedFileUrl,
                            createdAt: getCurrentTimestamp,
                            modifiedAt: getCurrentTimestamp,
                            createdBy: currentUserReference);
                        await SubCategoryRecord.createDoc(categoryRef!)
                            .set(subcategory);
                        setState(() {
                          isLoading = false;

                          uploadedFileUrl = '';
                          uploadImage = false;
                          _textFieldControllerSubCategory.clear();
                        });
                        ScaffoldMessenger.of(_context).showSnackBar(
                          SnackBar(
                            backgroundColor: MyTheme.of(context).alternate,
                            content: Text(
                              'You added a sub category item with success!',
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
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sub Category\'s list',
                      style: MyTheme.of(context).titleMedium,
                    ),
                    SizedBox(
                      width: getProportionateScreenWidth(context, 10),
                    ),
                    Container(
                        width: getProportionateScreenWidth(context, 190),
                        height: 50,
                        child: SearchField(
                          onChanged: (value) {
                            search = value;
                          },
                          hintText: "Search sub category",
                        )),
                  ],
                ),
              ),
              ListItemsComponent(context, _context),
            ],
          ),
        ),
      ),
    );
  }

  Padding ListItemsComponent(BuildContext context, BuildContext _context) {
    return Padding(
      padding: EdgeInsets.only(top: getProportionateScreenHeight(context, 20)),
      child: StreamBuilder<List<SubCategoryRecord>>(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return loadingIndicator(context);
            }
            if (snapshot.data!.isEmpty) {
              return listEmpty("Sub Categories", context);
            }
            final subcategories = snapshot.data;
            final subcategoriesAfterSearch = subcategories!
                .where((e) => e.subCategoryName!
                    .toLowerCase()
                    .contains(search.toLowerCase()))
                .toList();

            if (subcategoriesAfterSearch.isEmpty) {
              return searchNotAvailable("Sub Categories", context);
            }

            return ListView.builder(
                padding: EdgeInsets.only(
                    top: getProportionateScreenHeight(context, 20)),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: subcategoriesAfterSearch.length,
                itemBuilder: (context, index) {
                  final subcategoryItem = subcategoriesAfterSearch[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: getProportionateScreenHeight(context, 10)),
                    child: Container(
                      width: double.infinity,
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
                                Container(
                                  width: 40,
                                  height: 40,
                                  child: CachedNetworkImage(
                                    imageUrl: subcategoryItem.image!,
                                    // Placeholder widget while loading
                                    placeholder: (context, url) => Image.asset(
                                        'assets/images/blue_ray_image.jpg'), // Placeholder widget
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.error,
                                      color: Colors.black,
                                    ), // Widget to display on error
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Name : ${subcategoryItem.subCategoryName as String}",
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
                                    FutureBuilder<UserRecord>(
                                        future: UserRecord.getDocumentOnce(
                                            subcategoryItem.createdBy!),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting)
                                            Text(
                                              'Create by :',
                                              style: MyTheme.of(context)
                                                  .labelLarge
                                                  .override(
                                                      fontSize: 14,
                                                      fontFamily: 'Roboto'),
                                            );

                                          if (!snapshot.hasData) {
                                            return Text(
                                              'Create by :',
                                              style: MyTheme.of(context)
                                                  .labelLarge
                                                  .override(
                                                      fontSize: 14,
                                                      fontFamily: 'Roboto'),
                                            );
                                          }
                                          final userName = snapshot.data!.name;
                                          return Text(
                                            'Create by :$userName',
                                            style: MyTheme.of(context)
                                                .labelLarge
                                                .override(
                                                    fontSize: 14,
                                                    fontFamily: 'Roboto'),
                                          );
                                        }),
                                    SizedBox(
                                      height: getProportionateScreenHeight(
                                          context, 3),
                                    ),
                                    FutureBuilder<CategoryRecord>(
                                        future: CategoryRecord.getDocumentOnce(
                                            subcategoryItem
                                                .reference.parent.parent!),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting)
                                            Text(
                                              'Category name :',
                                              style: MyTheme.of(context)
                                                  .labelLarge
                                                  .override(
                                                      fontSize: 14,
                                                      fontFamily: 'Roboto'),
                                            );

                                          if (!snapshot.hasData) {
                                            return Text(
                                              'Category name:',
                                              style: MyTheme.of(context)
                                                  .labelLarge
                                                  .override(
                                                      fontSize: 14,
                                                      fontFamily: 'Roboto'),
                                            );
                                          }
                                          final categoryName =
                                              snapshot.data!.categoryName;
                                          return Text(
                                            'Category name :$categoryName',
                                            style: MyTheme.of(context)
                                                .labelLarge
                                                .override(
                                                    fontSize: 14,
                                                    fontFamily: 'Roboto'),
                                          );
                                        }),
                                    SizedBox(
                                      height: getProportionateScreenHeight(
                                          context, 3),
                                    ),
                                    Text(
                                      'Create at :${dateTimeFormat('M/d H:mm', subcategoryItem.createdAt)}',
                                      style: MyTheme.of(context)
                                          .labelLarge
                                          .override(
                                              fontSize: 14,
                                              fontFamily: 'Roboto'),
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(
                                          context, 3),
                                    ),
                                    Text(
                                      'Modify at :${dateTimeFormat('M/d H:mm', subcategoryItem.modifiedAt)}',
                                      style: MyTheme.of(context)
                                          .labelLarge
                                          .override(
                                              fontSize: 14,
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
                                      child: SubCategoryManage(
                                        context: _context,
                                        subcategoryId: subcategoryItem.ffRef!,
                                        categoryId: subcategoryItem!
                                            .reference!.parent.parent!,
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
          }),
    );
  }

  String? selectCategory;

  Form FormComponent() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              child: CustomTextField(
                textFieldController: _textFieldControllerSubCategory,
                focusNode: focusNodeSubCategory,
                labelText: 'Sub Category Name',
                hintText: "Enter sub category name",
                error: "This field is required",
                addError: addError,
                removeError: removeError,
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
            SizedBox(
              height: getProportionateScreenHeight(context, 20),
            ),
            StreamBuilder<List<CategoryRecord>>(
              stream: streamCat,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  loadingIndicator(context);
                if (snapshot.data == null)
                  return listEmpty("Categories", context);
                final categories = snapshot.data;
                if (selectCategory == null && categories!.isNotEmpty) {
                  // Initialize the selectedCategory with the first category
                  selectCategory = categories[0].categoryName;
                  categoryRef = categories[0].ffRef;
                }
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: CustomDropDownMenu(
                    hint: "Select a category",
                    items: categories!
                        .map((element) => element.categoryName!)
                        .toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a category.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      categoryRef = categories
                          .where((category) => category.categoryName == value)
                          .first
                          .ffRef;
                      selectCategory = value;
                    },
                  ),
                );
              },
            ),
          ],
        ));
  }

  InkWell uploadImageComponent(BuildContext context) {
    return InkWell(
      onTap: () async {
        final selectedMedia = await selectMediaWithSourceBottomSheet(
          context: context,
          allowPhoto: true,
        );
        if (selectedMedia != null &&
            selectedMedia
                .every((m) => validateFileFormat(m.storagePath, context))) {
          setState(() => isDataUploading = true);
          var selectedUploadedFiles = <UploadedFile>[];
          var downloadUrls = <String>[];
          try {
            selectedUploadedFiles = selectedMedia
                .map((m) => UploadedFile(
                      name: m.storagePath.split('/').last,
                      bytes: m.bytes,
                      height: m.dimensions?.height,
                      width: m.dimensions?.width,
                      blurHash: m.blurHash,
                    ))
                .toList();

            downloadUrls = (await Future.wait(
              selectedMedia.map(
                (m) async => await uploadData(m.storagePath, m.bytes),
              ),
            ))
                .where((u) => u != null)
                .map((u) => u!)
                .toList();
          } finally {
            isDataUploading = false;
          }
          if (selectedUploadedFiles.length == selectedMedia.length &&
              downloadUrls.length == selectedMedia.length) {
            setState(() {
              uploadedLocalFile = selectedUploadedFiles.first;
              uploadedFileUrl = downloadUrls.first;
              uploadImage = false;
            });
          } else {
            setState(() {});
            return;
          }
        }
      },
      child: Padding(
        padding:
            EdgeInsets.only(top: getProportionateScreenHeight(context, 20)),
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
                      color: MyTheme.of(context).primaryText,
                      dashPattern: [8, 8],
                      borderType: BorderType.Circle,
                      child: uploadedFileUrl.isNotEmpty
                          ? Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50)),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: CircleAvatar(
                                  backgroundImage: Image(
                                          image: NetworkImage(uploadedFileUrl))
                                      .image,
                                ),
                              ),
                            )
                          : Container(
                              width: 120,
                              height: 100,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/upload_img.png',
                                      width: 50,
                                      height: 50,
                                    ),
                                    Text(
                                      "Select an image",
                                      style: MyTheme.of(context).labelMedium,
                                    )
                                  ]),
                            ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
