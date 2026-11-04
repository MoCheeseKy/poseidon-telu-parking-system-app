import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';
import 'package:poseidon/data/mock/mock_notification_data.dart';
import 'package:poseidon/ui/features/notifications/views/notification_screen.dart';

/// Shared white sub-page AppBar matching Pusat Bantuan, Tentang Kami, and Notifikasi designs.
class PoseidonSubAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showActions;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onBackTap;

  const PoseidonSubAppBar({
    super.key,
    required this.title,
    this.showActions = true,
    this.onNotificationTap,
    this.onProfileTap,
    this.onBackTap,
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
      leading: IconButton(
        tooltip: 'Kembali',
        icon: const Icon(
          Icons.arrow_back,
          color: AppColors.textPrimary,
          size: 22.0,
        ),
        onPressed: onBackTap ?? () => Navigator.maybePop(context),
      ),
      titleSpacing: 0,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 17.0,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.2,
          color: AppColors.textPrimary,
        ),
      ),
      actions: showActions
          ? [
              ListenableBuilder(
                listenable: MockNotificationData.sharedStore,
                builder: (context, _) {
                  final unreadCount =
                      MockNotificationData.sharedStore.unreadCount;
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
                          color: Color(0xFF525866),
                          size: 23.0,
                        ),
                        if (unreadCount > 0)
                          Positioned(
                            right: 1.0,
                            top: 1.0,
                            child: Container(
                              width: 7.5,
                              height: 7.5,
                              decoration: BoxDecoration(
                                color: AppColors.avatarDeepRed,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.2,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              GestureDetector(
                onTap: onProfileTap ?? () => Navigator.maybePop(context),
                child: Container(
                  margin: const EdgeInsets.only(right: 16.0, left: 4.0),
                  width: 34.0,
                  height: 34.0,
                  decoration: const BoxDecoration(
                    color: AppColors.avatarDeepRed,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 19.0,
                    ),
                  ),
                ),
              ),
            ]
          : null,
    );
  }
}
