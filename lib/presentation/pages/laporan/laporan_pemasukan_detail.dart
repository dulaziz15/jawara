import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/core/models/pemasukan_model.dart';
// Pastikan import repository sesuai path Anda
import 'package:jawara/core/repositories/pemasukan_repository.dart';
import 'package:jawara/core/repositories/pengguna_repository.dart';
import 'package:jawara/core/utils/formatter_util.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class LaporanPemasukanDetailPage extends StatefulWidget {
  final String laporanPemasukanId;

  const LaporanPemasukanDetailPage({
    super.key,
    @PathParam('id') required this.laporanPemasukanId,
  });

  @override
  State<LaporanPemasukanDetailPage> createState() =>
      _LaporanPemasukanDetailPageState();
}

class _LaporanPemasukanDetailPageState
    extends State<LaporanPemasukanDetailPage> {
  // 1. Panggil Repository
  final PemasukanRepository _repository = PemasukanRepository();
  late Future<PemasukanModel?> _detailFuture;

  @override
  void initState() {
    super.initState();
    // 2. Fetch data saat halaman dibuka
    _detailFuture = _repository.getPemasukanByDocId(widget.laporanPemasukanId);
  }

  // Helper format bulan (TETAP SAMA)
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

  // Helper widget detail row (TETAP SAMA)
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

  // Helper widget attachment row (TETAP SAMA)
  Widget _buildAttachmentRow(String label, String filename) {
    IconData icon = Icons.description_outlined;
    if (filename.isNotEmpty) {
      if (filename.toLowerCase().endsWith('.jpg') ||
          filename.toLowerCase().endsWith('.png') ||
          filename.toLowerCase().endsWith('.jpeg')) {
        icon = Icons.image_outlined;
      }
    }

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
          filename.isEmpty
              ? const Text(
                  "Tidak ada bukti",
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                )
              : Builder(builder: (context) {
                  if (filename.startsWith('http') && (filename.toLowerCase().endsWith('.jpg') || filename.toLowerCase().endsWith('.png') || filename.toLowerCase().endsWith('.jpeg'))) {
                    return ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(filename, height: 220, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Text('Gagal memuat gambar', style: TextStyle(color: Colors.red))));
                  }

                  if (filename.startsWith('gs://') || filename.startsWith('/')) {
                    return FutureBuilder<String?>(
                      future: _resolveStorageUrl(filename),
                      builder: (context, snap) {
                        if (snap.connectionState == ConnectionState.waiting) return const SizedBox(height: 40, child: Center(child: CircularProgressIndicator()));
                        final url = snap.data;
                        if (url == null || url.isEmpty) return const Text('Lampiran tidak tersedia');
                        if (url.toLowerCase().endsWith('.jpg') || url.toLowerCase().endsWith('.png') || url.toLowerCase().endsWith('.jpeg')) {
                          return ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(url, height: 220, width: double.infinity, fit: BoxFit.cover));
                        }
                        return InkWell(onTap: () => _openFile(url), child: Row(children: [Icon(icon, color: const Color(0xFF6C63FF), size: 20), const SizedBox(width: 8), Expanded(child: Text(url, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87), overflow: TextOverflow.ellipsis,)),]));
                      },
                    );
                  }

                  if (filename.startsWith('http')) {
                    return InkWell(onTap: () => _openFile(filename), child: Row(children: [Icon(icon, color: const Color(0xFF6C63FF), size: 20), const SizedBox(width: 8), Expanded(child: Text(filename, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87), overflow: TextOverflow.ellipsis,)),]));
                  }

                  return Row(children: [Icon(icon, color: const Color(0xFF6C63FF), size: 20), const SizedBox(width: 8), Expanded(child: Text(filename, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),)),]);
                }),
        ],
      ),
    );
  }

  Future<void> _openFile(String url) async {
    if (url.isEmpty) return;
    try {
      final uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) throw 'Could not launch';
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal membuka file: $e')));
    }
  }

  Future<String?> _resolveStorageUrl(String refOrUrl) async {
    try {
      final FirebaseStorage fs = FirebaseStorage.instance;
      if (refOrUrl.startsWith('http')) return refOrUrl;
      if (refOrUrl.startsWith('gs://')) {
        final ref = fs.refFromURL(refOrUrl);
        return await ref.getDownloadURL();
      }
      final ref = fs.ref().child(refOrUrl.replaceFirst(RegExp(r'^/'), ''));
      return await ref.getDownloadURL();
    } catch (e) {
      return null;
    }
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
      ),
      // 3. Gunakan FutureBuilder
      body: FutureBuilder<PemasukanModel?>(
        future: _detailFuture,
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
            return const Center(child: Text("Data pemasukan tidak ditemukan"));
          }

          // D. Data Ditemukan (UI ASLI ANDA)
          final pemasukan = snapshot.data!;

          // Format tanggal pemasukan
          final String tanggalPemasukanFormatted =
              '${pemasukan.tanggalPemasukan.day} '
              '${_getBulan(pemasukan.tanggalPemasukan.month)} '
              '${pemasukan.tanggalPemasukan.year}';

          // Format tanggal terverifikasi
          final String tanggalTerverifikasiFormatted =
              '${pemasukan.tanggalTerverifikasi.day} '
              '${_getBulan(pemasukan.tanggalTerverifikasi.month)} '
              '${pemasukan.tanggalTerverifikasi.year}';

          // Format jumlah pemasukan
          final String jumlahFormatted = FormatterUtil.formatCurrency(
            pemasukan.jumlahPemasukan,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card Detail Laporan Pemasukan
                Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(
                          "Nama Pemasukan:",
                          pemasukan.namaPemasukan,
                        ),
                        _buildDetailRow(
                          "Kategori Pemasukan:",
                          pemasukan.kategoriPemasukan,
                        ),
                        _buildDetailRow(
                          "Jumlah Pemasukan:",
                          'Rp $jumlahFormatted',
                        ),
                        _buildDetailRow(
                          "Tanggal Pemasukan:",
                          tanggalPemasukanFormatted,
                        ),
                        // Tampilkan nama verifikator yang sudah di-resolve di repository
                        () {
                          String verifikatorLabel =
                              pemasukan.verifikatorNama ?? '';
                          return _buildDetailRow(
                            "Verifikator:",
                            verifikatorLabel,
                          );
                        }(),
                        _buildDetailRow(
                          "Tanggal Terverifikasi:",
                          tanggalTerverifikasiFormatted,
                        ),
                        const Divider(height: 24),
                        _buildAttachmentRow("Bukti:", pemasukan.buktiPemasukan),
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
