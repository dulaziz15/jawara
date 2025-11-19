import 'package:flutter/material.dart';
import 'package:jawara/core/models/catergory_data.dart';
// Asumsikan file 'catergory_data.dart' sudah ada di project Anda
// import 'package:jawara/core/models/catergory_data.dart';

class PopulationData {
  final int totalFamilies;
  final int totalPeople;
  final List<CategoryData> statusData;
  final List<CategoryData> genderData;
  final List<CategoryData> jobData;
  final List<CategoryData> familyRoleData;
  final List<CategoryData> religionData;
  final List<CategoryData> educationData;

  PopulationData({
    required this.totalFamilies,
    required this.totalPeople,
    required this.statusData,
    required this.genderData,
    required this.jobData,
    required this.familyRoleData,
    required this.religionData,
    required this.educationData,
  });

  factory PopulationData.dummy() {
    return PopulationData(
      totalFamilies: 7,
      totalPeople: 9,
      statusData: [
        CategoryData(category: 'Aktif', percentage: 78, color: Colors.teal),
        CategoryData(category: 'Nonaktif', percentage: 22, color: Colors.brown),
      ],
      genderData: [
        CategoryData(category: 'Laki-laki', percentage: 89, color: Colors.blue),
        CategoryData(category: 'Perempuan', percentage: 11, color: Colors.red),
      ],
      jobData: [
        CategoryData(category: 'Lainnya', percentage: 100, color: Colors.purple),
      ],
      familyRoleData: [
        CategoryData(category: 'Kepala Keluarga', percentage: 78, color: Colors.blue),
        CategoryData(category: 'Anak', percentage: 11, color: Colors.pink),
        CategoryData(category: 'Anggota Lain', percentage: 11, color: Colors.green),
      ],
      religionData: [
        CategoryData(category: 'Islam', percentage: 50, color: Colors.blue),
        CategoryData(category: 'Katolik', percentage: 50, color: Colors.red),
      ],
      educationData: [
        CategoryData(category: 'Sarjana/Diploma', percentage: 100, color: Colors.grey),
      ],
    );
  }
}