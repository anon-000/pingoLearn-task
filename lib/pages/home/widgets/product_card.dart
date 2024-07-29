import 'package:flutter/material.dart';
import 'package:flutter_task/config/app_colors.dart';
import 'package:flutter_task/data_models/product_model.dart';
import 'package:flutter_task/utils/common_functions.dart';
import 'package:flutter_task/widgets/common/cached_image.dart';

///
/// Created by Auro on 29/07/24
///

class ProductCard extends StatelessWidget {
  final ProductModel datum;
  final bool showDiscountedPrice;

  const ProductCard(this.datum, {super.key, this.showDiscountedPrice = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Expanded(
            child: CachedImage("${datum.thumbnail}"),
          ),
          Text(
            "${datum.title}",
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            "${datum.description}",
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          showDiscountedPrice
              ? Row(
                  children: [
                    Flexible(
                      child: Text(
                        "\$${datum.price?.toStringAsFixed(0)}",
                        style: const TextStyle(
                          color: AppColors.greyTextColor,
                          fontStyle: FontStyle.italic,
                          decoration: TextDecoration.lineThrough,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        "\$${calculateDiscountedAmount(datum.price ?? 0, datum.discountPercentage ?? 0).toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        "${datum.discountPercentage?.toStringAsFixed(2)}%",
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: AppColors.greenBrightColor,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              : Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "\$${datum.price?.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
        ],
      ),
    );
  }
}
