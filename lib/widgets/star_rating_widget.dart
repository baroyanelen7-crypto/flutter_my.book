import 'package:flutter/material.dart';

class StarRatingWidget extends StatelessWidget {
  final int rating;
  final ValueChanged<int>? onRatingChanged;
  final double size;

  const StarRatingWidget({
    super.key,
    required this.rating,
    this.onRatingChanged,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        const activeColor = Colors.amber;

        if (onRatingChanged == null) {
          return Icon(
            starValue <= rating ? Icons.star : Icons.star_border,
            color: activeColor,
            size: size,
          );
        } else {
          return IconButton(
            iconSize: size,
            icon: Icon(
              starValue <= rating ? Icons.star : Icons.star_border,
              color: activeColor,
            ),
            onPressed: () => onRatingChanged!(starValue),
          );
        }
      }),
    );
  }
}