import 'dart:async';

import 'package:blueraymarket/backend/backend.dart';
import 'package:blueraymarket/backend/schema/discount/discount_record.dart';
import 'package:blueraymarket/backend/schema/product/product_record.dart';
import 'package:blueraymarket/components/default_button.dart';
import 'package:blueraymarket/components/product_manage/product_manage.dart';
import 'package:blueraymarket/tools/app_state.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../../../backend/cache/hive_box.dart';
import '../../../../backend/firebase_storage/storage.dart';
import '../../../../backend/schema/brand/brand_record.dart';
import '../../../../backend/schema/sub_category/sub_category_record.dart';
import '../../../../components/form_error.dart';

import '../../../../helper/keyboard.dart';
import '../../../../tools/custom_functions.dart';
import '../../../../tools/nav/theme.dart';
import '../../../../tools/upload_data.dart';
import '../../../../tools/upload_file.dart';
import '../../../../tools/util.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../home/components/search_field.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: MyTheme.of(context).primary,
        title: Text("Products Page"),
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
  final List<String?> errorsPrice = [];

  final _textFieldControllerProductTitle = TextEditingController();
  final _textFieldControllerProductPrice = TextEditingController();
  final _textFieldControllerProductDescription = TextEditingController();
  final _textFieldControllerProductSearch = TextEditingController();

  final FocusNode focusNodeProductTitle = FocusNode();
  final FocusNode focusNodeProductPrice = FocusNode();
  final FocusNode focusNodeProductDescription = FocusNode();

  FocusNode _focusNode = FocusNode();
  final FocusNode focusNodeProductSearch = FocusNode();

  SizeConfig sizeConfig = SizeConfig();

  late Stream<List<SubCategoryRecord>> streamSubCat;

  late DocumentReference? brandRef;

  late Stream<List<BrandRecord>> streamBrands;

  late DocumentReference? subcategoryRef;

  late List<ProductRecord>? products = [];

  late FirestorePage<ProductRecord> paginateStream;
  ScrollController scrollController = ScrollController();

  bool isDataUploading = false;
  late UploadedFile uploadedLocalFile;
  String uploadedFileUrl = '';
  bool uploadImage = false;
  String search = '';
  bool isHasNext = true;
  bool firstTime = false;
  bool isLoading = false;
  bool isProductsLoading = false;
  QueryDocumentSnapshot<Object?>? nextPage;
  @override
  void initState() {
    super.initState();
    streamBrands = queryBrandsRecord();
    streamSubCat = querySubCategoriesRecord();
    _textFieldControllerProductSearch.addListener(onSearch);
    scrollController.addListener(scrollListener);
    fetchData();
  }

  onSearch() {
    print(_textFieldControllerProductSearch.text);
  }

  void fetchData() async {
    if (!firstTime)
      setState(() {
        isProductsLoading = true;
        firstTime = true;
      });

    paginateStream = await queryProductsPage(
        nextPageMarker: nextPage,
        pageSize: 5,
        isStream: false,
        queryBuilder: (q) => q.orderBy('created_at', descending: true));

    setState(() {
      products!.addAll(paginateStream.data);
      nextPage = paginateStream.nextPageMarker;
      isProductsLoading = false;
    });

    // Add fetchedProducts to the stream
    if (AppState().products.length <= products!.length) {
      setState(() {
        isHasNext = false;
      });
    }
  }

  scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) if (isHasNext) {
      fetchData();
    }
  }

  @override
  void dispose() {
    super.dispose();
    focusNodeProductTitle.dispose();
    focusNodeProductDescription.dispose();
    focusNodeProductPrice.dispose();
    _focusNode.dispose();

    focusNodeProductSearch.dispose();
    _textFieldControllerProductTitle.dispose();
    _textFieldControllerProductDescription.dispose();
    _textFieldControllerProductPrice.dispose();
    _textFieldControllerProductSearch.dispose();
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

  @override
  Widget build(BuildContext context) {
    final BuildContext _context = context;
    sizeConfig.init(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(_focusNode);
        setState(() {
          search;
        });
      },
      child: Container(
        width: sizeConfig.screenWidth,
        height: sizeConfig.screenHeight,
        child: RefreshIndicator(
          color: MyTheme.of(context).primary,
          onRefresh: () async {
            setState(() {
              nextPage = null;
              firstTime = false;
              isHasNext = true;
              products = [];
            });
          },
          child: SingleChildScrollView(
            controller: scrollController,
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

                          final discountref = await DiscountRecord.collection
                              .add(createDiscountRecordData(
                                  createdAt: getCurrentTimestamp));

                          final category =
                              await getNameRefCategory(subcategoryRef);

                          final product = createProductRecordData(
                              title: _textFieldControllerProductTitle.text,
                              description:
                                  _textFieldControllerProductDescription.text,
                              price: double.tryParse(
                                  _textFieldControllerProductPrice.text),
                              image: uploadedFileUrl,
                              brandName: selectBrand,
                              idBrand: brandRef,
                              categoryName: category.$2,
                              idCategory: category.$1,
                              subcategoryName: selectSubCategory,
                              idSubcategory: subcategoryRef,
                              createdAt: getCurrentTimestamp,
                              modifiedAt: getCurrentTimestamp,
                              idDiscount: discountref);
                          await ProductRecord.collection.add(product);
                          setState(() {
                            isLoading = false;

                            uploadedFileUrl = '';
                            uploadImage = false;
                            _textFieldControllerProductTitle.clear();
                            _textFieldControllerProductDescription.clear();
                            _textFieldControllerProductPrice.clear();
                          });
                          ScaffoldMessenger.of(_context).showSnackBar(
                            SnackBar(
                              backgroundColor: MyTheme.of(context).alternate,
                              content: Text(
                                'You added a product item with success!',
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
                        'Product\'s list',
                        style: MyTheme.of(context).titleMedium,
                      ),
                      Container(
                          width: getProportionateScreenWidth(context, 200),
                          height: 50,
                          child: SearchField(
                            controller: _textFieldControllerProductSearch,
                            onChanged: (value) {
                              search = value;
                            },
                            hintText: "Search product",
                          )),
                    ],
                  ),
                ),
                ListItemsComponent(context, _context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ListItemsComponent(BuildContext context, BuildContext _context) {
    return Padding(
        padding:
            EdgeInsets.only(top: getProportionateScreenHeight(context, 20)),
        child: products!.isEmpty
            ? listEmpty('Products', context)
            : isProductsLoading
                ? loadingIndicator(context)
                : Column(
                    children: [
                      ListView.builder(
                          padding: EdgeInsets.only(
                              top: getProportionateScreenHeight(context, 20)),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: products!.length,
                          itemBuilder: (context, index) {
                            print(search);
                            final productItem = products![index];

                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: getProportionateScreenHeight(
                                      context, 10)),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: MyTheme.of(context).primaryBackground,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            child: CachedNetworkImage(
                                              imageUrl: productItem.image!,
                                              // Placeholder widget while loading
                                              placeholder: (context, url) =>
                                                  Image.asset(
                                                      'assets/images/blue_ray_image.jpg'), // Placeholder widget
                                              errorWidget:
                                                  (context, url, error) => Icon(
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Title: ${productItem.title as String}',
                                                style: MyTheme.of(context)
                                                    .labelLarge
                                                    .override(
                                                        fontSize: 15,
                                                        fontFamily: 'Roboto'),
                                              ),
                                              SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        context, 3),
                                              ),
                                              Text(
                                                'Description: ${productItem.description!.truncateText(15)}',
                                                style: MyTheme.of(context)
                                                    .labelLarge
                                                    .override(
                                                        fontSize: 15,
                                                        fontFamily: 'Roboto'),
                                              ),
                                              SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        context, 3),
                                              ),
                                              Text(
                                                'Price: ${productItem.price}',
                                                style: MyTheme.of(context)
                                                    .labelLarge
                                                    .override(
                                                        fontSize: 15,
                                                        fontFamily: 'Roboto'),
                                              ),
                                              SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        context, 3),
                                              ),
                                              Text(
                                                'Create at :${dateTimeFormat('M/d H:mm', productItem.createdAt)}',
                                                style: MyTheme.of(context)
                                                    .labelLarge
                                                    .override(
                                                        fontSize: 14,
                                                        fontFamily: 'Roboto'),
                                              ),
                                              SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        context, 3),
                                              ),
                                              Text(
                                                'Modify at :${dateTimeFormat('M/d H:mm', productItem.modifiedAt)}',
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
                                                padding: MediaQuery.of(
                                                        bottomSheetContext)
                                                    .viewInsets,
                                                child: ProductManage(
                                                    productId:
                                                        productItem.reference,
                                                    brandId:
                                                        productItem.idBrand!,
                                                    subcategoryId: productItem
                                                        .idSubCategory!,
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
                          }),
                      if (isHasNext && firstTime)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: Container(
                                width: getProportionateScreenWidth(context, 30),
                                height:
                                    getProportionateScreenHeight(context, 30),
                                child: CircularProgressIndicator(
                                  color: MyTheme.of(context).primary,
                                )),
                          ),
                        )
                    ],
                  ));
  }

  String? selectBrand;
  String? selectSubCategory;

  Form FormComponent() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              child: CustomTextField(
                textFieldController: _textFieldControllerProductTitle,
                focusNode: focusNodeProductTitle,
                labelText: 'Product Title',
                hintText: "Enter Product title",
                error: "This field is required",
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
                textFieldController: _textFieldControllerProductPrice,
                focusNode: focusNodeProductPrice,
                labelText: 'Product  Price',
                hintText: "Enter Product price",
                error: "This field is required",
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value!.isNotEmpty) {
                    removeError(
                        error: "This field is required", list: errorsPrice);
                  }

                  return null;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    addError(
                        error: "This field is required", list: errorsPrice);
                    return "";
                  }

                  return null;
                },
              ),
            ),
            FormError(errors: errorsPrice),
            SizedBox(
              height: getProportionateScreenHeight(context, 20),
            ),
            Container(
              child: CustomTextField(
                textFieldController: _textFieldControllerProductDescription,
                focusNode: focusNodeProductDescription,
                labelText: 'Product Description',
                hintText: "Enter Product description",
                maxLines: 10,
                minLines: 1,
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
            SizedBox(
              height: getProportionateScreenHeight(context, 20),
            ),
            StreamBuilder<List<SubCategoryRecord>>(
              stream: streamSubCat,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  loadingIndicator(context);
                if (snapshot.data == null)
                  return listEmpty("Sub Categories", context);
                final subcategories = snapshot.data!;
                if (selectSubCategory == null && subcategories.isNotEmpty) {
                  // Initialize the selectedCategory with the first category

                  selectSubCategory = subcategories[0].subCategoryName;
                  subcategoryRef = subcategories[0].ffRef;
                }
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: CustomDropDownMenu(
                    hint: "Select a sub category",
                    items: subcategories
                        .map((element) => element.subCategoryName!)
                        .toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a sub category.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      subcategoryRef = subcategories
                          .where(
                              (category) => category.subCategoryName == value)
                          .first
                          .ffRef;
                      selectSubCategory = value;
                    },
                  ),
                );
              },
            ),
            SizedBox(
              height: getProportionateScreenHeight(context, 20),
            ),
            StreamBuilder<List<BrandRecord>>(
              stream: streamBrands,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  loadingIndicator(context);
                if (snapshot.data == null) return listEmpty("Brand", context);
                final brands = snapshot.data!;
                if (selectSubCategory == null && brands.isNotEmpty) {
                  // Initialize the selectedCategory with the first category
                  selectBrand = brands.first.brandName;
                  brandRef = brands.first.ffRef;
                }
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: CustomDropDownMenu(
                    value: selectBrand,
                    hint: "Select a brand",
                    items: brands.map((element) => element.brandName!).toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a brand.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      brandRef = brands
                          .where((category) => category.brandName == value)
                          .first
                          .ffRef;
                      selectBrand = value;
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
