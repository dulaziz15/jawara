import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/core/models/channel_models.dart';

@RoutePage()
class ChannelDetailPage extends StatelessWidget {
  final int channelId;

  const ChannelDetailPage({super.key, required this.channelId});

  @override
  Widget build(BuildContext context) {
    // Ambil data channel dari model
    final channel = dummyChannels.firstWhere(
      (c) => c.id == channelId,
      orElse: () => throw Exception('Channel dengan ID $channelId tidak ditemukan'),
    );

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
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Detail Transfer Channel',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 24),

                // Thumbnail dari assets
                

                const SizedBox(height: 24),

                _buildDetailItem('Nama Channel', channel.nama),
                _buildDetailItem('Tipe Channel', channel.tipe),
                _buildDetailItem('Nama Pemilik', channel.an),

                const SizedBox(height: 12),
                const Text(
                  'QR Code Pembayaran',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                // QR dari assets
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      channel.qr ,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Thumbnail',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                       channel.thumbnail,
                       width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.black87)),
          const SizedBox(height: 4),
          Text((value != null && value.isNotEmpty) ? value : '-',
              style: const TextStyle(fontSize: 15, color: Colors.black87)),
        ],
      ),
    );
  }
}
