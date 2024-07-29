import 'package:flutter/material.dart';
import 'package:flutter_task/config/app_colors.dart';
import 'package:shimmer/shimmer.dart';

///
/// Created by Auro on 29/07/24
///

class ProductGridShimmer extends StatelessWidget {
  const ProductGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 70),
      itemBuilder: (c, i) {
        return Shimmer.fromColors(
          baseColor: AppColors.shimmerBaseColor,
          highlightColor: Colors.white.withOpacity(0.6),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.6,
      ),
      itemCount: 8,
    );
  }
}

class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: Colors.white.withOpacity(0.6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
