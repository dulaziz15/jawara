import 'package:flutter/material.dart';
import 'catergory_models.dart';

class DashboardPendudukModel {
  final List<Map<String, dynamic>> keluargaList;
  final List<Map<String, dynamic>> wargaList;

  DashboardPendudukModel({required this.keluargaList, required this.wargaList});

  /// Total keluarga
  int get totalKeluarga => keluargaList.length;

  /// Total penduduk
  int get totalPenduduk => wargaList.length;

  /// Data kategori: Jenis Kelamin
  List<CategoryData> get genderData {
    Map<String, int> counts = {};
    for (var w in wargaList) {
      final jenis = w['jenisKelamin'] ?? 'Unknown';
      counts[jenis] = (counts[jenis] ?? 0) + 1;
    }
    return counts.entries
        .map(
          (e) => CategoryData(
            category: e.key,
            percentage: (e.value / totalPenduduk) * 100,
            color: e.key.toLowerCase().contains('laki')
                ? Colors.blue
                : Colors.red,
          ),
        )
        .toList();
  }

  /// Data kategori: Status Domisili
  List<CategoryData> get statusDomisiliData {
    Map<String, int> counts = {};
    for (var k in keluargaList) {
      final status = k['statusDomisiliKeluarga'] ?? 'Unknown';
      counts[status] = (counts[status] ?? 0) + 1;
    }
    return counts.entries
        .map(
          (e) => CategoryData(
            category: e.key,
            percentage: (e.value / totalKeluarga) * 100,
            color: e.key.toLowerCase().contains('aktif')
                ? Colors.teal
                : Colors.white,
          ),
        )
        .toList();
  }

  /// Data kategori: Agama
  List<CategoryData> get agamaData {
    Map<String, int> counts = {};
    for (var w in wargaList) {
      final agama = w['agama'] ?? 'Unknown';
      counts[agama] = (counts[agama] ?? 0) + 1;
    }
    return counts.entries.map((e) {
      final key = e.key.toLowerCase();

      Color color;
      if (key == 'nonaktif') {
        color = Colors.red; // Nonaktif
      } else if (key == 'aktif') {
        color = Colors.teal; // Aktif
      } else {
        color = Colors.grey; // Unknown / lainnya
      }

      return CategoryData(
        category: e.key,
        percentage: (e.value / totalKeluarga) * 100,
        color: color,
      );
    }).toList();
  }

  /// Data kategori: Pekerjaan
  List<CategoryData> get pekerjaanData {
    Map<String, int> counts = {};
    for (var w in wargaList) {
      final pekerjaan = w['pekerjaan'] ?? 'Unknown';
      counts[pekerjaan] = (counts[pekerjaan] ?? 0) + 1;
    }
    return counts.entries
        .map(
          (e) => CategoryData(
            category: e.key,
            percentage: (e.value / totalPenduduk) * 100,
            color: Colors.primaries[e.key.hashCode % Colors.primaries.length],
          ),
        )
        .toList();
  }

  /// Data kategori: Peran dalam keluarga
  List<CategoryData> get peranKeluargaData {
    Map<String, int> counts = {};
    for (var w in wargaList) {
      final peran = w['peranKeluarga'] ?? 'Unknown';
      counts[peran] = (counts[peran] ?? 0) + 1;
    }
    return counts.entries
        .map(
          (e) => CategoryData(
            category: e.key,
            percentage: (e.value / totalPenduduk) * 100,
            color: Colors.primaries[e.key.hashCode % Colors.primaries.length],
          ),
        )
        .toList();
  }

  /// Data kategori: Pendidikan
  List<CategoryData> get pendidikanData {
    Map<String, int> counts = {};
    for (var w in wargaList) {
      final pendidikan = w['pendidikan'] ?? 'Unknown';
      counts[pendidikan] = (counts[pendidikan] ?? 0) + 1;
    }
    return counts.entries
        .map(
          (e) => CategoryData(
            category: e.key,
            percentage: (e.value / totalPenduduk) * 100,
            color: Colors.primaries[e.key.hashCode % Colors.primaries.length],
          ),
        )
        .toList();
  }
}
