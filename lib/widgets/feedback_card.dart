import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// A feedback item data class used by FeedbackScreen.
class FeedbackItem {
  final String flag;
  final String name;
  final String country;
  final String text;
  final int stars;

  const FeedbackItem({
    required this.flag,
    required this.name,
    required this.country,
    required this.text,
    required this.stars,
  });
}

/// A standalone card that displays a single customer feedback entry.
/// Used on both FeedbackScreen and HomeScreen.
/// Estimated lines: ~90
class FeedbackCard extends StatelessWidget {
  final String flag;
  final String name;
  final String country;
  final String text;
  final int stars;

  const FeedbackCard({
    super.key,
    required this.flag,
    required this.name,
    required this.country,
    required this.text,
    required this.stars,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final nameFont = width < 340 ? 15.0 : 17.0;
        final textFont = width < 340 ? 12.5 : 13.5;
        final countryFont = width < 340 ? 10.0 : 11.0;
        final flagFont = width < 340 ? 21.0 : 24.0;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            width < 340 ? 11 : 14,
            12,
            width < 340 ? 11 : 14,
            12,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(flag, style: TextStyle(fontSize: flagFont)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.olive,
                        fontSize: nameFont,
                        fontFamily: 'serif',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      country,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: countryFont,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                '★' * stars,
                style: const TextStyle(
                  color: AppColors.gold,
                  fontSize: 15,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                text,
                style: TextStyle(
                  color: AppColors.olive,
                  fontSize: textFont,
                  height: 1.35,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
