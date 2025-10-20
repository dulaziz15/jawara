import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/core/routes/app_router.dart';
import 'package:jawara/presentation/pages/ManajemenPengguna/filter_pengguna.dart';
import 'package:jawara/presentation/pages/ManajemenPengguna/pengguna_edit.dart';
import 'package:jawara/presentation/pages/ManajemenPengguna/pengguna_detail.dart';

/// === MODEL DATA ===
class UserModel {
  final int id;
  final String nama;
  final String email;
  final String status;
  final String role;
  final String nik;
  final String noHp;
  final String jenisKelamin;

  const UserModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.status,
    required this.role,
    required this.nik,
    required this.noHp,
    required this.jenisKelamin,
  });
}

/// === DATA DUMMY ===
final List<UserModel> daftarPengguna = const [
  UserModel(
    id: 1,
    nama: 'dewqedwddw',
    email: 'admiwewen1@gmail.com',
    status: 'Diterima',
    role: 'Admin',
    nik: '1234567890123451',
    noHp: '081234567891',
    jenisKelamin: 'Laki-laki',
  ),
  UserModel(
    id: 2,
    nama: 'Rendha Putra Rahmadya',
    email: 'rendhazuper@gmail.com',
    status: 'Diproses',
    role: 'Admin',
    nik: '1234567890123452',
    noHp: '081234567892',
    jenisKelamin: 'Laki-laki',
  ),
  UserModel(
    id: 3,
    nama: 'bla',
    email: 'y@gmail.com',
    status: 'Ditolak',
    role: 'Admin',
    nik: '1234567890123453',
    noHp: '081234567893',
    jenisKelamin: 'Laki-laki',
  ),
  UserModel(
    id: 4,
    nama: 'Anti Micin',
    email: 'antimicin3@gmail.com',
    status: 'Diterima',
    role: 'Admin',
    nik: '1234567890123454',
    noHp: '081234567894',
    jenisKelamin: 'Perempuan',
  ),
  UserModel(
    id: 5,
    nama: 'ijat4',
    email: 'ijat4@gmail.com',
    status: 'Diproses',
    role: 'Admin',
    nik: '1234567890123455',
    noHp: '081234567895',
    jenisKelamin: 'Laki-laki',
  ),
  UserModel(
    id: 6,
    nama: 'ijat3',
    email: 'ijat3@gmail.com',
    status: 'Diterima',
    role: 'Admin',
    nik: '1234567890123456',
    noHp: '081234567896',
    jenisKelamin: 'Laki-laki',
  ),
  UserModel(
    id: 7,
    nama: 'ijat2',
    email: 'ijat2@gmail.com',
    status: 'Ditolak',
    role: 'Admin',
    nik: '1234567890123457',
    noHp: '081234567897',
    jenisKelamin: 'Laki-laki',
  ),
  UserModel(
    id: 8,
    nama: 'AFIFAH KHOIRUNNISA',
    email: 'afi@gmail.com',
    status: 'Diterima',
    role: 'Warga',
    nik: '1234567890123458',
    noHp: '081234567898',
    jenisKelamin: 'Perempuan',
  ),
  UserModel(
    id: 9,
    nama: 'Raudhil Firdaus Naufal',
    email: 'raudhilfirdausn@gmail.com',
    status: 'Diproses',
    role: 'Warga',
    nik: '1234567890123459',
    noHp: '081234567899',
    jenisKelamin: 'Laki-laki',
  ),
  UserModel(
    id: 10,
    nama: 'varizky naldiba rimra',
    email: 'zelectra1011@gmail.com',
    status: 'Diterima',
    role: 'Warga',
    nik: '1234567890123460',
    noHp: '081234567890',
    jenisKelamin: 'Laki-laki',
  ),
];

@RoutePage()
class DaftarPenggunaPage extends StatefulWidget {
  const DaftarPenggunaPage({super.key});

  @override
  State<DaftarPenggunaPage> createState() => _DaftarPenggunaPageState();
}

class _DaftarPenggunaPageState extends State<DaftarPenggunaPage> {
  List<UserModel> displayedUsers = daftarPengguna;
  int currentPage = 1;
  final int itemsPerPage = 10;

