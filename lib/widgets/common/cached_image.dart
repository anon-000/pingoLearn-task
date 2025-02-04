import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

///
/// Created by Auro on 29/07/24
///

class CachedImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final double? height;
  final double? width;
  final Widget? errorWidget;
  final bool isCircle;
  final bool canOpen;

  const CachedImage(this.url,
      {this.fit = BoxFit.contain,
      this.height,
      this.width,
      this.errorWidget,
      this.canOpen = true,
      this.isCircle = false});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      width: width,
      fit: fit,
      errorWidget: (a, c, b) =>
          errorWidget ??
          Container(
            height: height ?? 0,
            width: width ?? 0,
            decoration: BoxDecoration(
              color: const Color(0xffE5E5E5),
              shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
            ),
          ),
      placeholder: (c, v) => Container(
        height: height ?? 0,
        width: width ?? 0,
        decoration: BoxDecoration(
          color: const Color(0xffE5E5E5),
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        ),
      ),
    );
  }
}
