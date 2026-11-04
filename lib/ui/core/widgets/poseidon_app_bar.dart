import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';

class PoseidonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const PoseidonAppBar({
    super.key,
    this.onNotificationTap,
    this.onProfileTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 16.0,
      title: Row(
        children: [
          // Poseidon Brand Logo
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              'assets/images/poseidong_logo.jpg',
              width: 30.0,
              height: 30.0,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 30.0,
                  height: 30.0,
                  decoration: BoxDecoration(
                    color: AppColors.primaryRed,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Center(
                    child: Text(
                      'P',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 10.0),
          const Expanded(
            child: Text(
              'Poseidon Smart Parking',
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
                color: AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'Notifikasi',
          icon: const Icon(
            Icons.notifications_none_outlined,
            color: AppColors.textPrimary,
            size: 24.0,
          ),
          onPressed: onNotificationTap ?? () {},
        ),
        GestureDetector(
          onTap: onProfileTap ?? () {},
          child: Container(
            margin: const EdgeInsets.only(right: 16.0, left: 4.0),
            width: 34.0,
            height: 34.0,
            decoration: const BoxDecoration(
              color: AppColors.primaryRed,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.person, color: Colors.white, size: 20.0),
            ),
          ),
        ),
      ],
    );
  }
}
