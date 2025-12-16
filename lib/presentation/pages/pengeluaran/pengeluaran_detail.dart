import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/core/models/pengeluaran_model.dart';
import 'package:jawara/core/repositories/pengeluaran_repository.dart';
import 'package:jawara/core/repositories/pengguna_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jawara/core/utils/formatter_util.dart';

@RoutePage()
class PengeluaranDetailPage extends StatefulWidget {
  final String pengeluaranId;

  const PengeluaranDetailPage({
    super.key,
    @PathParam('id') required this.pengeluaranId,
  });

  @override
  State<PengeluaranDetailPage> createState() => _PengeluaranDetailPageState();
}

class _PengeluaranDetailPageState extends State<PengeluaranDetailPage> {
  final PengeluaranRepository _repository = PengeluaranRepository();
  late Future<PengeluaranModel?> _detailFuture;

  @override
  void initState() {
    super.initState();
    _detailFuture = _repository.getPengeluaranByDocId(widget.pengeluaranId);
  }

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
  // Detail Row
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
          Text(value,
              style: const TextStyle(
                  fontSize: 17, fontWeight: FontWeight.w500)),
        ],
      ),
    );
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
  // Open File (PDF / DOC)
  // ===============================
  Future<void> _openFile(BuildContext context, String url) async {
    try {
      final uri = Uri.parse(url);
      final success =
          await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!success) throw 'Tidak bisa membuka file';
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuka file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ===============================
  // ATTACHMENT (IMAGE / PDF)
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
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (!snap.hasData || snap.data == null) {
                return const Text("Bukti tidak tersedia");
              }

              final url = snap.data!;
              final lower = url.toLowerCase();

              final isImage = lower.endsWith('.jpg') ||
                  lower.endsWith('.jpeg') ||
                  lower.endsWith('.png');

              final isPdf = lower.endsWith('.pdf');

              // ================= FOTO =================
              if (isImage) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        url,
                        height: 240,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Text(
                          "Gagal memuat gambar",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Bukti (Foto)",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                );
              }

              // ================= PDF =================
              if (isPdf) {
                return ListTile(
                  onTap: () => _openFile(context, url),
                  leading: const Icon(
                    Icons.picture_as_pdf,
                    color: Colors.redAccent,
                  ),
                  title: const Text(
                    "Bukti (PDF)",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  contentPadding: EdgeInsets.zero,
                );
              }

              // ================= FILE LAIN =================
              return ListTile(
                onTap: () => _openFile(context, url),
                leading: const Icon(
                  Icons.file_open,
                  color: Color(0xFF6C63FF),
                ),
                title: const Text(
                  "Bukti",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: const Icon(Icons.chevron_right),
                contentPadding: EdgeInsets.zero,
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
      body: FutureBuilder<PengeluaranModel?>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Data pengeluaran tidak ditemukan"));
          }

          final pengeluaran = snapshot.data!;

          final tanggalPengeluaran =
              '${pengeluaran.tanggalPengeluaran.day} '
              '${_getBulan(pengeluaran.tanggalPengeluaran.month)} '
              '${pengeluaran.tanggalPengeluaran.year}';

          final tanggalVerifikasi =
              '${pengeluaran.tanggalTerverifikasi.day} '
              '${_getBulan(pengeluaran.tanggalTerverifikasi.month)} '
              '${pengeluaran.tanggalTerverifikasi.year}';

          final jumlah =
              FormatterUtil.formatCurrency(pengeluaran.jumlahPengeluaran);

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
                    _buildDetailRow(
                        "Nama Pengeluaran", pengeluaran.namaPengeluaran),
                    _buildDetailRow(
                        "Kategori", pengeluaran.kategoriPengeluaran),
                    _buildDetailRow("Jumlah", "Rp $jumlah"),
                    _buildDetailRow("Tanggal", tanggalPengeluaran),

                    FutureBuilder(
                      future: PenggunaRepository()
                          .getUserByDocId(pengeluaran.verifikatorId),
                      builder: (context, snap) {
                        String nama = 'Belum diverifikasi';
                        if (snap.hasData && snap.data != null) {
                          nama = snap.data!.nama;
                        }
                        return _buildDetailRow("Verifikator", nama);
                      },
                    ),

                    _buildDetailRow("Tanggal Verifikasi", tanggalVerifikasi),
                    const Divider(height: 32),
                    _buildAttachmentRow(
                        context, "Bukti", pengeluaran.buktiPengeluaran),
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
