import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A widget that displays a shimmer effect with customizable shapes.
class ShimmerView extends StatelessWidget {
  /// Constructs a rectangular [ShimmerView].
  const ShimmerView.rectangular({
    required this.height,
    super.key,
    this.width = double.infinity,
    this.shapeBorder,
    this.radius,
  });

  /// Constructs a circular [ShimmerView].
  const ShimmerView.circular({
    required this.height,
    super.key,
    this.width = double.infinity,
    this.radius,
    this.shapeBorder = const CircleBorder(),
  });

  /// The width of the shimmer container.
  final double width;

  /// The height of the shimmer container.
  final double height;

  /// The shape of the shimmer container.
  final ShapeBorder? shapeBorder;

  /// The radius of the shimmer container.
  final double? radius;

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: Colors.grey[500]!.withOpacity(0.5),
        highlightColor: Colors.grey[300]!,
        period: const Duration(seconds: 2),
        child: Container(
          width: width,
          height: height,
          decoration: ShapeDecoration(
            color: Colors.grey[300],
            shape: shapeBorder ??
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      radius ?? 4,
                    ),
                  ),
                ),
          ),
        ),
      );
}
