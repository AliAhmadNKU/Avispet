import 'package:avispets/utils/my_color.dart';
import 'package:flutter/material.dart';

class RankingProgress extends StatelessWidget {
  final double progress; // Value from 0 to 1000

  RankingProgress({required this.progress});

  @override
  Widget build(BuildContext context) {
    // Clamp progress to a valid range of 0 to 1000
    final double clampedProgress = progress.clamp(0, 1000);
    final double progressPercentage = clampedProgress / 1000; // Value between 0 and 1
    final double screenWidth = MediaQuery.of(context).size.width - 32; // Subtract padding

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Label and Arrow
          Stack(
            children: [
              // "Excellent" label
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Arrow positioned dynamically
              Positioned(
                left: progressPercentage * screenWidth, // Adjust arrow position
                child: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey[700],
                  size: 24,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),

          // Progress Bar
          Stack(
            children: [
              // Background track
              Container(
                height: 20,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: MyColor.orange2,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              // Progress indicator
              FractionallySizedBox(
                widthFactor: progressPercentage, // Adjust width based on progress
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: MyColor.orange2,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),

          // Bottom Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0', // Minimum value
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                '1000', // Maximum value
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}