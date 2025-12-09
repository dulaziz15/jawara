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
  // ==================== FUTURE (TIDAK DIUBAH) ====================
  Future<KegiatanModel> _getDetailKegiatan() async {
    final doc = await FirebaseFirestore.instance
        .collection('kegiatan')
        .doc(widget.kegiatanId)
        .get();

    if (!doc.exists) throw Exception("Data tidak ditemukan");

    final data = doc.data() as Map<String, dynamic>;
    return KegiatanModel.fromMap({...data, 'docId': doc.id});
  }

  // ==================== UTILITY (TIDAK DIUBAH) ====================
  String _getBulan(int bulan) {
    const namaBulan = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return namaBulan[bulan - 1];
  }

  // ==================== UI WIDGETS HELPER ====================
  
  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    bool isLongText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blue.shade300),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBadge(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Text(
        category.toUpperCase(),
        style: TextStyle(
          color: Colors.blue.shade800,
          fontWeight: FontWeight.bold,
          fontSize: 11,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // ==================== BUILD ====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA), // Background abu-abu muda
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFF5F6FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.black87),
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
            return const Center(child: Text("Data tidak ditemukan"));
          }

          final kegiatan = snapshot.data!;
          final String tanggalFormatted =
              '${kegiatan.tanggalPelaksanaan.day} '
              '${_getBulan(kegiatan.tanggalPelaksanaan.month)} '
              '${kegiatan.tanggalPelaksanaan.year}';

          // --- UI UTAMA ---
          // PERUBAHAN: Menggunakan Align topCenter bukan Center agar di atas
          return Align(
            alignment: Alignment.topCenter, 
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20), // Padding atas disesuaikan
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // === BAGIAN ATAS (HEADER) ===
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildCategoryBadge(kegiatan.kategoriKegiatan),
                                Text(
                                  tanggalFormatted,
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              kegiatan.namaKegiatan,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Optional: Menampilkan ID kecil
                            Text(
                              "Ref ID: ${kegiatan.docId}", 
                              style: TextStyle(fontSize: 10, color: Colors.grey.shade300),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      Divider(height: 1, thickness: 1, color: Colors.grey.shade100),
                      const SizedBox(height: 24),

                      // === BAGIAN TENGAH (ISI DATA) ===
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            _buildDetailItem(
                              icon: Icons.location_on_outlined,
                              label: "Lokasi",
                              value: kegiatan.lokasi,
                            ),
                            _buildDetailItem(
                              icon: Icons.notes_rounded,
                              label: "Deskripsi",
                              value: kegiatan.deskripsi,
                              isLongText: true,
                            ),
                            _buildDetailItem(
                              icon: Icons.person_outline_rounded,
                              label: "Penanggung Jawab",
                              value: kegiatan.penanggungJawabId,
                            ),
                            _buildDetailItem(
                              icon: Icons.admin_panel_settings_outlined,
                              label: "Dibuat Oleh",
                              value: kegiatan.dibuatOlehId,
                            ),
                             _buildDetailItem(
                              icon: Icons.folder_open_outlined,
                              label: "Dokumentasi",
                              value: kegiatan.dokumentasi.isEmpty
                                  ? "-"
                                  : kegiatan.dokumentasi,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}