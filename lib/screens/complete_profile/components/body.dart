import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:blueraymarket/tools/constants.dart';
import 'package:blueraymarket/tools/size_config.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';

import '../../../auth/auth_util.dart';
import '../../../backend/firebase_storage/storage.dart';
import '../../../backend/schema/user/user_record.dart';
import '../../../components/default_button.dart';
import '../../../components/form_error.dart';
import '../../../tools/nav/routes.dart';
import '../../../tools/nav/theme.dart';
import '../../../tools/upload_data.dart';
import '../../../tools/upload_file.dart';
import '../../../tools/util.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];

  final List<String?> errorsName = [];
  final List<String?> errorsPhone = [];
  final List<String?> errorsAddress = [];

  final _textFieldControllerUserName = TextEditingController();
  final _textFieldControllerPhoneNumber = TextEditingController();
  final _textFieldControllerAddress = TextEditingController();

  final FocusNode focusNodeUserName = FocusNode();
  final FocusNode focusNodePhoneNumber = FocusNode();
  final FocusNode focusNodeAddress = FocusNode();

  bool isLoading = false;

  bool isDataUploading = false;

  late UploadedFile uploadedLocalFile;

  String uploadedFileUrl = '';

  bool _uploadImage = false;

  bool get uploadImage => _uploadImage;
  set uploadImage(b) => _uploadImage = b;
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
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(context, 20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig().screenHeight * 0.03),
                Text("Complete Profile", style: headingStyle),
                Text(
                  "Complete your details or continue  \nwith social media",
                  textAlign: TextAlign.center,
                ),
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
                SizedBox(height: SizeConfig().screenHeight * 0.06),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        child: CustomTextField(
                          textFieldController: _textFieldControllerUserName,
                          focusNode: focusNodeUserName,
                          labelText: 'Name',
                          hintText: "Enter name",
                          onChanged: (value) {
                            if (value!.isNotEmpty) {
                              removeError(
                                  error: "This field is required",
                                  list: errorsName);
                            }
                            if (value.length > 3) {
                              removeError(
                                  error: "At least 3 characters",
                                  list: errorsName);
                            }
                            return null;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              addError(
                                  error: "This field is required",
                                  list: errorsName);
                              return "";
                            }
                            if (value.length < 3) {
                              addError(
                                  error: "At least 3 characters",
                                  list: errorsName);
                              return "";
                            }
                            return null;
                          },
                        ),
                      ),
                      FormError(errors: errorsName),
                      SizedBox(
                        height: getProportionateScreenHeight(context, 20),
                      ),
                      Container(
                        child: CustomTextField(
                          textFieldController: _textFieldControllerPhoneNumber,
                          focusNode: focusNodePhoneNumber,
                          labelText: 'Phone Number',
                          hintText: "Number phone etc +216 123456789...",
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            if (value!.isNotEmpty) {
                              removeError(
                                  error: "This field is required",
                                  list: errorsPhone);
                            }
                            if (value.contains('+')) {
                              removeError(
                                  error:
                                      "The number must begins with nation prefix",
                                  list: errorsPhone);
                            }
                            return null;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              addError(
                                  error: "This field is required",
                                  list: errorsPhone);
                              return "";
                            }
                            if (!value.contains('+')) {
                              addError(
                                  error:
                                      "The number must begins with nation prefix",
                                  list: errorsPhone);
                              return "";
                            }
                            return null;
                          },
                        ),
                      ),
                      FormError(errors: errorsPhone),
                      SizedBox(
                        height: getProportionateScreenHeight(context, 20),
                      ),
                      Container(
                        child: CustomTextField(
                          textFieldController: _textFieldControllerAddress,
                          focusNode: focusNodeAddress,
                          labelText: 'Address',
                          hintText: "Enter Address",
                          maxLines: 5,
                          onChanged: (value) {
                            if (value!.isNotEmpty) {
                              removeError(
                                  error: "This field is required",
                                  list: errorsAddress);
                            }
                            if (value.length >= 10) {
                              removeError(
                                  error: "At least 10 characters",
                                  list: errorsAddress);
                            }
                            return null;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              addError(
                                  error: "This field is required",
                                  list: errorsAddress);
                              return "";
                            }
                            if (value.length < 10) {
                              addError(
                                  error: "At least 10 characters",
                                  list: errorsAddress);
                              return "";
                            }
                            return null;
                          },
                        ),
                      ),
                      FormError(errors: errorsAddress),
                      SizedBox(
                          height: getProportionateScreenHeight(context, 40)),
                      Container(
                        width: getProportionateScreenWidth(context, 150),
                        height: getProportionateScreenHeight(context, 60),
                        child: DefaultButton(
                          isLoading: isLoading,
                          text: "continue",
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
                              final user = createUserRecordData(
                                  name: _textFieldControllerUserName.text,
                                  phoneNumber:
                                      _textFieldControllerPhoneNumber.text,
                                  address: _textFieldControllerAddress.text,
                                  photoUrl: uploadedFileUrl,
                                  role: roleUser);

                              await UserRecord.collection
                                  .doc(currentUserDocument!.uid)
                                  .update(user);
                              setState(() {
                                isLoading = true;
                                uploadImage = false;
                              });
                              context.pushReplacementNamed('NavBarPage',
                                  extra: <String, dynamic>{
                                    kTransitionInfoKey: TransitionInfo(
                                        hasTransition: true,
                                        duration: kAnimationDuration,
                                        transitionType: PageTransitionType
                                            .rightToLeftWithFade)
                                  });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(context, 30)),
                Text(
                  "By continuing your confirm that you agree \nwith our Term and Condition",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
