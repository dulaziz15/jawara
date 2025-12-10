import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardKegiatanModel {
  final String docId;
  final String namaKegiatan;
  final String deskripsi;
  final String kategoriKegiatan;
  final String lokasi;
  final String dokumentasi;
  final String dibuatOlehId;
  final String penanggungJawabId;
  final DateTime tanggalPelaksanaan;

  DashboardKegiatanModel({
    required this.docId,
    required this.namaKegiatan,
    required this.deskripsi,
    required this.kategoriKegiatan,
    required this.lokasi,
    required this.dokumentasi,
    required this.dibuatOlehId,
    required this.penanggungJawabId,
    required this.tanggalPelaksanaan,
  });

  factory DashboardKegiatanModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final timestamp = data['tanggal_pelaksanaan'] as Timestamp;
    return DashboardKegiatanModel(
      docId: doc.id,
      namaKegiatan: data['nama_kegiatan'] ?? '',
      deskripsi: data['deskripsi'] ?? '',
      kategoriKegiatan: data['kategori_kegiatan'] ?? '',
      lokasi: data['lokasi'] ?? '',
      dokumentasi: data['dokumentasi'] ?? '',
      dibuatOlehId: data['dibuat_oleh_id'] ?? '',
      penanggungJawabId: data['penanggung_jawab_id'] ?? '',
      tanggalPelaksanaan: timestamp.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama_kegiatan': namaKegiatan,
      'deskripsi': deskripsi,
      'kategori_kegiatan': kategoriKegiatan,
      'lokasi': lokasi,
      'dokumentasi': dokumentasi,
      'dibuat_oleh_id': dibuatOlehId,
      'penanggung_jawab_id': penanggungJawabId,
      'tanggal_pelaksanaan': Timestamp.fromDate(tanggalPelaksanaan),
    };
  }
}
