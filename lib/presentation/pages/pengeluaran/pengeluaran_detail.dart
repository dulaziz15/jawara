import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/core/models/pengeluaran_model.dart';
import 'package:jawara/core/repositories/pengeluaran_repository.dart'; // Pastikan import ini ada
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
  // 1. Panggil Repository
  final PengeluaranRepository _repository = PengeluaranRepository();
  late Future<PengeluaranModel?> _detailFuture;

  @override
  void initState() {
    super.initState();
    // 2. Inisialisasi pengambilan data saat halaman dibuka
    _detailFuture = _repository.getPengeluaranByDocId(widget.pengeluaranId);
  }

  // Helper format bulan (TETAP SAMA)
  String _getBulan(int bulan) {
    const namaBulan = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli',
      'Agustus', 'September', 'Oktober', 'November', 'Desember',
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
                      color: Colors.grey),
                )
              : Row(
                  children: [
                    Icon(icon, color: const Color(0xFF6C63FF), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        filename,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
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
      ),
      // 3. Gunakan FutureBuilder untuk menunggu data dari Firebase
      body: FutureBuilder<PengeluaranModel?>(
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

          // C. Data Kosong / Tidak Ditemukan
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Data pengeluaran tidak ditemukan"));
          }

          // D. Data Ditemukan (UI ASLI ANDA)
          final pengeluaran = snapshot.data!;

          // Logic formatting (TETAP SAMA)
          final String tanggalPengeluaranFormatted =
              '${pengeluaran.tanggalPengeluaran.day} '
              '${_getBulan(pengeluaran.tanggalPengeluaran.month)} '
              '${pengeluaran.tanggalPengeluaran.year}';

          final String tanggalTerverifikasiFormatted =
              '${pengeluaran.tanggalTerverifikasi.day} '
              '${_getBulan(pengeluaran.tanggalTerverifikasi.month)} '
              '${pengeluaran.tanggalTerverifikasi.year}';

          final String jumlahFormatted =
              FormatterUtil.formatCurrency(pengeluaran.jumlahPengeluaran);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card Detail Pengeluaran
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
                            "Nama Pengeluaran:", pengeluaran.namaPengeluaran),
                        _buildDetailRow("Kategori Pengeluaran:",
                            pengeluaran.kategoriPengeluaran),
                        _buildDetailRow(
                            "Jumlah Pengeluaran:", 'Rp $jumlahFormatted'),
                        _buildDetailRow("Tanggal Pengeluaran:",
                            tanggalPengeluaranFormatted),
                        _buildDetailRow(
                            "Verifikator:", pengeluaran.verifikatorId.toString()),
                        _buildDetailRow("Tanggal Terverifikasi:",
                            tanggalTerverifikasiFormatted),
                        const Divider(height: 24),
                        _buildAttachmentRow(
                            "Bukti:", pengeluaran.buktiPengeluaran),
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