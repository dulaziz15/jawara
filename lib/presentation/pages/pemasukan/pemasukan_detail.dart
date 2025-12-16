import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/core/models/pemasukan_model.dart';
import 'package:jawara/core/utils/formatter_util.dart';
import 'package:jawara/core/repositories/pemasukan_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class LaporanPemasukanLainDetailPage extends StatelessWidget {
  final String laporanPemasukanId;

  const LaporanPemasukanLainDetailPage({
    super.key,
    @PathParam('id') required this.laporanPemasukanId,
  });

  // ===============================
  // Helper format bulan
  // ===============================
  String _getBulan(int bulan) {
    const namaBulan = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return namaBulan[bulan - 1];
  }

  // ===============================
  // Helper detail row
  // ===============================
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // ===============================
  // Open file (PDF, DOC, dll)
  // ===============================
  Future<void> _openFile(BuildContext context, String url) async {
    try {
      final uri = Uri.parse(url);
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok) throw 'Tidak bisa membuka file';
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membuka file: $e')),
      );
    }
  }

  // ===============================
  // Resolve Firebase Storage URL
  // ===============================
  Future<String?> _resolveStorageUrl(String refOrUrl) async {
    try {
      final fs = FirebaseStorage.instance;

      if (refOrUrl.startsWith('http')) return refOrUrl;
      if (refOrUrl.startsWith('gs://')) {
        return await fs.refFromURL(refOrUrl).getDownloadURL();
      }

      return await fs
          .ref()
          .child(refOrUrl.replaceFirst(RegExp(r'^/'), ''))
          .getDownloadURL();
    } catch (_) {
      return null;
    }
  }

  // ===============================
  // FULLSCREEN IMAGE PREVIEW
  // ===============================
  void _showImagePreview(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black,
      builder: (_) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4,
              child: Center(
                child: Image.network(imageUrl),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===============================
  // Attachment widget (PREVIEW IMAGE)
  // ===============================
  Widget _buildAttachmentRow(
    BuildContext context, String label, String bukti) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 8),

        // JIKA TIDAK ADA BUKTI
        if (bukti.isEmpty)
          const Text(
            "Tidak ada bukti",
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          )
        else
          FutureBuilder<String?>(
            future: _resolveStorageUrl(bukti),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return const Text("Bukti tidak tersedia");
              }

              // 🔥 GAMBAR LANGSUNG TAMPIL
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  snapshot.data!,
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Text(
                    "Gagal memuat gambar",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              );
            },
          ),
      ],
    ),
  );
}


  // ===============================
  // BUILD
  // ===============================
  @override
  Widget build(BuildContext context) {
    final repo = PemasukanRepository();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.pop(),
        ),
      ),
      body: FutureBuilder<PemasukanModel?>(
        future: repo.getPemasukanByDocId(laporanPemasukanId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Data tidak ditemukan'));
          }

          final p = snapshot.data!;
          final tanggal =
              '${p.tanggalPemasukan.day} ${_getBulan(p.tanggalPemasukan.month)} ${p.tanggalPemasukan.year}';
          final jumlah =
              FormatterUtil.formatCurrency(p.jumlahPemasukan);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow("Nama Pemasukan", p.namaPemasukan),
                    _buildDetailRow("Kategori", p.kategoriPemasukan),
                    _buildDetailRow("Jumlah", "Rp $jumlah"),
                    _buildDetailRow("Tanggal", tanggal),
                    const Divider(height: 32),
                    _buildAttachmentRow(context, "Bukti", p.buktiPemasukan),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
