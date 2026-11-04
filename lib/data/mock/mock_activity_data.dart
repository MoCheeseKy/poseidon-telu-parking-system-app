import 'package:flutter/material.dart';
import 'package:poseidon/data/models/activity_analytics.dart';
import 'package:poseidon/data/models/parking_location.dart';

class MockActivityData {
  MockActivityData._();

  static const ActivityAnalytics motor7Days = ActivityAnalytics(
    avgOccupancy: 73,
    avgOccupancyUnit: '%',
    avgOccupancySub: 'Hari kerja / Jam kuliah aktif',
    monitoredAreas: 5,
    monitoredAreasUnit: 'Lokasi',
    monitoredAreasSub: 'Sensor valid & terkalibrasi',
    peakTime: '09.30 – 11.30',
    peakTimeSub: 'WIB (Zona Kuliah Sesi 1 & 2)',
    chartTitle: 'Tren Okupansi Harian',
    chartSubtitle: 'Pola rata-rata keterisian slot parkir motor',
    bars: [
      OccupancyBarData(
        time: '07:00',
        percentage: 0.34,
        barColor: Color(0xFF8896A6),
      ),
      OccupancyBarData(
        time: '09:00',
        percentage: 0.78,
        barColor: Color(0xFFC07D2B),
      ),
      OccupancyBarData(
        time: '11:00',
        percentage: 0.86,
        isPeak: true,
        peakBadgeText: 'Puncak 10.00 WIB, 86% Keterisian',
        barColor: Color(0xFFE53935),
      ),
      OccupancyBarData(
        time: '13:00',
        percentage: 0.72,
        barColor: Color(0xFFC07D2B),
      ),
      OccupancyBarData(
        time: '15:00',
        percentage: 0.52,
        barColor: Color(0xFF8896A6),
      ),
      OccupancyBarData(
        time: '17:00',
        percentage: 0.28,
        barColor: Color(0xFF48A868),
      ),
    ],
    busySlots: [
      BusyTimeSlot(
        number: '01',
        title: 'Pagi (08.30 – 11.30 WIB)',
        subtitle: 'Kedatangan kuliah sesi 1 & 2',
        level: BusyLevel.padat,
        progress: 0.82,
      ),
      BusyTimeSlot(
        number: '02',
        title: 'Siang (12.00 – 14.30 WIB)',
        subtitle: 'Rotasi jam istirahat & praktikum',
        level: BusyLevel.menengah,
        progress: 0.65,
      ),
      BusyTimeSlot(
        number: '03',
        title: 'Sore (15.00 – 17.30 WIB)',
        subtitle: 'Sebagian mahasiswa telah selesai perkuliahan',
        level: BusyLevel.rendah,
        progress: 0.44,
      ),
    ],
  );

  static const ActivityAnalytics motor30Days = ActivityAnalytics(
    avgOccupancy: 69,
    avgOccupancyUnit: '%',
    avgOccupancySub: 'Rata-rata 30 hari kalender',
    monitoredAreas: 5,
    monitoredAreasUnit: 'Lokasi',
    monitoredAreasSub: 'Sensor valid & terkalibrasi',
    peakTime: '10.00 – 12.00',
    peakTimeSub: 'WIB (Zona Kuliah Sesi 1 & 2)',
    chartTitle: 'Tren Okupansi Bulanan',
    chartSubtitle: 'Pola rata-rata keterisian slot parkir motor',
    bars: [
      OccupancyBarData(
        time: '07:00',
        percentage: 0.30,
        barColor: Color(0xFF8896A6),
      ),
      OccupancyBarData(
        time: '09:00',
        percentage: 0.75,
        barColor: Color(0xFFC07D2B),
      ),
      OccupancyBarData(
        time: '11:00',
        percentage: 0.83,
        isPeak: true,
        peakBadgeText: 'Puncak 10.30 WIB, 83% Keterisian',
        barColor: Color(0xFFE53935),
      ),
      OccupancyBarData(
        time: '13:00',
        percentage: 0.70,
        barColor: Color(0xFFC07D2B),
      ),
      OccupancyBarData(
        time: '15:00',
        percentage: 0.48,
        barColor: Color(0xFF8896A6),
      ),
      OccupancyBarData(
        time: '17:00',
        percentage: 0.25,
        barColor: Color(0xFF48A868),
      ),
    ],
    busySlots: [
      BusyTimeSlot(
        number: '01',
        title: 'Pagi (08.30 – 11.30 WIB)',
        subtitle: 'Puncak mobilitas mahasiswa harian',
        level: BusyLevel.padat,
        progress: 0.80,
      ),
      BusyTimeSlot(
        number: '02',
        title: 'Siang (12.00 – 14.30 WIB)',
        subtitle: 'Pergantian jadwal kuliah & rapat',
        level: BusyLevel.menengah,
        progress: 0.62,
      ),
      BusyTimeSlot(
        number: '03',
        title: 'Sore (15.00 – 17.30 WIB)',
        subtitle: 'Aktivitas UKM & kepulangan',
        level: BusyLevel.rendah,
        progress: 0.40,
      ),
    ],
  );

