import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';
import 'package:poseidon/data/mock/mock_notification_data.dart';
import 'package:poseidon/ui/core/widgets/poseidon_brand_logo.dart';
import 'package:poseidon/ui/features/notifications/views/notification_screen.dart';

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
                return const PoseidonBrandLogo(
                  size: 30.0,
                  borderRadius: 8.0,
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
        ListenableBuilder(
          listenable: MockNotificationData.sharedStore,
          builder: (context, _) {
            final unreadCount = MockNotificationData.sharedStore.unreadCount;
            return IconButton(
              tooltip: 'Notifikasi',
              onPressed:
                  onNotificationTap ??
                  () {
                    Navigator.push(context, NotificationScreen.route());
                  },
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(
                    Icons.notifications_none_outlined,
                    color: AppColors.textPrimary,
                    size: 24.0,
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      right: 1.0,
                      top: 1.0,
                      child: Container(
                        width: 8.0,
                        height: 8.0,
                        decoration: BoxDecoration(
                          color: AppColors.avatarDeepRed,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.2),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        GestureDetector(
          onTap: onProfileTap ?? () {},
          child: Container(
            margin: const EdgeInsets.only(right: 16.0, left: 4.0),
            width: 34.0,
            height: 34.0,
            decoration: const BoxDecoration(
              color: AppColors.avatarDeepRed,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.person_outline, color: Colors.white, size: 19.0),
            ),
          ),
        ),
      ],
    );
  }
}
