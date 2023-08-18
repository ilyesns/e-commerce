import 'dart:ui';

import 'package:blueraymarket/components/default_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iglu_color_picker_flutter/iglu_color_picker_flutter.dart';

import 'nav/theme.dart';
import 'size_config.dart';

class CustomColorPicker extends StatefulWidget {
  CustomColorPicker(
      {super.key, required this.onChange, required BuildContext context});
  late void Function(Color) onChange;
  @override
  State<CustomColorPicker> createState() => _CustomColorPickerState();
}

class _CustomColorPickerState extends State<CustomColorPicker> {
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5.0,
          sigmaY: 4.0,
        ),
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: 800,
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
                            height: MediaQuery.of(context).size.height / 1.3,
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
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(
                                        getProportionateScreenHeight(
                                            context, 20)),
                                    child: Container(
                                      child: IGColorPicker(
                                          paletteType: IGPaletteType.hsvWithHue,
                                          onColorChanged: widget.onChange),
                                    ),
                                  ),
                                  Container(
                                    width: 100,
                                    height: 60,
                                    child: DefaultButton(
                                      text: 'Pick Color',
                                      press: () {
                                        context.pop();
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ))),
                  ]),
            )));
  }
}
