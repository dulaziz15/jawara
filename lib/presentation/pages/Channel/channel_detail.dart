import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/core/models/channel_models.dart';
import 'package:jawara/core/repositories/channel_repository.dart';

@RoutePage()
class ChannelDetailPage extends StatefulWidget {
  final String channelId;

  const ChannelDetailPage({
    super.key,
    required this.channelId,
  });

  @override
  State<ChannelDetailPage> createState() => _ChannelDetailPageState();
}

class _ChannelDetailPageState extends State<ChannelDetailPage> {
  // 1. Panggil Repository (TIDAK BERUBAH)
  final ChannelRepository _repository = ChannelRepository();
  late Future<ChannelModel?> _detailFuture;

  @override
  void initState() {
    super.initState();
    // 2. Inisialisasi (TIDAK BERUBAH)
    _detailFuture = _repository.getChannelByDocId(widget.channelId);
  }

  // Helper Image (Logika TETAP, hanya menambahkan parameter size untuk styling UI)
  Widget _buildImage(String imagePath, {double? width, double? height, BoxFit fit = BoxFit.cover}) {
    if (imagePath.isEmpty) {
      return Container(
        width: width ?? 100,
        height: height ?? 100,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.image_not_supported, color: Colors.grey),
      );
    }

    Widget imageWidget;
    // Cek apakah URL (http/https) atau Asset Lokal
    if (imagePath.startsWith('http')) {
      imageWidget = Image.network(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: Colors.grey.shade200,
          child: const Icon(Icons.broken_image, color: Colors.grey),
        ),
      );
    } else {
      imageWidget = Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: Colors.grey.shade200,
          child: const Icon(Icons.image_not_supported, color: Colors.grey),
        ),
      );
    }

    // Membungkus dengan ClipRRect agar sudutnya tumpul (Rounded)
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: imageWidget,
    );
  }

  // Helper widget detail item (Dipercantik dengan Icon)
  Widget _buildDetailItem(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF6C63FF), size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  (value != null && value.isNotEmpty) ? value : '-',
                  style: const TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE), // Background lebih soft
      appBar: AppBar(
        // title: const Text(
        //   "Detail Channel",
        //   style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        // ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF8F9FE),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => context.router.pop(),
        ),
      ),
      // 3. FutureBuilder (LOGIKA TIDAK BERUBAH)
      body: FutureBuilder<ChannelModel?>(
        future: _detailFuture,
        builder: (context, snapshot) {
          // A. Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // B. Error State
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 10),
                    Text("Terjadi kesalahan: ${snapshot.error}", textAlign: TextAlign.center),
                  ],
                ),
              ),
            );
          }

          // C. Data Kosong
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.inbox, color: Colors.grey, size: 48),
                  SizedBox(height: 10),
                  Text("Data channel tidak ditemukan"),
                ],
              ),
            );
          }

          // D. Data Ditemukan
          final channel = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // === SECTION 1: TEXT INFO ===
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informasi Channel',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                      const Divider(height: 30),
                      // Urutan Data Sesuai Request: Nama -> Tipe -> Pemilik
                      _buildDetailItem(Icons.tv, 'Nama Channel', channel.nama),
                      _buildDetailItem(Icons.category, 'Tipe Channel', channel.tipe),
                      _buildDetailItem(Icons.person, 'Nama Pemilik (A/N)', channel.an),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // === SECTION 2: QR CODE ===
                // Urutan Data Sesuai Request: QR
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.qr_code_2, color: Color(0xFF6C63FF)),
                          const SizedBox(width: 10),
                          const Text(
                            'QR Code Pembayaran',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3142),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4F4F8),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: _buildImage(
                          channel.qr, 
                          width: 200, 
                          height: 200,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // === SECTION 3: THUMBNAIL ===
                // Urutan Data Sesuai Request: Thumbnail
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.image, color: Color(0xFF6C63FF)),
                          const SizedBox(width: 10),
                          const Text(
                            'Thumbnail Channel',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3142),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 200, // Membuat thumbnail lebih besar/lebar
                        child: _buildImage(
                          channel.thumbnail, 
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}