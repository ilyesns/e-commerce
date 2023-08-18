import 'dart:async';

import 'package:blueraymarket/backend/backend.dart';
import 'package:blueraymarket/backend/schema/discount/discount_record.dart';
import 'package:blueraymarket/components/default_button.dart';
import 'package:blueraymarket/components/discount_manage/discount_manage.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../../../auth/auth_util.dart';
import '../../../../backend/firebase_storage/storage.dart';
import '../../../../backend/schema/discount/discount_record.dart';
import '../../../../backend/schema/user/user_record.dart';
import '../../../../components/form_error.dart';
import '../../../../components/socal_card.dart';
import '../../../../helper/keyboard.dart';
import '../../../../tools/nav/theme.dart';
import '../../../../tools/upload_data.dart';
import '../../../../tools/upload_file.dart';
import '../../../../tools/util.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../home/components/search_field.dart';

class DiscountsScreen extends StatefulWidget {
  const DiscountsScreen({super.key});

  @override
  State<DiscountsScreen> createState() => _DiscountsScreenState();
}

class _DiscountsScreenState extends State<DiscountsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: MyTheme.of(context).primary,
        title: Text("Discounts Page"),
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

  final List<String?> errorsTitle = [];
  final List<String?> errorsDesc = [];
  final List<String?> errorsPercent = [];

  final _textFieldControllerDiscountTitle = TextEditingController();
  final _textFieldControllerDiscountPercent = TextEditingController();
  final _textFieldControllerDiscountDescription = TextEditingController();
  final _textFieldControllerDiscountSearch = TextEditingController();

  final FocusNode focusNodeDiscountTitle = FocusNode();
  final FocusNode focusNodeDiscountPercent = FocusNode();
  final FocusNode focusNodeDiscountDescription = FocusNode();

  FocusNode _focusNode = FocusNode();
  final FocusNode focusNodeDiscountSearch = FocusNode();

  SizeConfig sizeConfig = SizeConfig();
  late Stream<List<DiscountRecord>> stream;

  bool isDataUploading = false;
  late UploadedFile uploadedLocalFile;
  String uploadedFileUrl = '';
  bool uploadImage = false;
  String search = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    stream = queryDiscountsRecord(
        queryBuilder: (discountRecord) =>
            discountRecord.orderBy('created_at', descending: true));
  }

  @override
  void dispose() {
    super.dispose();
    focusNodeDiscountTitle.dispose();
    focusNodeDiscountDescription.dispose();
    focusNodeDiscountPercent.dispose();
    _focusNode.dispose();
    focusNodeDiscountSearch.dispose();
    _textFieldControllerDiscountTitle.dispose();
    _textFieldControllerDiscountDescription.dispose();
    _textFieldControllerDiscountPercent.dispose();
    _textFieldControllerDiscountSearch.dispose();
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

                        final discount = createDiscountRecordData(
                          title: _textFieldControllerDiscountTitle.text,
                          description:
                              _textFieldControllerDiscountDescription.text,
                          discountPercent: double.tryParse(
                              _textFieldControllerDiscountPercent.text),
                          image: uploadedFileUrl,
                          createdAt: getCurrentTimestamp,
                          modifiedAt: getCurrentTimestamp,
                        );
                        await DiscountRecord.collection.add(discount);

                        setState(() {
                          isLoading = false;

                          uploadedFileUrl = '';
                          uploadImage = false;
                          _textFieldControllerDiscountTitle.clear();
                          _textFieldControllerDiscountDescription.clear();
                          _textFieldControllerDiscountPercent.clear();
                        });
                        ScaffoldMessenger.of(_context).showSnackBar(
                          SnackBar(
                            backgroundColor: MyTheme.of(context).alternate,
                            content: Text(
                              'You added a discount item with success!',
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
                      'Discount\'s list',
                      style: MyTheme.of(context).titleMedium,
                    ),
                    Container(
                        width: getProportionateScreenWidth(context, 200),
                        height: 50,
                        child: SearchField(
                          onChanged: (value) {
                            search = value;
                          },
                          hintText: "Search discount",
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
      child: StreamBuilder<List<DiscountRecord>>(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return loadingIndicator(context);
            }
            if (snapshot.data!.isEmpty) {
              return listEmpty("Discounts", context);
            }
            final discounts = snapshot.data;
            final discountAfterSearch = discounts!
                .where((e) =>
                    e.title!.toLowerCase().contains(search.toLowerCase()))
                .toList();

            if (discountAfterSearch.isEmpty) {
              return searchNotAvailable("Discounts", context);
            }

            return ListView.builder(
                padding: EdgeInsets.only(
                    top: getProportionateScreenHeight(context, 20)),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: discountAfterSearch.length,
                itemBuilder: (context, index) {
                  final discountItem = discountAfterSearch[index];
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
                                    imageUrl: discountItem.image!,
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
                                      'Title: ${discountItem.title as String}',
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
                                      'Description: ${discountItem.description!.truncateText(15)}',
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
                                      'Percent: ${discountItem.discountPercent}',
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
                                      'Create at :${dateTimeFormat('M/d H:mm', discountItem.createdAt)}',
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
                                      'Modify at :${dateTimeFormat('M/d H:mm', discountItem.modifiedAt)}',
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
                                      child: DiscountManage(
                                          discountId: discountItem.reference,
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
                textFieldController: _textFieldControllerDiscountTitle,
                focusNode: focusNodeDiscountTitle,
                labelText: 'Discount Title',
                hintText: "Enter discount title",
                onChanged: (value) {
                  if (value!.isNotEmpty) {
                    removeError(
                        error: "This field is required", list: errorsTitle);
                  }
                  if (value.length > 3) {
                    removeError(
                        error: "At least 3 characters", list: errorsTitle);
                  }
                  return null;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    addError(
                        error: "This field is required", list: errorsTitle);
                    return "";
                  }
                  if (value.length < 3) {
                    addError(error: "At least 3 characters", list: errorsTitle);
                    return "";
                  }
                  return null;
                },
              ),
            ),
            FormError(errors: errorsTitle),
            SizedBox(
              height: getProportionateScreenHeight(context, 20),
            ),
            Container(
              child: CustomTextField(
                textFieldController: _textFieldControllerDiscountPercent,
                focusNode: focusNodeDiscountPercent,
                labelText: 'Discount Percent',
                hintText: "Enter discount percent",
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value!.isNotEmpty) {
                    removeError(
                        error: "This field is required", list: errorsPercent);
                  }
                  if (value.length <= 3) {
                    removeError(
                        error: "The percent must not above a 3 digits",
                        list: errorsPercent);
                  }
                  return null;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    addError(
                        error: "This field is required", list: errorsPercent);
                    return "";
                  }
                  if (value.length > 3) {
                    addError(
                        error: "The percent must not above a 3 digits",
                        list: errorsPercent);
                    return "";
                  }
                  return null;
                },
              ),
            ),
            FormError(errors: errorsPercent),
            SizedBox(
              height: getProportionateScreenHeight(context, 20),
            ),
            Container(
              child: CustomTextField(
                textFieldController: _textFieldControllerDiscountDescription,
                focusNode: focusNodeDiscountDescription,
                labelText: 'Discount Description',
                hintText: "Enter Discount description",
                maxLines: 10,
                onChanged: (value) {
                  if (value!.isNotEmpty) {
                    removeError(
                        error: "This field is required", list: errorsDesc);
                  }
                  if (value.length >= 10) {
                    removeError(
                        error: "At least 10 characters", list: errorsDesc);
                  }
                  return null;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    addError(error: "This field is required", list: errorsDesc);
                    return "";
                  }
                  if (value.length < 10) {
                    addError(error: "At least 10 characters", list: errorsDesc);
                    return "";
                  }
                  return null;
                },
              ),
            ),
            FormError(errors: errorsDesc),
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
