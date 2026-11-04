import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';
import 'package:poseidon/data/mock/mock_user_profile_data.dart';
import 'package:poseidon/ui/core/widgets/poseidon_sub_app_bar.dart';

class NotificationSettingsScreen extends StatelessWidget {
  final UserProfileStore? store;

  const NotificationSettingsScreen({
    super.key,
    this.store,
  });

  static MaterialPageRoute<void> route({UserProfileStore? store}) {
    return MaterialPageRoute<void>(
      builder: (_) => NotificationSettingsScreen(store: store),
    );
  }

  UserProfileStore get _store => store ?? MockUserProfileData.sharedStore;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: const PoseidonSubAppBar(title: 'Pengaturan Notifikasi'),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600.0),
            child: ListenableBuilder(
              listenable: _store,
              builder: (context, _) {
                final prefs = _store.notificationPreferences;

                return ListView(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 32.0),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const Text(
                      'JENIS PEMBERITAHUAN',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10.0),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18.0),
                        border: Border.all(color: AppColors.subtleCardBorder),
                      ),
                      child: Column(
                        children: [
                          _buildSwitchRow(
                            title: 'Pembaruan Laporan Parkir',
                            subtitle:
                                'Kabar saat laporan ditinjau atau selesai ditangani',
                            value: prefs.reportStatusUpdates,
                            onChanged: (val) {
                              _store.updateNotificationPreferences(
                                prefs.copyWith(reportStatusUpdates: val),
                              );
                            },
                          ),
                          const Divider(
                            height: 1.0,
                            color: Color(0xFFF3F4F6),
                            indent: 18.0,
                            endIndent: 18.0,
                          ),
                          _buildSwitchRow(
                            title: 'Peringatan Parkir Penuh',
                            subtitle:
                                'Pemberitahuan saat kantong parkir favorit hampir penuh',
                            value: prefs.parkingFullAlerts,
                            onChanged: (val) {
                              _store.updateNotificationPreferences(
                                prefs.copyWith(parkingFullAlerts: val),
                              );
                            },
                          ),
                          const Divider(
                            height: 1.0,
                            color: Color(0xFFF3F4F6),
                            indent: 18.0,
                            endIndent: 18.0,
                          ),
                          _buildSwitchRow(
                            title: 'Kondisi Sensor Parkir',
                            subtitle:
                                'Informasi gangguan atau pemeliharaan sensor di lapangan',
                            value: prefs.sensorOfflineAlerts,
                            onChanged: (val) {
                              _store.updateNotificationPreferences(
                                prefs.copyWith(sensorOfflineAlerts: val),
                              );
                            },
                          ),
                          const Divider(
                            height: 1.0,
                            color: Color(0xFFF3F4F6),
                            indent: 18.0,
                            endIndent: 18.0,
                          ),
                          _buildSwitchRow(
                            title: 'Info Lalu Lintas Kampus',
                            subtitle:
                                'Pengalihan akses gerbang saat wisuda atau acara kampus',
                            value: prefs.campusTrafficInfo,
                            onChanged: (val) {
                              _store.updateNotificationPreferences(
                                prefs.copyWith(campusTrafficInfo: val),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24.0),

                    const Text(
                      'JADWAL',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10.0),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18.0),
                        border: Border.all(color: AppColors.subtleCardBorder),
                      ),
                      child: _buildSwitchRow(
                        title: 'Senyapkan Malam Hari',
                        subtitle:
                            'Nonaktifkan bunyi notifikasi pukul 21.00 – 06.00 WIB',
                        value: prefs.quietHoursEnabled,
                        onChanged: (val) {
                          _store.updateNotificationPreferences(
                            prefs.copyWith(quietHoursEnabled: val),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13.8,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3.0),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12.0,
                    height: 1.35,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12.0),
          Switch(
            value: value,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.primaryRed,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
