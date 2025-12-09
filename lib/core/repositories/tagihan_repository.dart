import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara/core/models/tagihan_model.dart';

class TagihanRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Pastikan nama collection sesuai
  final String _colIuran = 'tagihan'; // Collection Tagihan
  final String _colWarga = 'users'; // Collection Warga

  // JOIN OPERATION: Get Tagihan + Join ke Warga
  // JOIN OPERATION: Get Tagihan + Join ke Warga (WITH DEBUGGING)
  Stream<List<TagihanModel>> getTagihanWithWargaStream() {
    print("🔌 [STREAM INIT] Menghubungkan ke collection '$_colIuran'...");

    return _firestore
        .collection(_colIuran)
        .orderBy('docId', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          // [DEBUG 1] Cek apakah ada data mentah dari Firestore
          print("\n🔄 [STREAM UPDATE] Ada update baru dari Firestore!");
          print("📂 Collection Source: '$_colIuran'");
          print("📊 Jumlah Dokumen Ditemukan: ${snapshot.docs.length}");

          if (snapshot.docs.isEmpty) {
            print(
              "⚠️ [WARNING] Tidak ada dokumen di collection '$_colIuran'. List akan kosong.",
            );
            return <TagihanModel>[];
          }

          // Kita gunakan Future.wait agar pengambilan data warga berjalan PARALEL
          final List<TagihanModel> listTagihan = await Future.wait(
            snapshot.docs.map((doc) async {
              final data = doc.data();
              final String nik = data['nik'] ?? '';

              // [DEBUG 2] Intip sedikit data per-item (Opsional, matikan jika terlalu spam)
              // print("   👉 Processing Item ID: ${doc.id} | NIK: '$nik'");

              String namaWargaFound = 'Warga Tidak Ditemukan';

              if (nik.isNotEmpty) {
                // JOIN: Cari di collection 'warga' berdasarkan NIK
                final wargaDoc = await _firestore
                    .collection(_colWarga)
                    .doc(nik)
                    .get();

                if (wargaDoc.exists) {
                  namaWargaFound = wargaDoc.data()?['nama'] ?? 'Tanpa Nama';
                  // print("      ✅ JOIN SUKSES: $namaWargaFound");
                } else {
                  print(
                    "      ❌ JOIN GAGAL: Tidak ada data di '$_colWarga' dengan ID '$nik'",
                  );
                }
              } else {
                // print("      ⚠️ NIK Kosong/Null di dokumen ini.");
              }

              // Gabungkan data Tagihan + Nama Warga hasil Join
              return TagihanModel.fromMap(
                data,
                doc.id,
                namaWargaFromJoin: namaWargaFound,
              );
            }),
          );

          print(
            "✅ [STREAM FINISHED] Berhasil memproses ${listTagihan.length} data tagihan + warga.",
          );
          return listTagihan;
        });
  }

  // GET SINGLE DETAIL + JOIN (WITH DEBUGGING)
  Future<TagihanModel?> getTagihanDetail(String docId) async {
    print("\n========================================================");
    print("🔥 [DEBUG] getTagihanDetail DIPANGGIL");
    print("👉 ID Dokumen yang dicari: '$docId'");
    print("👉 Collection Tagihan: '$_colIuran'");
    print("👉 Collection Warga: '$_colWarga'");

    try {
      // 1. Ambil Dokumen Tagihan
      final docRef = _firestore.collection(_colIuran).doc(docId);
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        print("❌ [ERROR] Dokumen TIDAK DITEMUKAN di collection '$_colIuran'!");
        print("   Coba cek apakah ID '$docId' benar-benar ada di Firestore?");
        print("========================================================\n");
        return null;
      }

      print("✅ [SUCCESS] Dokumen Tagihan DITEMUKAN.");
      final data = docSnapshot.data()!;
      print("📄 Data Mentah Tagihan: $data");

      // Cek field nik_warga
      final String nik = data['nik'] ?? '';
      print("🔎 NIK Warga yang akan di-join: '$nik'");

      // 2. Ambil Data Warga (Join)
      String namaWargaFound = 'Tanpa Nama';
      String alamatWargaFound = '-';

      if (nik.isNotEmpty) {
        print("🚀 Memulai Join ke Collection '$_colWarga' dengan ID '$nik'...");

        // Asumsi NIK adalah Document ID di collection warga
        final wargaDoc = await _firestore.collection(_colWarga).doc(nik).get();

        if (wargaDoc.exists) {
          final wargaData = wargaDoc.data();
          print("✅ [SUCCESS] Data Warga DITEMUKAN: $wargaData");

          namaWargaFound = wargaData?['nama'] ?? 'Tanpa Nama';
          alamatWargaFound = wargaData?['alamat'] ?? '-';
        } else {
          print("⚠️ [WARNING] Data Warga TIDAK DITEMUKAN untuk ID '$nik'");
          print(
            "   Pastikan NIK '$nik' ada sebagai Document ID di collection '$_colWarga'",
          );
        }
      } else {
        print("⚠️ [WARNING] Field 'nik_warga' kosong atau null. Skip Join.");
      }

      print("🏁 Selesai. Mengembalikan Object TagihanModel.");
      print("========================================================\n");

      // 3. Gabungkan
      return TagihanModel.fromMap(
        data,
        docSnapshot.id,
        namaWargaFromJoin: namaWargaFound,
        alamatWargaFromJoin: alamatWargaFound,
      );
    } catch (e) {
      print("🔥 [EXCEPTION] Error get detail: $e");
      return null;
    }
  }
}
