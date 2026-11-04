import 'package:flutter/foundation.dart';
import 'package:poseidon/data/models/app_notification.dart';

class NotificationStore extends ChangeNotifier {
  NotificationStore({List<AppNotification>? initialNotifications})
    : _notifications = List<AppNotification>.from(
        initialNotifications ?? MockNotificationData.defaultNotifications,
      );

  List<AppNotification> _notifications;

  List<AppNotification> get notifications => List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((item) => item.isUnread).length;

  void markAsRead(String id) {
    final index = _notifications.indexWhere((item) => item.id == id);
    if (index == -1 || !_notifications[index].isUnread) return;
    _notifications[index] = _notifications[index].copyWith(isUnread: false);
    notifyListeners();
  }

  void markAllAsRead() {
    if (unreadCount == 0) return;
    _notifications = _notifications
        .map((item) => item.isUnread ? item.copyWith(isUnread: false) : item)
        .toList();
    notifyListeners();
  }

  void resetToDefault() {
    _notifications = List<AppNotification>.from(
      MockNotificationData.defaultNotifications,
    );
    notifyListeners();
  }
}

class MockNotificationData {
  MockNotificationData._();

  static final NotificationStore sharedStore = NotificationStore();

  static const List<AppNotification> defaultNotifications = [
    AppNotification(
      id: 'notif_1',
      title: 'Laporan Sedang Ditinjau Petugas',
      message:
          'Petugas pos TULT telah bergerak ke Gedung Parkir TULT (Lantai 1) untuk menindaklanjuti laporan akses keluar.',
      fullDetail:
          'Petugas keamanan pos TULT telah bergerak menuju Gedung Parkir TULT (Lantai 1) untuk memeriksa kendaraan yang dilaporkan menghalangi jalur keluar darurat barat. Pembaruan status akan dikirimkan setelah penertiban selesai.',
      timeLabel: '10 menit lalu',
      categoryLabel: 'Laporan Parkir',
      section: NotificationSection.today,
      categoryType: NotificationCategoryType.parkingReportPending,
      isUnread: true,
    ),
    AppNotification(
      id: 'notif_2',
      title: 'Sensor Offline — Parkir Nanas',
      message:
          'Koneksi gateway sensor di Gedung Parkir Nanas mengalami kendala teknis.',
      fullDetail:
          'Koneksi gateway IoT sensor parkir di area Parkir Nanas mengalami gangguan jaringan sejak pukul 08:15 WIB. Tim teknis sedang melakukan pengecekan perangkat di lapangan. Selama pemeliharaan berlangsung, kapasitas ditampilkan sesuai Epistemic Sensor Logic.',
      timeLabel: '08:15 WIB',
      categoryLabel: 'Kondisi Sensor',
      section: NotificationSection.today,
      categoryType: NotificationCategoryType.sensorStatus,
      isUnread: true,
    ),
    AppNotification(
      id: 'notif_3',
      title: 'Rekayasa Arus Parkir Wisuda...',
      message:
          'Akses gerbang timur FIT dialihkan khusus tamu wisuda mulai Sabtu, 26 Okt',
      fullDetail:
          'Sehubungan dengan pelaksanaan Wisuda Telkom University, akses gerbang timur Fakultas Ilmu Terapan (FIT) dialihkan khusus kendaraan tamu undangan mulai Sabtu, 26 Oktober pukul 06.00 – 15.00 WIB. Mahasiswa disarankan menggunakan kantong parkir TULT, GKU, atau MSU.',
      timeLabel: '24 Okt 2024',
      categoryLabel: 'Info Kampus',
      section: NotificationSection.yesterday,
      categoryType: NotificationCategoryType.campusInfo,
      isUnread: false,
    ),
    AppNotification(
      id: 'notif_4',
      title: 'Laporan Selesai Ditangani',
      message:
          'Kendaraan di selasar GKU Selaru telah ditertibkan oleh tim keamanan kampus pada pukul 14:20 WIB.',
      fullDetail:
          'Laporan ketertiban parkir Anda untuk area selasar GKU – Selaru telah selesai ditindaklanjuti oleh tim keamanan kampus. Akses pejalan kaki kini kembali normal. Terima kasih atas kontribusi Anda menjaga ketertiban parkir kampus.',
      timeLabel: '21 Okt 2024',
      categoryLabel: 'Laporan Parkir',
      section: NotificationSection.yesterday,
      categoryType: NotificationCategoryType.parkingReportResolved,
      isUnread: false,
    ),
  ];
}

