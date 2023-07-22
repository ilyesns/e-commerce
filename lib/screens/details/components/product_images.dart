import 'package:flutter/material.dart';
import 'package:blueraymarket/tools/size_config.dart';

import '../../../tools/constants.dart';

class ProductImages extends StatefulWidget {
  const ProductImages({
    Key? key,
  }) : super(key: key);

  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  int selectedImage = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: getProportionateScreenWidth(context, 238),
          child: AspectRatio(
            aspectRatio: 1,
            // child: Hero(
            //   tag: widget.product.id.toString(), // id product
            //   child: Image.asset(widget.product.images[selectedImage]), //   image product
            // ),
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(context, 20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ...List.generate(widget.product.images.length,
            //     (index) => buildSmallProductPreview(index)),
          ],
        )
      ],
    );
  }

  GestureDetector buildSmallProductPreview(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = index;
        });
      },
      child: AnimatedContainer(
        duration: defaultDuration,
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.all(8),
        height: getProportionateScreenWidth(context, 48),
        width: getProportionateScreenWidth(context, 48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: kPrimaryColor.withOpacity(selectedImage == index ? 1 : 0)),
        ),
        // child: Image.asset(widget.product.images[index]), // the image
      ),
    );
  }
}
