import 'package:flutter/material.dart';
import 'package:poseidon/core/constants/app_colors.dart';
import 'package:poseidon/data/mock/mock_notification_data.dart';
import 'package:poseidon/data/models/app_notification.dart';
import 'package:poseidon/ui/core/widgets/drag_handle.dart';
import 'package:poseidon/ui/core/widgets/poseidon_sub_app_bar.dart';

class NotificationScreen extends StatefulWidget {
  final NotificationStore? store;

  const NotificationScreen({
    super.key,
    this.store,
  });

  static MaterialPageRoute<void> route({NotificationStore? store}) {
    return MaterialPageRoute<void>(
      builder: (_) => NotificationScreen(store: store),
    );
  }

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _onlyUnread = false;

  NotificationStore get _store =>
      widget.store ?? MockNotificationData.sharedStore;

  void _openNotificationDetail(AppNotification item) {
    _store.markAsRead(item.id);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
          ),
          padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 24.0),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DragHandle(),
                Text(
                  item.title.replaceAll('...', ' Periode I'),
                  style: const TextStyle(
                    fontSize: 18.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6.0),
                Text(
                  '${item.categoryLabel} • ${item.timeLabel}',
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 14.0),
                const Divider(height: 1.0, color: Color(0xFFF1F3F5)),
                const SizedBox(height: 14.0),
                Text(
                  item.fullDetail,
                  style: const TextStyle(
                    fontSize: 13.5,
                    height: 1.55,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  height: 46.0,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(sheetContext),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: const Text(
                      'Tutup',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: const PoseidonSubAppBar(
        title: 'Notifikasi',
        showActions: false,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600.0),
            child: ListenableBuilder(
              listenable: _store,
              builder: (context, _) {
                final allItems = _store.notifications;
                final unreadCount = _store.unreadCount;
                final filteredItems = _onlyUnread
                    ? allItems.where((n) => n.isUnread).toList()
                    : allItems;

                final todayItems = filteredItems
                    .where((n) => n.section == NotificationSection.today)
                    .toList();
                final yesterdayItems = filteredItems
                    .where((n) => n.section == NotificationSection.yesterday)
                    .toList();

                final todayUnreadCount =
                    todayItems.where((n) => n.isUnread).length;

                return ListView(
                  padding: const EdgeInsets.fromLTRB(20.0, 18.0, 20.0, 32.0),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Top Filter Pills & Tandai Dibaca Action
                    _buildFilterRow(unreadCount),
                    const SizedBox(height: 20.0),

                    if (filteredItems.isEmpty)
                      _buildEmptyUnreadState()
                    else ...[
                      if (todayItems.isNotEmpty) ...[
                        _buildSectionHeader(
                          title: 'HARI INI',
                          trailing: todayUnreadCount > 0
                              ? '$todayUnreadCount Notifikasi Baru'
                              : '${todayItems.length} Pembaruan',
                        ),
                        const SizedBox(height: 10.0),
                        for (int i = 0; i < todayItems.length; i++) ...[
                          if (i > 0) const SizedBox(height: 12.0),
                          _buildNotificationCard(todayItems[i]),
                        ],
                      ],
                      if (todayItems.isNotEmpty && yesterdayItems.isNotEmpty)
                        const SizedBox(height: 22.0),
                      if (yesterdayItems.isNotEmpty) ...[
                        _buildSectionHeader(
                          title: 'KEMARIN',
                          trailing: '${yesterdayItems.length} Pembaruan',
                        ),
                        const SizedBox(height: 10.0),
                        for (int i = 0; i < yesterdayItems.length; i++) ...[
                          if (i > 0) const SizedBox(height: 12.0),
                          _buildNotificationCard(yesterdayItems[i]),
                        ],
                      ],
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterRow(int unreadCount) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: 8.0,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Pill 1: Semua
            GestureDetector(
              onTap: () {
                if (_onlyUnread) {
                  setState(() => _onlyUnread = false);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  color: !_onlyUnread
                      ? const Color(0xFF1E2025)
                      : const Color(0xFFEDEBEB),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  'Semua',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: !_onlyUnread
                        ? Colors.white
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0),

            // Pill 2: Belum Dibaca (2)
            GestureDetector(
              onTap: () {
                if (!_onlyUnread) {
                  setState(() => _onlyUnread = true);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  color: _onlyUnread
                      ? const Color(0xFF1E2025)
                      : const Color(0xFFEDEBEB),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text.rich(
                  TextSpan(
                    text: 'Belum Dibaca ',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: _onlyUnread
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                    children: [
                      TextSpan(
                        text: '($unreadCount)',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: _onlyUnread
                              ? Colors.white
                              : AppColors.avatarDeepRed,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        // Right Action: Tandai Dibaca
        InkWell(
          borderRadius: BorderRadius.circular(8.0),
          onTap: unreadCount > 0
              ? () {
                  _store.markAllAsRead();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.textPrimary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      content: const Text(
                        'Semua notifikasi ditandai telah dibaca.',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  );
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.done_all,
                  size: 16.0,
                  color: unreadCount > 0
                      ? AppColors.avatarDeepRed
                      : AppColors.textMuted,
                ),
                const SizedBox(width: 4.0),
                Text(
                  'Tandai Dibaca',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: unreadCount > 0
                        ? AppColors.avatarDeepRed
                        : AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String trailing,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          trailing,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationCard(AppNotification item) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(18.0),
        onTap: () => _openNotificationDetail(item),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.0),
            border: Border.all(color: AppColors.subtleCardBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44.0,
                height: 44.0,
                decoration: BoxDecoration(
                  color: item.softBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    item.leadingIcon,
                    color: item.accentColor,
                    size: 21.0,
                  ),
                ),
              ),
              const SizedBox(width: 14.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.2,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (item.isUnread) ...[
                          const SizedBox(width: 8.0),
                          Container(
                            margin: const EdgeInsets.only(top: 5.0),
                            width: 8.5,
                            height: 8.5,
                            decoration: const BoxDecoration(
                              color: AppColors.avatarDeepRed,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      item.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13.0,
                        height: 1.4,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 6.0,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          item.timeLabel,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.5,
                            vertical: 3.5,
                          ),
                          decoration: BoxDecoration(
                            color: item.softBackgroundColor,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                item.badgeIcon,
                                size: 12.0,
                                color: item.accentColor,
                              ),
                              const SizedBox(width: 4.5),
                              Text(
                                item.categoryLabel,
                                style: TextStyle(
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w700,
                                  color: item.accentColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyUnreadState() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.0),
        border: Border.all(color: AppColors.subtleCardBorder),
      ),
      child: const Center(
        child: Text(
          'Tidak ada notifikasi yang belum dibaca.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.5,
            color: AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

