import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:blueraymarket/tools/size_config.dart';

class FormError extends StatelessWidget {
  const FormError({
    Key? key,
    required this.errors,
  }) : super(key: key);

  final List<String?> errors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(errors.length,
          (index) => formErrorText(error: errors[index]!, context: context)),
    );
  }

  Row formErrorText({required String error, required BuildContext context}) {
    return Row(
      children: [
        SvgPicture.asset(
          "assets/icons/Error.svg",
          height: getProportionateScreenWidth(context, 14),
          width: getProportionateScreenWidth(context, 14),
        ),
        SizedBox(
          width: getProportionateScreenWidth(context, 10),
        ),
        Text(error),
      ],
    );
  }
}
