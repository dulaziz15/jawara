import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara/core/models/kategori_iuran_models.dart';

class IuranRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ========================================================================
  // PERBAIKAN DI SINI: SESUAIKAN DENGAN NAMA DI FIREBASE ANDA
  // ========================================================================
  final String _collection = 'iuran'; // Collection Data Utama
  // ========================================================================
  // CREATE: MEMBUAT TAGIHAN BARU
  // ========================================================================
  // Method ini dipanggil oleh _tagihIuran() di UI
  Future<void> addTagihanIuran(KategoriIuranModel masterData) async {
    await _firestore.collection(_collection).add({
      // 1. Ambil data dari Master (yang dipilih di dropdown)
      'nama_iuran': masterData.namaIuran,
      'kategori_iuran': masterData.kategoriIuran,
      'jumlah': masterData.jumlah,
      'sumber_master_id': masterData.docId, // (Opsional) Menyimpan ID masternya
      // 2. Tambahkan Data Tambahan untuk Tagihan
      'status': 'Belum Lunas', // Default status tagihan
      'created_at': FieldValue.serverTimestamp(), // Tanggal tagihan dibuat
    });
  }

  // ========================================================================
  // READ: MELIHAT DAFTAR TAGIHAN (Opsional/Untuk halaman List Tagihan nanti)
  // ========================================================================
  Stream<QuerySnapshot> getDaftarTagihan() {
    return _firestore
        .collection(_collection)
        .orderBy('created_at', descending: true)
        .snapshots();
  }

}
