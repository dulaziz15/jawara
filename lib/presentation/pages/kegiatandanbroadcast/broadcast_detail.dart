import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/core/models/broadcast_models.dart';
import 'package:jawara/core/repositories/broadcast_repository.dart';
import 'package:url_launcher/url_launcher.dart';

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

  // 👉 fungsi download dokumen
  Future<void> _openFile(String url) async {
    // 1. Validasi URL kosong
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Link file tidak valid/kosong")),
      );
      return;
    }

    try {
      final uri = Uri.parse(url);

      // 2. Langsung coba launch dengan mode ExternalApplication
      // Mode ini akan memaksa membuka browser default atau PDF viewer bawaan HP
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      // 3. Tangkap error jika gagal
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal membuka file: $e")));
      }
    }
  }

  // Lampiran gambar / dokumen
  Widget _buildAttachmentRow(String label, String data, bool isImage) {
    final bool adaLampiran = data.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 6),

          // Jika tidak ada lampiran
          if (!adaLampiran)
            const Text(
              "Tidak ada lampiran",
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),

          // 👇 Kalau IMAGE dan link valid → tampilkan gambar
          if (adaLampiran && isImage && data.startsWith('http'))
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                data,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, _, __) => const Text(
                  "Gagal memuat gambar",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),

          // 👇 Kalau dokumen → tombol download
          if (adaLampiran && !isImage)
            InkWell(
              onTap: () => _openFile(data),
              child: Row(
                children: [
                  const Icon(
                    Icons.download_rounded,
                    color: Color(0xFF6C63FF),
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Klik untuk download file",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF6C63FF),
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
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
          'Detail Broadcast',
          style: TextStyle(color: Colors.black87),
        ),
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
          if (!snapshot.hasData) {
            return const Center(child: Text("Data tidak ditemukan"));
          }

          final broadcast = snapshot.data!;
          final tgl =
              '${broadcast.tanggalPublikasi.day} ${_getBulan(broadcast.tanggalPublikasi.month)} ${broadcast.tanggalPublikasi.year}';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(
                          "Judul Broadcast:",
                          broadcast.judulBroadcast,
                        ),
                        _buildDetailRow("Isi Pesan:", broadcast.isiPesan),
                        _buildDetailRow(
                          "Kategori:",
                          broadcast.kategoriBroadcast,
                        ),
                        _buildDetailRow("Tanggal Publikasi:", tgl),
                        _buildDetailRow("Dibuat oleh:", broadcast.dibuatOlehId),
                        const Divider(height: 30),

                        // 🔥 Gambar
                        _buildAttachmentRow(
                          "Lampiran Gambar:",
                          broadcast.lampiranGambar,
                          true,
                        ),

                        // 🔥 Download dokumen
                        _buildAttachmentRow(
                          "Lampiran Dokumen:",
                          broadcast.lampiranDokumen,
                          false,
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
