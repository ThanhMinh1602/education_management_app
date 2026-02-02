import 'package:blooket/app/core/constants/app_color.dart';
import 'package:blooket/app/modules/user/exercises/widgets/start_button.dart';
import 'package:flutter/material.dart';

class ExerciseCard extends StatelessWidget {
  final String level;
  final String range;
  final VoidCallback onStart;

  const ExerciseCard({
    super.key,
    required this.level,
    required this.range,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.pink,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // Trong build method của ExerciseCard
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  // Giúp chữ tự co giãn nếu card quá nhỏ
                  fit: BoxFit.scaleDown,
                  child: Text(
                    level,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    range,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          StartButton(onTap: onStart),
        ],
      ),
    );
  }
}
