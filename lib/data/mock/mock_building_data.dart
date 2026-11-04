import 'package:poseidon/data/models/building.dart';

class MockBuildingData {
  MockBuildingData._();

  static const Building tultBuilding = Building(
    id: 'tult',
    name: 'Gedung TULT',
    code: 'TULT',
    area: 'Telkom University Landmark Tower',
    latitude: -6.969250,
    longitude: 107.628850,
    entranceLatitude: -6.969510,
    entranceLongitude: 107.628920,
  );

  static const Building gkuBuilding = Building(
    id: 'gku',
    name: 'Gedung Kuliah Umum (GKU)',
    code: 'GKU',
    area: 'Gedung Tokong Nanas',
    latitude: -6.973050,
    longitude: 107.629950,
    entranceLatitude: -6.972620,
    entranceLongitude: 107.629820,
  );

  static const Building fitBuilding = Building(
    id: 'fit',
    name: 'Gedung Selaru (FIT)',
    code: 'FIT',
    area: 'Fakultas Ilmu Terapan',
    latitude: -6.972780,
    longitude: 107.632350,
    entranceLatitude: -6.972490,
    entranceLongitude: 107.631910,
  );

  static const Building febBuilding = Building(
    id: 'feb',
    name: 'Gedung Miossu (FEB)',
    code: 'FEB',
    area: 'Fakultas Ekonomi dan Bisnis',
    latitude: -6.971480,
    longitude: 107.632050,
    entranceLatitude: -6.971320,
    entranceLongitude: 107.631820,
  );

  static const Building rektoratBuilding = Building(
    id: 'rektorat',
    name: 'Gedung Rektorat',
    code: 'REKTORAT',
    area: 'Gedung Bangkit Telkom University',
    latitude: -6.975420,
    longitude: 107.630680,
    entranceLatitude: -6.975580,
    entranceLongitude: 107.630510,
  );

  static const Building cacukBuilding = Building(
    id: 'cacuk',
    name: 'Gedung Cacuk Sudarijanto',
    code: 'CACUK',
    area: 'Fakultas Rekayasa Industri (FRI)',
    latitude: -6.974350,
    longitude: 107.631950,
    entranceLatitude: -6.974490,
    entranceLongitude: 107.631760,
  );

  static const Building fksBuilding = Building(
    id: 'fks',
    name: 'Gedung Kawung (FKS)',
    code: 'FKS',
    area: 'Fakultas Komunikasi dan Ilmu Sosial',
    latitude: -6.972520,
    longitude: 107.633450,
    entranceLatitude: -6.972440,
    entranceLongitude: 107.633260,
  );

  static const Building damarBuilding = Building(
    id: 'damar',
    name: 'Gedung Damar',
    code: 'DAMAR',
    area: 'Open Library & Ruang Kuliah Umum',
    latitude: -6.974950,
    longitude: 107.630120,
    entranceLatitude: -6.975090,
    entranceLongitude: 107.630020,
  );

  static const Building btpBuilding = Building(
    id: 'btp',
    name: 'Bandung Techno Park',
    code: 'BTP',
    area: 'Kawasan Riset & Inovasi BTP',
    latitude: -6.970320,
    longitude: 107.631150,
    entranceLatitude: -6.970410,
    entranceLongitude: 107.630920,
  );

  static const Building tuchBuilding = Building(
    id: 'tuch',
    name: 'Gedung TUCH',
    code: 'TUCH',
    area: 'Telkom University Convention Hall',
    latitude: -6.970820,
    longitude: 107.631520,
    entranceLatitude: -6.970950,
    entranceLongitude: 107.631390,
  );

  static const Building msuBuilding = Building(
    id: 'msu',
    name: 'Masjid Syamsul Ulum',
    code: 'MSU',
    area: 'Masjid Kampus & Student Center',
    latitude: -6.976050,
    longitude: 107.632420,
    entranceLatitude: -6.976140,
    entranceLongitude: 107.632230,
  );

  static const List<Building> _buildings = [
    tultBuilding,
    gkuBuilding,
    fitBuilding,
    febBuilding,
    rektoratBuilding,
    cacukBuilding,
    fksBuilding,
    damarBuilding,
    btpBuilding,
    tuchBuilding,
    msuBuilding,
  ];

  static List<Building> getAllBuildings() => List.unmodifiable(_buildings);

  static List<Building> searchBuildings(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return getAllBuildings();
    }

    final exactOrPrefix = <Building>[];
    final substringMatch = <Building>[];

    for (final building in _buildings) {
      final codeLower = building.code.toLowerCase();
      final nameLower = building.name.toLowerCase();
      final areaLower = building.area.toLowerCase();

      if (codeLower == normalized ||
          codeLower.startsWith(normalized) ||
          nameLower.startsWith(normalized)) {
        exactOrPrefix.add(building);
      } else if (nameLower.contains(normalized) ||
          codeLower.contains(normalized) ||
          areaLower.contains(normalized)) {
        substringMatch.add(building);
      }
    }

    return List.unmodifiable([...exactOrPrefix, ...substringMatch]);
  }

  static Building? findById(String id) {
    final normalized = id.trim().toLowerCase();
    if (normalized.isEmpty) return null;
    for (final building in _buildings) {
      if (building.id.toLowerCase() == normalized) {
        return building;
      }
    }
    return null;
  }
}

