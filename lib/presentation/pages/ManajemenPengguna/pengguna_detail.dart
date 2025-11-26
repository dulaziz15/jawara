import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/core/models/pengguna_models.dart';

@RoutePage()
class PenggunaDetailPage extends StatelessWidget {
  final String userId;

  const PenggunaDetailPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final user = daftarPengguna.firstWhere(
      (u) => u.docId == userId,
      orElse: () => const UserModel(
        docId: '0',
        nama: 'Tidak Ditemukan',
        email: '-',
        role: '-',
        nik: '-',
        noHp: '-',
        jenisKelamin: '-',
        idKeluarga: '',
        statusDomisili: '',
        statusHidup: '',
        buktiIdentitas: '',
      ),
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        // title: const Text('Detail Pengguna'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              // === FOTO PROFIL ===
              const CircleAvatar(
                radius: 55,
                backgroundColor: Color(0xFF6C63FF),
                child: Icon(Icons.person, size: 65, color: Colors.white),
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
                        'Status Registrasi',
                        user.statusDomisili,
                        valueColor: _getStatusColor(user.statusDomisili),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    IconData icon,
    String label,
    String value, {
    Color valueColor = Colors.black87,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Color(0xFF6C63FF), size: 26),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Diterima':
        return Colors.green;
      case 'Diproses':
        return Colors.orange;
      case 'Ditolak':
        return Colors.red;
      default:
        return Colors.black87;
    }
  }
}
