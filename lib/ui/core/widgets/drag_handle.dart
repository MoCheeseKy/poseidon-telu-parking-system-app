import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';

class DragHandle extends StatelessWidget {
  const DragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 8.0, bottom: 12.0),
        width: 36.0,
        height: 4.0,
        decoration: BoxDecoration(
          color: AppColors.dragHandle,
          borderRadius: BorderRadius.circular(2.0),
        ),
      ),
    );
  }
}
