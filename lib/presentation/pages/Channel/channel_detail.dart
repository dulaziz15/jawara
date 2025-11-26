import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/core/models/channel_models.dart';
import 'package:jawara/core/repositories/channel_repository.dart';

@RoutePage()
class ChannelDetailPage extends StatefulWidget {
  final String channelId;

  const ChannelDetailPage({
    super.key,
    // Jika menggunakan AutoRoute dengan parameter path, tambahkan @PathParam
    // @PathParam('id') required this.channelId, 
    required this.channelId,
  });

  @override
  State<ChannelDetailPage> createState() => _ChannelDetailPageState();
}

class _ChannelDetailPageState extends State<ChannelDetailPage> {
  // 1. Panggil Repository
  final ChannelRepository _repository = ChannelRepository();
  late Future<ChannelModel?> _detailFuture;

  @override
  void initState() {
    super.initState();
    // 2. Inisialisasi pengambilan data saat halaman dibuka
    // Pastikan fungsi getChannelByDocId ada di Repository Anda
    _detailFuture = _repository.getChannelByDocId(widget.channelId);
  }

  // Helper untuk menampilkan gambar (Support Network & Asset)
  Widget _buildImage(String imagePath) {
    if (imagePath.isEmpty) {
      return Container(
        width: 100,
        height: 100,
        color: Colors.grey.shade200,
        child: const Icon(Icons.image_not_supported, color: Colors.grey),
      );
    }

    // Cek apakah URL (http/https) atau Asset Lokal
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 100,
          height: 100,
          color: Colors.grey.shade200,
          child: const Icon(Icons.broken_image, color: Colors.grey),
        ),
      );
    } else {
      return Image.asset(
        imagePath,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 100,
          height: 100,
          color: Colors.grey.shade200,
          child: const Icon(Icons.image_not_supported, color: Colors.grey),
        ),
      );
    }
  }

  // Helper widget detail item (Sesuai UI Channel)
  Widget _buildDetailItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            (value != null && value.isNotEmpty) ? value : '-',
            style: const TextStyle(fontSize: 15, color: Colors.black87),
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
      body: FutureBuilder<ChannelModel?>(
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
            return const Center(child: Text("Data channel tidak ditemukan"));
          }

          // D. Data Ditemukan
          final channel = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
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
                        color: Color(0xFF6C63FF),
                      ),
                    ),
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

                    // Tampilkan QR
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _buildImage(channel.qr),
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

                    // Tampilkan Thumbnail
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: _buildImage(channel.thumbnail),
                      ),
                    ),
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