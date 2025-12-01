import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/core/models/pengguna_models.dart';
import 'package:jawara/core/repositories/pengguna_repository.dart';

@RoutePage()
class PenggunaDetailPage extends StatefulWidget {
  final String userId;

  const PenggunaDetailPage({super.key, required this.userId});

  @override
  State<PenggunaDetailPage> createState() => _PenggunaDetailPageState();
}

class _PenggunaDetailPageState extends State<PenggunaDetailPage> {
  // 1. Panggil Repository
  final PenggunaRepository _repository = PenggunaRepository();
  late Future<UserModel?> _userFuture;

  @override
  void initState() {
    super.initState();
    // 2. Ambil data saat halaman dibuka
    _userFuture = _repository.getUserByNik(widget.userId);
  }

  // Helper untuk warna status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Aktif': // Sesuaikan dengan data dummy/firebase Anda
      case 'Diterima':
        return Colors.green;
      case 'Diproses':
        return Colors.orange;
      case 'Nonaktif':
      case 'Ditolak':
        return Colors.red;
      default:
        return Colors.black87;
    }
  }

  // Helper untuk item info
  Widget _buildInfoItem(
    IconData icon,
    String label,
    String value, {
    Color valueColor = Colors.black87,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF6C63FF), size: 26),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: valueColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.pop(),
        ),
      ),
      // 3. Gunakan FutureBuilder
      body: FutureBuilder<UserModel?>(
        future: _userFuture,
        builder: (context, snapshot) {
          // A. Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // B. Error
          if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          }

          // C. Data Kosong
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Pengguna tidak ditemukan"));
          }

          // D. Data Ada (Ambil dari snapshot)
          final user = snapshot.data!;

          // UI ASLI ANDA
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  // === FOTO PROFIL ===
                  // Logic foto: Cek apakah URL (Firebase Storage) atau Asset Lokal
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: const Color(0xFF6C63FF),
                    backgroundImage: (user.buktiIdentitas.isNotEmpty &&
                            user.buktiIdentitas.startsWith('http'))
                        ? NetworkImage(user.buktiIdentitas) as ImageProvider
                        : const AssetImage('assets/images/placeholder_user.png'), // Default asset jika kosong/error
                    child: (user.buktiIdentitas.isEmpty) 
                        ? const Icon(Icons.person, size: 65, color: Colors.white)
                        : null,
                  ),

                  const SizedBox(height: 16),

                  // === NAMA DAN ROLE ===
                  Text(
                    user.nama,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.role,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),

                  const SizedBox(height: 20),
                  const Divider(thickness: 1),

                  const SizedBox(height: 16),

                  // === KARTU DETAIL INFORMASI ===
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoItem(Icons.credit_card, 'NIK', user.nik),
                          const SizedBox(height: 16),
                          _buildInfoItem(Icons.email, 'Email', user.email),
                          const SizedBox(height: 16),
                          _buildInfoItem(Icons.phone, 'Nomor HP', user.noHp),
                          const SizedBox(height: 16),
                          _buildInfoItem(
                            Icons.person_outline,
                            'Jenis Kelamin',
                            user.jenisKelamin,
                          ),
                          const SizedBox(height: 16),
                          _buildInfoItem(
                            Icons.verified_user,
                            'Status Domisili',
                            user.statusDomisili,
                            valueColor: _getStatusColor(user.statusDomisili),
                          ),
                           const SizedBox(height: 16),
                          _buildInfoItem(
                            Icons.favorite, // Icon untuk status hidup
                            'Status Hidup',
                            user.statusHidup,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}