  static const ActivityAnalytics mobil7Days = ActivityAnalytics(
    avgOccupancy: 61,
    avgOccupancyUnit: '%',
    avgOccupancySub: 'Hari kerja / Dosen & Civitas',
    monitoredAreas: 4,
    monitoredAreasUnit: 'Lokasi',
    monitoredAreasSub: 'Sensor valid & terkalibrasi',
    peakTime: '10.00 – 13.00',
    peakTimeSub: 'WIB (Zona Parkir Mobil Gedung Utama)',
    chartTitle: 'Tren Okupansi Mobil',
    chartSubtitle: 'Pola rata-rata keterisian slot parkir mobil',
    bars: [
      OccupancyBarData(
        time: '07:00',
        percentage: 0.25,
        barColor: Color(0xFF8896A6),
      ),
      OccupancyBarData(
        time: '09:00',
        percentage: 0.65,
        barColor: Color(0xFFC07D2B),
      ),
      OccupancyBarData(
        time: '11:00',
        percentage: 0.81,
        isPeak: true,
        peakBadgeText: 'Puncak 11.00 WIB, 81% Keterisian',
        barColor: Color(0xFFE53935),
      ),
      OccupancyBarData(
        time: '13:00',
        percentage: 0.68,
        barColor: Color(0xFFC07D2B),
      ),
      OccupancyBarData(
        time: '15:00',
        percentage: 0.45,
        barColor: Color(0xFF8896A6),
      ),
      OccupancyBarData(
        time: '17:00',
        percentage: 0.20,
        barColor: Color(0xFF48A868),
      ),
    ],
    busySlots: [
      BusyTimeSlot(
        number: '01',
        title: 'Pagi (08.30 – 11.30 WIB)',
        subtitle: 'Kedatangan dosen dan staf universitas',
        level: BusyLevel.padat,
        progress: 0.78,
      ),
      BusyTimeSlot(
        number: '02',
        title: 'Siang (12.00 – 14.30 WIB)',
        subtitle: 'Kunjungan eksternal & tamu kampus',
        level: BusyLevel.menengah,
        progress: 0.58,
      ),
      BusyTimeSlot(
        number: '03',
        title: 'Sore (15.00 – 17.30 WIB)',
        subtitle: 'Kepulangan pegawai',
        level: BusyLevel.rendah,
        progress: 0.35,
      ),
    ],
  );

  static const ActivityAnalytics mobil30Days = ActivityAnalytics(
    avgOccupancy: 58,
    avgOccupancyUnit: '%',
    avgOccupancySub: 'Rata-rata 30 hari kalender',
    monitoredAreas: 4,
    monitoredAreasUnit: 'Lokasi',
    monitoredAreasSub: 'Sensor valid & terkalibrasi',
    peakTime: '10.00 – 12.30',
    peakTimeSub: 'WIB (Zona Parkir Mobil Gedung Utama)',
    chartTitle: 'Tren Okupansi Mobil Bulanan',
    chartSubtitle: 'Pola rata-rata keterisian slot parkir mobil',
    bars: [
      OccupancyBarData(
        time: '07:00',
        percentage: 0.22,
        barColor: Color(0xFF8896A6),
      ),
      OccupancyBarData(
        time: '09:00',
        percentage: 0.60,
        barColor: Color(0xFFC07D2B),
      ),
      OccupancyBarData(
        time: '11:00',
        percentage: 0.78,
        isPeak: true,
        peakBadgeText: 'Puncak 10.45 WIB, 78% Keterisian',
        barColor: Color(0xFFC07D2B),
      ),
      OccupancyBarData(
        time: '13:00',
        percentage: 0.65,
        barColor: Color(0xFFC07D2B),
      ),
      OccupancyBarData(
        time: '15:00',
        percentage: 0.40,
        barColor: Color(0xFF8896A6),
      ),
      OccupancyBarData(
        time: '17:00',
        percentage: 0.18,
        barColor: Color(0xFF48A868),
      ),
    ],
    busySlots: [
      BusyTimeSlot(
        number: '01',
        title: 'Pagi (08.30 – 11.30 WIB)',
        subtitle: 'Kedatangan dosen dan staf universitas',
        level: BusyLevel.padat,
        progress: 0.74,
      ),
      BusyTimeSlot(
        number: '02',
        title: 'Siang (12.00 – 14.30 WIB)',
        subtitle: 'Kunjungan eksternal & tamu kampus',
        level: BusyLevel.menengah,
        progress: 0.54,
      ),
      BusyTimeSlot(
        number: '03',
        title: 'Sore (15.00 – 17.30 WIB)',
        subtitle: 'Kepulangan pegawai',
        level: BusyLevel.rendah,
        progress: 0.32,
      ),
    ],
  );

  static ActivityAnalytics getAnalytics({
    required VehicleType vehicleType,
    required TimeRangeFilter timeRange,
  }) {
    if (vehicleType == VehicleType.motor) {
      return timeRange == TimeRangeFilter.days7 ? motor7Days : motor30Days;
    } else {
      return timeRange == TimeRangeFilter.days7 ? mobil7Days : mobil30Days;
    }
  }
}
