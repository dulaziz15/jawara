import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/core/models/broadcast_models.dart';
import 'package:jawara/core/repositories/broadcast_repository.dart'; // Pastikan import repo

@RoutePage()
class BroadcastDetailPage extends StatefulWidget {
  final String broadcastId;

  const BroadcastDetailPage({
    super.key,
    @PathParam('id') required this.broadcastId,
  });

  @override
  State<BroadcastDetailPage> createState() => _BroadcastDetailPageState();
}

class _BroadcastDetailPageState extends State<BroadcastDetailPage> {
  final BroadcastRepository _repository = BroadcastRepository();
  late Future<BroadcastModels?> _broadcastFuture;

  @override
  void initState() {
    super.initState();
    _broadcastFuture = _repository.getBroadcastByDocId(widget.broadcastId);
  }

  String _getBulan(int bulan) {
    const namaBulan = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli',
      'Agustus', 'September', 'Oktober', 'November', 'Desember',
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
          Text(value, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black87)),
        ],
      ),
    );
  }

  // Widget Attachment (Updated untuk Handle Gambar URL)
  Widget _buildAttachmentRow(String label, String urlOrFilename, IconData icon, bool isImage) {
    bool hasAttachment = urlOrFilename.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
          const SizedBox(height: 6),
          if (!hasAttachment)
            const Text(
              "Tidak ada lampiran",
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey),
            )
          else if (isImage && urlOrFilename.startsWith('http'))
            // Jika Gambar dan URL valid, tampilkan preview
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                urlOrFilename,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Text('Gagal memuat gambar', style: TextStyle(color: Colors.red)),
              ),
            )
          else
            // Jika dokumen atau bukan URL (masih string dummy), tampilkan nama file + icon
            Row(
              children: [
                Icon(icon, color: const Color(0xFF6C63FF), size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    urlOrFilename, // Ini bisa nama file atau URL
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
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
        title: const Text('Detail Broadcast', style: TextStyle(color: Colors.black87)),
      ),
      body: FutureBuilder<BroadcastModels?>(
        future: _broadcastFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Data tidak ditemukan"));
          }

          final broadcast = snapshot.data!;
          final String tanggalFormatted =
              '${broadcast.tanggalPublikasi.day} ${_getBulan(broadcast.tanggalPublikasi.month)} ${broadcast.tanggalPublikasi.year}';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow("Judul Broadcast:", broadcast.judulBroadcast),
                        _buildDetailRow("Isi Pesan:", broadcast.isiPesan),
                        _buildDetailRow("Kategori:", broadcast.kategoriBroadcast),
                        _buildDetailRow("Tanggal Publikasi:", tanggalFormatted),
                        _buildDetailRow("Dibuat oleh:", broadcast.dibuatOlehId),
                        const Divider(height: 24),
                        
                        // Menangani Gambar
                        _buildAttachmentRow(
                          "Lampiran Gambar:", 
                          broadcast.lampiranGambar, 
                          Icons.image_outlined,
                          true // isImage = true
                        ),
                        
                        // Menangani Dokumen (PDF dll)
                        _buildAttachmentRow(
                          "Lampiran Dokumen:", 
                          broadcast.lampiranDokumen, 
                          Icons.description_outlined,
                          false // isImage = false
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