import 'package:poseidon/data/models/report_item.dart';

class MockReportData {
  MockReportData._();

  static const List<ReportItem> initialReports = [
    ReportItem(
      id: 'rep_001',
      reportNumber: '#R-00001-020326',
      title: 'Parkir Menghalangi Akses Keluar Parkiran',
      description:
          'Satu unit sepeda motor diparkir melintang tepat di depan jalur keluar darurat lorong barat, menghambat akses pejalan kaki.',
      status: ReportStatus.selesai,
      timestamp: '18 Agustur 1945, 18:00 WIB',
      reportDate: '18 Agustus 1945',
      reportTime: '18:00 WIB',
      locationName: 'Gedung Parkir TULT (Lantai 1)',
      specificLocation: 'Blok B3 dekat akses tangga keluar darurat barat',
      category: 'Parkir menghalangi akses',
      imageAttachment: 'assets/images/parking_evidence.jpg',
      attachmentBadge: '1 Lampiran (JPG)',
      notes: 'Petugas keamanan telah memindahkan kendaraan dari depan pintu darurat.',
    ),
    ReportItem(
      id: 'rep_002',
      reportNumber: '#R-00002-020326',
      title: 'Parkir di Luar Marka',
      description:
          'Kendaraan roda dua terparkir menyerong melewati dua kotak marka parkir motor.',
      status: ReportStatus.sedangDitinjau,
      timestamp: '18 Agustur 1945, 18:00 WIB',
      reportDate: '18 Agustus 1945',
      reportTime: '18:00 WIB',
      locationName: 'Lot Parkir GKU Selaru (Lantai Dasar)',
      specificLocation: 'Area samping tangga gedung Selaru',
      category: 'Parkir di luar marka',
      imageAttachment: 'assets/images/parking_evidence.jpg',
      attachmentBadge: '1 Lampiran (JPG)',
      notes: 'Laporan telah diteruskan ke petugas patroli shift siang.',
    ),
    ReportItem(
      id: 'rep_003',
      reportNumber: '#R-00003-020326',
      title: 'Parkir di Luar Marka',
      description:
          'Terdapat mobil yang terparkir di zona drop-off gedung tanpa pengemudi.',
      status: ReportStatus.ditindaklanjuti,
      timestamp: '18 Agustur 1945, 18:00 WIB',
      reportDate: '18 Agustus 1945',
      reportTime: '18:00 WIB',
      locationName: 'Parkir Gedung Cacuk (FRI)',
      specificLocation: 'Blok depan lobi utama gedung Cacuk',
      category: 'Parkir sembarangan',
      imageAttachment: 'assets/images/parking_evidence.jpg',
      attachmentBadge: '1 Lampiran (JPG)',
      notes: 'Petugas pengatur parkir sedang menghubungi pemilik kendaraan.',
    ),
  ];
}
