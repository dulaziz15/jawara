import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/core/models/pengeluaran_model.dart';
// Sesuaikan import ini dengan lokasi repository Anda
import 'package:jawara/core/repositories/pengeluaran_repository.dart'; 
import 'package:jawara/core/repositories/pengguna_repository.dart';
import 'package:jawara/core/utils/formatter_util.dart';

@RoutePage()
class LaporanPengeluaranDetailPage extends StatefulWidget {
  final String laporanPengeluaranId;

  const LaporanPengeluaranDetailPage({
    super.key,
    @PathParam('id') required this.laporanPengeluaranId,
  });

  @override
  State<LaporanPengeluaranDetailPage> createState() =>
      _LaporanPengeluaranDetailPageState();
}

class _LaporanPengeluaranDetailPageState
    extends State<LaporanPengeluaranDetailPage> {
  
  // 1. Panggil Repository
  final PengeluaranRepository _repository = PengeluaranRepository();
  late Future<PengeluaranModel?> _detailFuture;

  @override
  void initState() {
    super.initState();
    // 2. Fetch data saat halaman dibuka berdasarkan ID
    _detailFuture =
        _repository.getPengeluaranByDocId(widget.laporanPengeluaranId);
  }

  // Helper untuk format bulan
  String _getBulan(int bulan) {
    const namaBulan = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli',
      'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return namaBulan[bulan - 1];
  }

  // Helper widget untuk menampilkan baris detail teks
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

  // Helper widget untuk menampilkan baris lampiran dengan ikon
  Widget _buildAttachmentRow(String label, String filename) {
    IconData icon = Icons.description_outlined; // Default to document
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
          // Cek apakah ada nama file lampiran
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

          // C. Data Kosong
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Data pengeluaran tidak ditemukan"));
          }

          // D. Data Ditemukan (UI Asli Anda)
          final pengeluaran = snapshot.data!;

          // Format tanggal pengeluaran
          final String tanggalPengeluaranFormatted =
              '${pengeluaran.tanggalPengeluaran.day} '
              '${_getBulan(pengeluaran.tanggalPengeluaran.month)} '
              '${pengeluaran.tanggalPengeluaran.year}';

          // Format tanggal terverifikasi
          final String tanggalTerverifikasiFormatted =
              '${pengeluaran.tanggalTerverifikasi.day} '
              '${_getBulan(pengeluaran.tanggalTerverifikasi.month)} '
              '${pengeluaran.tanggalTerverifikasi.year}';

          // Format jumlah pengeluaran
          final String jumlahFormatted =
              FormatterUtil.formatCurrency(pengeluaran.jumlahPengeluaran);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card Detail Laporan Pengeluaran
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
                        // Tampilkan nama verifikator dengan lookup
                        FutureBuilder(
                          future: PenggunaRepository().getUserByDocId(pengeluaran.verifikatorId),
                          builder: (context, snap) {
                            String verifikatorLabel = pengeluaran.verifikatorId.toString();
                            if (pengeluaran.verifikatorId.isEmpty) {
                              verifikatorLabel = 'Belum diverifikasi';
                            } else if (snap.connectionState == ConnectionState.waiting) {
                              verifikatorLabel = 'Memuat...';
                            } else if (snap.hasError) {
                              verifikatorLabel = pengeluaran.verifikatorId.toString();
                            } else if (snap.hasData && snap.data != null) {
                              verifikatorLabel = (snap.data!).nama;
                            }
                            return _buildDetailRow("Verifikator:", verifikatorLabel);
                          },
                        ),
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