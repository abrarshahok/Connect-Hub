import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../constants/constants.dart';

class NetworkImageWidget extends StatelessWidget {
  final double height;
  final double width;
  final String imageUrl;

  const NetworkImageWidget({
    super.key,
    required this.height,
    required this.width,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: MyColors.tercharyColor),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        padding: const EdgeInsets.all(5),
        height: 50,
        width: 50,
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          color: MyColors.buttonColor1,
        ),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