  List<UserModel> get paginatedUsers {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = (startIndex + itemsPerPage) > displayedUsers.length
        ? displayedUsers.length
        : (startIndex + itemsPerPage);
    return displayedUsers.sublist(startIndex, endIndex);
  }

  void _openFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => FilterPengguna(
        onFilter: (nama, status) {
          setState(() {
            displayedUsers = daftarPengguna.where((user) {
              final matchNama = nama.trim().isEmpty ||
                  user.nama.toLowerCase().contains(nama.toLowerCase());
              final matchStatus = status == null || user.status == status;
              return matchNama && matchStatus;
            }).toList();
            currentPage = 1;
          });
        },
      ),
    );
  }

  void _nextPage() {
    if (currentPage * itemsPerPage < displayedUsers.length) {
      setState(() => currentPage++);
    }
  }

  void _prevPage() {
    if (currentPage > 1) {
      setState(() => currentPage--);
    }
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;

    switch (status.toLowerCase()) {
      case 'diterima':
        backgroundColor = Colors.green.shade200;
        break;
      case 'diproses':
        backgroundColor = Colors.blue.shade200;
        break;
      case 'ditolak':
        backgroundColor = Colors.red.shade200;
        break;
      default:
        backgroundColor = Colors.grey.shade300;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildPagination() {
    int totalPages = (displayedUsers.length / itemsPerPage).ceil();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(100),
            color: Colors.white,
          ),
          child: IconButton(
            onPressed: _prevPage,
            icon: const Icon(Icons.chevron_left),
          ),
        ),
        const SizedBox(width: 8),
        for (int i = 1; i <= totalPages; i++)
          GestureDetector(
            onTap: () => setState(() => currentPage = i),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: i == currentPage ? Colors.deepPurple : Colors.white,
                border: Border.all(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Text(
                '$i',
                style: TextStyle(
                  color: i == currentPage ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(100),
            color: Colors.white,
          ),
          child: IconButton(
            onPressed: _nextPage,
            icon: const Icon(Icons.chevron_right),
          ),
        ),
      ],
    );
  }

  void _showDetailDialog(UserModel user) {
    context.router.push(DetailPenggunaRoute(userId: user.id));
  }

  void _navigateToEdit(UserModel user) {
    context.router.push(EditPenggunaRoute(userId: user.id));
  }

  
  

  Widget _buildActionButton(UserModel user) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.black54),
      onSelected: (value) {
        if (value == 'detail') _showDetailDialog(user);
        if (value == 'edit') _navigateToEdit(user);
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 'detail',
          child: Row(
            children: [
              Icon(Icons.visibility, size: 18, color: Colors.blue),
              SizedBox(width: 8),
              Text('Detail'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, size: 18, color: Colors.orange),
              SizedBox(width: 8),
              Text('Edit'),
            ],
          ),
        ),
        
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Data Pengguna',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF4F6DF5),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.grey),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        displayedUsers = daftarPengguna.where((user) {
                          final matchNama = user.nama.toLowerCase().contains(value.toLowerCase());
                          final matchEmail = user.email.toLowerCase().contains(value.toLowerCase());
                          return matchNama || matchEmail;
                        }).toList();
                        currentPage = 1;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Cari berdasarkan nama atau email...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Jumlah data ditemukan
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              '${displayedUsers.length} data ditemukan',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),

          // List Data
          Expanded(
            child: displayedUsers.isEmpty
                ? Center(
                    child: Text(
                      'Data tidak ditemukan',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: paginatedUsers.length,
                    itemBuilder: (context, index) {
                      final user = paginatedUsers[index];
                      return _buildDataCard(user);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openFilterDialog,
        backgroundColor: const Color(0xFF4F6DF5),
        child: const Icon(Icons.filter_list, color: Colors.white),
      ),
    );
  }

  Widget _buildDataCard(UserModel user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.nama,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Email: ${user.email}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Role: ${user.role}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    _buildStatusBadge(user.status),
                    const SizedBox(height: 8),
                    _buildActionButton(user),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
