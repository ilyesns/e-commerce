import 'package:blueraymarket/tools/nav/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:blueraymarket/tools/size_config.dart';

import '../../../backend/schema/variant/variant_record.dart';
import '../../../tools/app_state.dart';
import '../../../tools/constants.dart';

class ProductImages extends StatefulWidget {
  ProductImages({Key? key, this.tag, this.images, this.image})
      : super(key: key);
  final DocumentReference? tag;
  late List<String>? images;
  late String? image;
  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  String? selectedImage;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    selectedImage = widget.image;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: getProportionateScreenWidth(context, 238),
          child: AspectRatio(
            aspectRatio: 1,
            child: Hero(
              tag: widget.tag.toString(), // id product
              child: CachedNetworkImage(
                  imageUrl: widget.image!,
                  placeholder: (context, url) => Image.asset(
                      'assets/images/blue_ray_image.jpg'), // Placeholder widget
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error)), //   image product
            ),
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(context, 20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.images != null && widget.images!.isNotEmpty)
              ...List.generate(widget.images!.length,
                  (index) => buildSmallProductPreview(widget.images![index])),
          ],
        )
      ],
    );
  }

  Widget buildSmallProductPreview(String index) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.image = index;
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
              color: MyTheme.of(context)
                  .primary
                  .withOpacity(widget.image == index ? 1 : 0)),
        ),
        child: CachedNetworkImage(imageUrl: index), // the image
      ),
    );
  }
}
