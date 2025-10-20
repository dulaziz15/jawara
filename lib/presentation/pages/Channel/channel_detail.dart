import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/presentation/pages/Channel/Channel_daftar.dart';

@RoutePage()
class ChannelDetailPage extends StatelessWidget {
  final int channelId;

  const ChannelDetailPage({super.key, required this.channelId});

  @override
  Widget build(BuildContext context) {
    // --- Simulasi Data (bisa diganti ambil dari database/API)
    final List<Channel> channels = const [
      Channel(id: 1, no: 1, nama: 'Transfer via BCA', tipe: 'Bank', an: 'RT Jawara Karangploso', thumbnail: '-'),
      Channel(id: 2, no: 2, nama: 'Copay Ketua RT', tipe: 'Exadilet', an: 'Budi Santoso', thumbnail: '-'),
      Channel(id: 3, no: 3, nama: 'QRIS Resmi RT 08', tipe: 'QRIS', an: 'RW 08 Karangploso', thumbnail: '-'),
    ];

    final channel = channels.firstWhere((c) => c.id == channelId);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          iconSize: 24,
          onPressed: () => context.router.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Detail Transfer Channel',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                ),
                const SizedBox(height: 24),

                _buildDetailItem('Nama Channel', channel.nama),
                _buildDetailItem('Tipe Channel', channel.tipe),
                _buildDetailItem('Nama Pemilik', channel.an),
                _buildDetailItem('Catatan', 'Scan QR di bawah untuk membayar. Kirim bukti setelah pembayaran.'),

                const SizedBox(height: 16),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Tidak ada QR/Thumbnail'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
          const SizedBox(height: 4),
          Text(value.isNotEmpty ? value : '-', style: const TextStyle(fontSize: 15, color: Colors.black87)),
        ],
      ),
    );
  }
}
