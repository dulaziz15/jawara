import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jawara/core/models/kegiatan_models.dart';

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

  // ==================== FUTURE ====================
  Future<KegiatanModel> _getDetailKegiatan() async {
    final doc = await FirebaseFirestore.instance
        .collection('kegiatan')
        .doc(widget.kegiatanId)
        .get();

    if (!doc.exists) throw Exception("Data tidak ditemukan");

    final data = doc.data() as Map<String, dynamic>;
    return KegiatanModel.fromMap({...data, 'docId': doc.id});
  }

  // ==================== UTILITY ====================
  String _getBulan(int bulan) {
    const namaBulan = [
      'Januari','Februari','Maret','April','Mei','Juni',
      'Juli','Agustus','September','Oktober','November','Desember'
    ];
    return namaBulan[bulan - 1];
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
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

  // ==================== BUILD ====================
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
      ),
      body: FutureBuilder<KegiatanModel>(
        future: _getDetailKegiatan(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
              child: Text("Data tidak ditemukan", style: TextStyle(color: Colors.grey)),
            );
          }

          final kegiatan = snapshot.data!;
          final String tanggalFormatted =
              '${kegiatan.tanggalPelaksanaan.day} '
              '${_getBulan(kegiatan.tanggalPelaksanaan.month)} '
              '${kegiatan.tanggalPelaksanaan.year}';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        _buildDetailRow("Penanggung Jawab:", kegiatan.penanggungJawabId),
                        _buildDetailRow("Dibuat oleh:", kegiatan.dibuatOlehId),
                        _buildDetailRow(
                          "Dokumentasi:",
                          kegiatan.dokumentasi.isEmpty
                              ? "Dokumentasi belum diupload"
                              : kegiatan.dokumentasi,
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
