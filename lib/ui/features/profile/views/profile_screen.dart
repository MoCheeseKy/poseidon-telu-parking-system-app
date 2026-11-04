import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';
import 'package:poseidon/data/mock/mock_user_profile_data.dart';
import 'package:poseidon/data/models/parking_location.dart';
import 'package:poseidon/ui/core/widgets/poseidon_app_bar.dart';
import 'package:poseidon/ui/features/auth/views/login_screen.dart';
import 'package:poseidon/ui/features/profile/views/about_us_screen.dart';
import 'package:poseidon/ui/features/profile/views/edit_profile_screen.dart';
import 'package:poseidon/ui/features/profile/views/favorite_parking_screen.dart';
import 'package:poseidon/ui/features/profile/views/help_center_screen.dart';
import 'package:poseidon/ui/features/profile/views/notification_settings_screen.dart';
import 'package:poseidon/ui/features/profile/views/registered_vehicles_screen.dart';

class ProfileScreen extends StatelessWidget {
  final bool showScaffold;
  final UserProfileStore? profileStore;
  final ValueChanged<ParkingLocation>? onNavigateToParking;

  const ProfileScreen({
    super.key,
    this.showScaffold = true,
    this.profileStore,
    this.onNavigateToParking,
  });

  UserProfileStore get _profileStore =>
      profileStore ?? MockUserProfileData.sharedStore;

  @override
  Widget build(BuildContext context) {
    final content = _buildContent(context);
    if (!showScaffold) return content;

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: const PoseidonAppBar(),
      body: content,
    );
  }

  Widget _buildContent(BuildContext context) {
    return SafeArea(
      top: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600.0),
          child: ListenableBuilder(
            listenable: _profileStore,
            builder: (context, _) {
              final profile = _profileStore.profile;

              return ListView(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 32.0),
                physics: const BouncingScrollPhysics(),
                children: [
                  // Profile Card (Logged-in vs Guest)
                  if (_profileStore.isLoggedIn)
                    Container(
                      key: const Key('logged_in_profile_card'),
                      padding: const EdgeInsets.all(18.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18.0),
                        border: Border.all(color: AppColors.subtleCardBorder),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 8.0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52.0,
                            height: 52.0,
                            decoration: const BoxDecoration(
                              color: AppColors.avatarDeepRed,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.person_outline,
                                color: Colors.white,
                                size: 26.0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profile.fullName,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.2,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 3.0),
                                Text(
                                  profile.email,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12.8,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      key: const Key('guest_profile_card'),
                      padding: const EdgeInsets.all(18.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18.0),
                        border: Border.all(color: AppColors.subtleCardBorder),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 8.0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              CircleAvatar(
                                radius: 24.0,
                                backgroundColor: Color(0xFFF3F4F6),
                                child: Icon(
                                  Icons.person_outline_rounded,
                                  color: Color(0xFF6B7280),
                                  size: 26.0,
                                ),
                              ),
                              SizedBox(width: 14.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Belum Masuk Akun',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: 3.0),
                                    Text(
                                      'Masuk dengan akun SSO Telkom University',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14.0),
                          SizedBox(
                            width: double.infinity,
                            height: 44.0,
                            child: ElevatedButton.icon(
                              key: const Key('profile_login_button'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  LoginScreen.route(store: _profileStore),
                                );
                              },
                              icon: const Icon(Icons.login_rounded, size: 18.0),
                              label: const Text('Masuk ke Akun'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryRed,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24.0),

                  // Section 1: AKUN & PARKIR
                  const Text(
                    'AKUN & PARKIR',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10.0),

                  _buildGroupedMenuCard([
                    _ProfileMenuItem(
                      icon: Icons.person_outline_rounded,
                      title: 'Edit Profil',
                      onTap: () {
                        Navigator.push(
                          context,
                          EditProfileScreen.route(store: _profileStore),
                        );
                      },
                    ),
                    _ProfileMenuItem(
                      icon: Icons.two_wheeler_outlined,
                      title: 'Kendaraan Terdaftar',
                      onTap: () {
                        Navigator.push(
                          context,
                          RegisteredVehiclesScreen.route(store: _profileStore),
                        );
                      },
                    ),
                    _ProfileMenuItem(
                      icon: Icons.bookmark_border_rounded,
                      title: 'Lokasi Parkir Favorit',
                      onTap: () {
                        Navigator.push(
                          context,
                          FavoriteParkingScreen.route(
                            store: _profileStore,
                            onNavigateToMap: onNavigateToParking,
                          ),
                        );
                      },
                    ),
                  ]),
                  const SizedBox(height: 24.0),

                  // Section 2: PENGATURAN & INFORMASI
                  const Text(
                    'PENGATURAN & INFORMASI',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10.0),

                  _buildGroupedMenuCard([
                    _ProfileMenuItem(
                      icon: Icons.notifications_none_rounded,
                      title: 'Pengaturan Notifikasi',
                      onTap: () {
                        Navigator.push(
                          context,
                          NotificationSettingsScreen.route(
                            store: _profileStore,
                          ),
                        );
                      },
                    ),
                    _ProfileMenuItem(
                      icon: Icons.help_outline_rounded,
                      title: 'Pusat Bantuan',
                      onTap: () {
                        Navigator.push(context, HelpCenterScreen.route());
                      },
                    ),
                    _ProfileMenuItem(
                      icon: Icons.info_outline_rounded,
                      title: 'Tentang Kami',
                      onTap: () {
                        Navigator.push(context, AboutUsScreen.route());
                      },
                    ),
                  ]),
                  // Logout Action Button (Only shown when logged in)
                  if (_profileStore.isLoggedIn) ...[
                    const SizedBox(height: 24.0),
                    SizedBox(
                      width: double.infinity,
                      height: 48.0,
                      child: OutlinedButton.icon(
                        key: const Key('profile_logout_button'),
                        onPressed: () => _showLogoutDialog(context),
                        icon: const Icon(
                          Icons.logout_rounded,
                          size: 18.0,
                          color: AppColors.primaryRed,
                        ),
                        label: const Text(
                          'Keluar dari Akun',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryRed,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFFED7D7)),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          title: const Text(
            'Keluar dari Akun',
            style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          content: const Text(
            'Apakah Anda yakin ingin keluar dari akun SSO Telkom University?',
            style: TextStyle(
              fontSize: 13.5,
              color: AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Batal',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
            ElevatedButton(
              key: const Key('confirm_logout_button'),
              onPressed: () {
                Navigator.pop(dialogContext);
                _profileStore.logout();
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text('Anda telah keluar dari akun'),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ),
                  );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text(
                'Keluar',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGroupedMenuCard(List<_ProfileMenuItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(color: AppColors.subtleCardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0)
              const Divider(
                height: 1.0,
                thickness: 1.0,
                color: Color(0xFFF3F4F6),
                indent: 18.0,
                endIndent: 18.0,
              ),
            _buildMenuRow(items[i]),
          ],
        ],
      ),
    );
  }

  Widget _buildMenuRow(_ProfileMenuItem item) {
    return InkWell(
      borderRadius: BorderRadius.circular(18.0),
      onTap: item.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
        child: Row(
          children: [
            Icon(
              item.icon,
              size: 20.0,
              color: const Color(0xFF525866),
            ),
            const SizedBox(width: 14.0),
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(
                  fontSize: 13.8,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 20.0,
              color: Color(0xFF6B7280),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileMenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
