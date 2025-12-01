import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/core/models/kegiatan_models.dart';
import 'package:jawara/core/repositories/kegiatan_repository.dart'; // Import Repo

@RoutePage()
class KegiatanDetailPage extends StatefulWidget {
  final String kegiatanId;

  const KegiatanDetailPage({
    super.key,
    @PathParam('id') required this.kegiatanId,
  });

  @override
  State<KegiatanDetailPage> createState() => _KegiatanDetailPageState();
}

class _KegiatanDetailPageState extends State<KegiatanDetailPage> {
  // 1. Panggil Repository
  final KegiatanRepository _repository = KegiatanRepository();
  late Future<KegiatanModel?> _kegiatanFuture;

  @override
  void initState() {
    super.initState();
    // 2. Ambil data saat halaman dimuat
    _kegiatanFuture = _repository.getKegiatanByDocId(widget.kegiatanId);
  }

  // Helper untuk format bulan
  String _getBulan(int bulan) {
    const namaBulan = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli',
      'Agustus', 'September', 'Oktober', 'November', 'Desember',
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
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.router.pop(),
        ),
        title: const Text(
          "Detail Kegiatan",
          style: TextStyle(color: Colors.black87, fontSize: 18),
        ),
      ),
      // 3. Gunakan FutureBuilder untuk menunggu data
      body: FutureBuilder<KegiatanModel?>(
        future: _kegiatanFuture,
        builder: (context, snapshot) {
          // A. Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // B. Error State
          if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          }

          // C. Data Kosong
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Data kegiatan tidak ditemukan"));
          }

          // D. Data Ditemukan
          final kegiatan = snapshot.data!;

          // Format tanggal
          final String tanggalFormatted =
              '${kegiatan.tanggalPelaksanaan.day} '
              '${_getBulan(kegiatan.tanggalPelaksanaan.month)} '
              '${kegiatan.tanggalPelaksanaan.year}';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card Detail Kegiatan
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
                          kegiatan.penanggungJawabId, // Menampilkan ID (ideally fetch nama user juga)
                        ),
                        _buildDetailRow("Dibuat oleh:", kegiatan.dibuatOlehId),
                        
                        // Menampilkan Gambar/Dokumentasi jika ada
                        const SizedBox(height: 8),
                        Text(
                          "Dokumentasi:",
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 8),
                        (kegiatan.dokumentasi.isEmpty)
                            ? const Text(
                                "Tidak ada dokumentasi",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic, color: Colors.grey),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  kegiatan.dokumentasi, // Asumsi URL Image
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 200,
                                      width: double.infinity,
                                      color: Colors.grey.shade200,
                                      child: const Center(
                                          child: Icon(Icons.broken_image,
                                              color: Colors.grey)),
                                    );
                                  },
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}