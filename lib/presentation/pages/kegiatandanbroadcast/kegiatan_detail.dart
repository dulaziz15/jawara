import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
// Impor model dan data dummy Anda
import 'package:jawara/core/models/kegiatan_models.dart';

@RoutePage()
class KegiatanDetailPage extends StatelessWidget {
  final String kegiatanId;

  const KegiatanDetailPage({
    super.key,
    @PathParam('id') required this.kegiatanId,
  });

  // Helper untuk format bulan
  String _getBulan(int bulan) {
    const namaBulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return namaBulan[bulan - 1];
  }

  // Helper widget untuk menampilkan baris detail
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ambil data kegiatan berdasarkan ID
    final kegiatan = dummyKegiatan.firstWhere(
      (item) => item.docId == kegiatanId,
    );

    // Format tanggal
    final String tanggalFormatted =
        '${kegiatan.tanggalPelaksanaan.day} '
        '${_getBulan(kegiatan.tanggalPelaksanaan.month)} '
        '${kegiatan.tanggalPelaksanaan.year}';

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.router.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        // ### PERUBAHAN: Tambahkan Column untuk menampung tombol dan Card ###
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ### Card Detail Kegiatan ###
            Card(
              color: Colors.white,
              elevation: 2,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow("Nama Kegiatan:", kegiatan.namaKegiatan),
                    _buildDetailRow("Kategori:", kegiatan.kategoriKegiatan),
                    _buildDetailRow("Deskripsi:", kegiatan.deskripsi),
                    _buildDetailRow("Tanggal:", tanggalFormatted),
                    _buildDetailRow("Lokasi:", kegiatan.lokasi),
                    _buildDetailRow(
                      "Penanggung Jawab:",
                      kegiatan.penanggungJawabId.toString(),
                    ),
                    _buildDetailRow("Dibuat oleh:", kegiatan.dibuatOlehId.toString()),
                    _buildDetailRow(
                      "Dokumentasi:",
                      (kegiatan.dokumentasi.isEmpty)
                          ? "Dokumentasi belum diupload"
                          : kegiatan
                                .dokumentasi, // Menampilkan nama file dokumentasi
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
