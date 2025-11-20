import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel {
  final int no;
  final String description;
  final String actor; 
  // 💡 PERUBAHAN: Menggunakan DateTime untuk mempermudah sorting dan filtering
  final DateTime date; 

  const ActivityModel({
    required this.no,
    required this.description,
    required this.actor,
    required this.date,
  });

  // Konversi dari Object ke Map (Untuk Firestore Write/Simpan)
  Map<String, dynamic> toMap() {
    return {
      'no': no,
      'description': description,
      'actor': actor,
      // 🔑 Mengubah DateTime menjadi Timestamp (Tipe data ideal di Firestore)
      'date': Timestamp.fromDate(date), 
    };
  }

  // Konversi dari Map ke Object (Untuk Firestore Read/Ambil)
  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      no: map['no'] as int,
      description: map['description'] as String,
      actor: map['actor'] as String,
      // 🔑 Mengubah Timestamp dari Firestore menjadi DateTime di Dart
      date: (map['date'] as Timestamp).toDate(), 
    );
  }
}
/// === DATA DUMMY (Setelah Konversi ke DateTime) ===
final List<ActivityModel> daftarAktivitas = [
  ActivityModel(
    no: 1,
    description: 'Menambahkan rumah baru dengan alamat: fasda',
    actor: 'Admin Jawara',
    // 10 Oktober 2025
    date: DateTime(2025, 10, 10), 
  ),
  ActivityModel(
    no: 2,
    description: 'Menyetujui pesan warga: tes',
    actor: 'Admin Jawara',
    // 11 Oktober 2025
    date: DateTime(2025, 10, 11), 
  ),
  ActivityModel(
    no: 3,
    description: 'Menghapus event: Lomba 17agustus pada ate 16 Agustus 2025',
    actor: 'Admin Jawara',
    // 14 Oktober 2025
    date: DateTime(2025, 10, 14), 
  ),
  ActivityModel(
    no: 4,
    description: 'Menambahkan pengguna baru: John Doe',
    actor: 'Admin Jawara',
    // 15 Oktober 2025
    date: DateTime(2025, 10, 15), 
  ),
  ActivityModel(
    no: 5,
    description: 'Mengedit data warga: Jane Smith',
    actor: 'Admin Jawara',
    // 16 Oktober 2025
    date: DateTime(2025, 10, 16), 
  ),
  ActivityModel(
    no: 6,
    description: 'Menolak permintaan: Pembangunan jalan',
    actor: 'Admin Jawara',
    // 17 Oktober 2025
    date: DateTime(2025, 10, 17), 
  ),
  ActivityModel(
    no: 7,
    description: 'Menyetujui laporan keuangan bulan Oktober',
    actor: 'Admin Jawara',
    // 18 Oktober 2025
    date: DateTime(2025, 10, 18), 
  ),
  ActivityModel(
    no: 8,
    description: 'Menghapus broadcast: Pengumuman RT',
    actor: 'Admin Jawara',
    // 19 Oktober 2025
    date: DateTime(2025, 10, 19), 
  ),
  ActivityModel(
    no: 9,
    description: 'Menambahkan kegiatan: Gotong Royong',
    actor: 'Admin Jawara',
    // 20 Oktober 2025
    date: DateTime(2025, 10, 20), 
  ),
  ActivityModel(
    no: 10,
    description: 'Mengupdate status pengguna: Aktif',
    actor: 'Admin Jawara',
    // 21 Oktober 2025
    date: DateTime(2025, 10, 21), 
  ),
];