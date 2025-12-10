import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jawara/core/models/catergory_models.dart';
import '../models/population_model.dart';
import 'package:async/async.dart';

class DashboardKependudukanRepository {
  final _keluargaCollection = FirebaseFirestore.instance.collection('families');
  final _wargaCollection = FirebaseFirestore.instance.collection('warga');

  Stream<PopulationData> fetchDashboardData() {
    // Stream gabungan keluarga & warga
    return StreamZip([
      _keluargaCollection.snapshots(),
      _wargaCollection.snapshots(),
    ]).map((snapshots) {
      final keluargaSnap = snapshots[0] as QuerySnapshot;
      final wargaSnap = snapshots[1] as QuerySnapshot;

      final keluargaList = keluargaSnap.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      final wargaList = wargaSnap.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // Hitung total
      final totalFamilies = keluargaList.length;
      final totalPeople = wargaList.length;

      // Hitung kategori Status Domisili
      Map<String, int> statusCount = {};
      for (var k in keluargaList) {
        final status = k['statusDomisiliKeluarga'] ?? 'Unknown';
        statusCount[status] = (statusCount[status] ?? 0) + 1;
      }
      
      final statusData = statusCount.entries.map((e) {
        final key = e.key.toLowerCase();

        Color color;
        if (key == 'nonaktif') {
          color = Colors.red; // warna Nonaktif
        } else if (key == 'aktif') {
          color = Colors.teal; // warna Aktif
        } else {
          color = Colors.grey; // selain itu
        }

        return CategoryData(
          category: e.key,
          percentage: (e.value / totalFamilies) * 100,
          color: color,
        );
      }).toList();

      // Hitung kategori Jenis Kelamin
      Map<String, int> genderCount = {};
      for (var w in wargaList) {
        final gender = w['jenisKelamin'] ?? 'Unknown';
        genderCount[gender] = (genderCount[gender] ?? 0) + 1;
      }
      final genderData = genderCount.entries
          .map(
            (e) => CategoryData(
              category: e.key,
              percentage: (e.value / totalPeople) * 100,
              color: e.key.toLowerCase().contains('laki')
                  ? Colors.blue
                  : Colors.red,
            ),
          )
          .toList();

      // Hitung kategori Pekerjaan
      Map<String, int> jobCount = {};
      for (var w in wargaList) {
        final job = w['pekerjaan'] ?? 'Tidak Bekerja';
        jobCount[job] = (jobCount[job] ?? 0) + 1;
      }
      final jobData = jobCount.entries
          .map(
            (e) => CategoryData(
              category: e.key,
              percentage: (e.value / totalPeople) * 100,
              color: Colors.primaries[e.key.hashCode % Colors.primaries.length],
            ),
          )
          .toList();

      // Hitung kategori Peran dalam Keluarga
      Map<String, int> familyRoleCount = {};
      for (var w in wargaList) {
        final role = w['peranKeluarga'] ?? 'Anggota';
        familyRoleCount[role] = (familyRoleCount[role] ?? 0) + 1;
      }
      final familyRoleData = familyRoleCount.entries
          .map(
            (e) => CategoryData(
              category: e.key,
              percentage: (e.value / totalPeople) * 100,
              color: Colors.primaries[e.key.hashCode % Colors.primaries.length],
            ),
          )
          .toList();

      // Hitung kategori Agama
      Map<String, int> religionCount = {};
      for (var w in wargaList) {
        final religion = w['agama'] ?? 'Tidak Ada';
        religionCount[religion] = (religionCount[religion] ?? 0) + 1;
      }
      final religionData = religionCount.entries
          .map(
            (e) => CategoryData(
              category: e.key,
              percentage: (e.value / totalPeople) * 100,
              color: Colors.primaries[e.key.hashCode % Colors.primaries.length],
            ),
          )
          .toList();

      // Hitung kategori Pendidikan
      Map<String, int> educationCount = {};
      for (var w in wargaList) {
        final education = w['pendidikan'] ?? 'Tidak Sekolah';
        educationCount[education] = (educationCount[education] ?? 0) + 1;
      }
      final educationData = educationCount.entries
          .map(
            (e) => CategoryData(
              category: e.key,
              percentage: (e.value / totalPeople) * 100,
              color: Colors.primaries[e.key.hashCode % Colors.primaries.length],
            ),
          )
          .toList();

      return PopulationData(
        totalFamilies: totalFamilies,
        totalPeople: totalPeople,
        statusData: statusData,
        genderData: genderData,
        jobData: jobData,
        familyRoleData: familyRoleData,
        religionData: religionData,
        educationData: educationData,
      );
    });
  }
}
