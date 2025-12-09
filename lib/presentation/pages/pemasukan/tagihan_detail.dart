import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
// Ganti path import di bawah ini sesuai struktur folder project Anda
import 'package:jawara/core/models/tagihan_model.dart';
import 'package:jawara/core/repositories/tagihan_repository.dart';
import 'package:jawara/core/utils/formatter_util.dart';

@RoutePage()
class TagihanDetailPage extends StatefulWidget {
  final String tagihanId;

  const TagihanDetailPage({
    super.key,
    @PathParam('id') required this.tagihanId,
  });

  @override
  State<TagihanDetailPage> createState() => _TagihanDetailPageState();
}

class _TagihanDetailPageState extends State<TagihanDetailPage> {
  // 1. Inisialisasi Repository
  final TagihanRepository _repository = TagihanRepository();
  
  // Variable untuk menyimpan Future agar tidak dipanggil ulang saat rebuild
  late Future<TagihanModel?> _detailFuture;

  @override
  void initState() {
    super.initState();
    // 2. Panggil fungsi getDetail saat halaman pertama kali dibuka
    _detailFuture = _repository.getTagihanDetail(widget.tagihanId);
  }

  // --- WIDGET HELPER: Membuat Baris Text Detail ---
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
            value.isEmpty ? '-' : value, // Handle jika kosong tampilkan strip
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

  // --- WIDGET HELPER: Menampilkan Lampiran/Bukti ---
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER: Badge Status (Lunas/Belum) ---
  Widget _buildStatusBadge(String status) {
    Color statusColor;
    String statusText;

    // Normalisasi string status (kecilkan huruf biar aman)
    String s = (status).toLowerCase();

    if (s == 'paid' || s == 'lunas') {
      statusColor = Colors.green;
      statusText = 'Lunas';
    } else if (s == 'unpaid' || s == 'belum lunas') {
      statusColor = Colors.red;
      statusText = 'Belum Lunas';
    } else {
      statusColor = Colors.grey;
      statusText = status.isEmpty ? 'Tidak Diketahui' : status;
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
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Detail Tagihan',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.router.pop(), // Kembali ke halaman list
        ),
      ),
      
      // 3. Gunakan FutureBuilder
      body: FutureBuilder<TagihanModel?>(
        future: _detailFuture,
        builder: (context, snapshot) {
          
          // STATE: LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // STATE: ERROR
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      "Terjadi kesalahan:\n${snapshot.error}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            );
          }

          // STATE: DATA KOSONG (NULL)
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    "Data tagihan tidak ditemukan.\nID: ${widget.tagihanId}",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            );
          }

          // STATE: SUKSES (DATA ADA)
          final tagihan = snapshot.data!;
          final String nominalFormatted = FormatterUtil.formatCurrency(tagihan.nominal);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        // Informasi Transaksi
                        _buildDetailRow("Kode Transaksi (ID):", tagihan.docId ?? ''),
                        _buildDetailRow("Nama Iuran:", tagihan.namaIuran),
                        _buildDetailRow("Kategori:", tagihan.kategori),
                        _buildDetailRow("Periode:", tagihan.periode),
                        _buildDetailRow("Nominal:", 'Rp $nominalFormatted'),
                        
                        const Divider(height: 32),
                        
                        // Informasi Warga (Hasil Join)
                        const Text("Informasi Warga", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 16),
                        _buildDetailRow("Nama Kepala Keluarga:", tagihan.namaWarga),
                        _buildDetailRow("Alamat:", tagihan.alamatWarga),
                        
                        const Divider(height: 32),

                        // Informasi Pembayaran
                        const Text("Status Pembayaran", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 16),
                        
                        Row(
                          children: [
                            const Text(
                              "Status Terkini:",
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            const SizedBox(width: 12),
                            _buildStatusBadge(tagihan.status),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        _buildDetailRow("Metode Pembayaran:", tagihan.metodePembayaran),
                        
                        // Tampilkan Bukti jika ada
                        _buildAttachmentRow("Bukti Pembayaran:", tagihan.bukti),
                        
                        // Tampilkan Alasan Penolakan jika ada
                        if (tagihan.alasanPenolakan.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Alasan Penolakan:", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(tagihan.alasanPenolakan, style: const TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                        ],
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