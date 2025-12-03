import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/core/models/tagihan_model.dart';
import 'package:jawara/core/utils/formatter_util.dart';
import 'package:jawara/core/models/family_models.dart';

@RoutePage()
class TagihanDetailPage extends StatelessWidget {
  final String tagihanId;

  const TagihanDetailPage({
    super.key,
    @PathParam('id') required this.tagihanId,
  });

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
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey),
                )
              : Row(
                  children: [
                    Icon(icon, color: Color(0xFF6C63FF), size: 20),
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

  String _getNamaKeluarga(String nikKepalaKeluarga) {
    final family = FamilyModel.dummyFamilies.firstWhere(
      (f) => f.nikKepalaKeluarga == nikKepalaKeluarga,
      orElse: () => FamilyModel.dummyFamilies.first,
    );
    return family.namaKeluarga;
  }

  String _getAlamat(String nikKepalaKeluarga) {
    final family = FamilyModel.dummyFamilies.firstWhere(
      (f) => f.nikKepalaKeluarga == nikKepalaKeluarga,
      orElse: () => FamilyModel.dummyFamilies.first,
    );
    return family.alamatRumah;
  }
  // Helper widget untuk status dengan badge
  Widget _buildStatusBadge(String status) {
    Color statusColor;
    String statusText;

    switch (status.toLowerCase()) {
      case 'paid':
        statusColor = Colors.green;
        statusText = 'Lunas';
        break;
      case 'unpaid':
        statusColor = Colors.red;
        statusText = 'Belum Lunas';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Tidak Diketahui';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: statusColor,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ambil data tagihan yang sesuai berdasarkan ID
    final tagihan = dummyTagihan.firstWhere((item) => item.docId == tagihanId);
    final namaKeluarga = _getNamaKeluarga(tagihan.nik);
    final alamat = _getAlamat(tagihan.nik);

    // Format nominal
    final String nominalFormatted = FormatterUtil.formatCurrency(tagihan.nominal);

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Detail Tagihan
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
                    _buildDetailRow("Kode Iuran:", tagihan.kodeIuran),
                    _buildDetailRow("Nama Iuran:", tagihan.namaIuran),
                    _buildDetailRow("Kategori:", tagihan.kategori),
                    _buildDetailRow("Periode:", tagihan.periode),
                    _buildDetailRow("Nominal:", 'Rp $nominalFormatted'),
                    _buildDetailRow("Nama KK:", namaKeluarga),
                    _buildDetailRow("Alamat:", alamat),
                    _buildDetailRow("Metode Pembayaran:", tagihan.metodePembayaran.isEmpty ? '-' : tagihan.metodePembayaran),
                    const Divider(height: 24),
                    _buildAttachmentRow("Bukti Pembayaran:", tagihan.bukti),
                    if (tagihan.alasanPenolakan.isNotEmpty) ...[
                      const Divider(height: 24),
                      _buildDetailRow("Alasan Penolakan:", tagihan.alasanPenolakan),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text(
                          "Status:",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(width: 12),
                        _buildStatusBadge(tagihan.status),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
