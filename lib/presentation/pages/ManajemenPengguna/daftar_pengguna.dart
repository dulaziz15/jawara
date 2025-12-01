import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/core/routes/app_router.dart';
import 'package:jawara/core/models/pengguna_models.dart';
import 'package:jawara/presentation/pages/ManajemenPengguna/filter_pengguna.dart';
import 'package:jawara/core/repositories/pengguna_repository.dart';

@RoutePage()
class DaftarPenggunaPage extends StatefulWidget {
  const DaftarPenggunaPage({super.key});

  @override
  State<DaftarPenggunaPage> createState() => _DaftarPenggunaPageState();
}

class _DaftarPenggunaPageState extends State<DaftarPenggunaPage> {
  final PenggunaRepository _penggunaRepository = PenggunaRepository();

  List<UserModel> allUsers = [];
  List<UserModel> displayedUsers = [];

  int currentPage = 1;
  final int itemsPerPage = 10;

  @override
  void initState() {
    super.initState();

    // Ambil data realtime dari Firestore
    _penggunaRepository.getAllUsers().listen((users) {
      setState(() {
        allUsers = users;
        displayedUsers = users;
        currentPage = 1;
      });
    });
  }

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
            displayedUsers = allUsers.where((user) {
              final matchNama = nama.trim().isEmpty ||
                  user.nama.toLowerCase().contains(nama.toLowerCase());
              final matchStatus = status == null || user.statusHidup == status;
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
        backgroundColor = Colors.green;
        break;
      case 'diproses':
        backgroundColor = Colors.blue;
        break;
      case 'ditolak':
        backgroundColor = Colors.red;
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
      child: Text(
        status,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  void _showDetailDialog(UserModel user) {
    context.router.push(PenggunaDetailRoute(userId: user.nik));
  }

  void _navigateToEdit(UserModel user) {
    context.router.push(PenggunaEditRoute(userId: user.nik));
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
              SizedBox(width: 8),
              Text('Detail'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
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
                        displayedUsers = allUsers.where((user) {
                          final matchNama = user.nama
                              .toLowerCase()
                              .contains(value.toLowerCase());
                          final matchEmail = user.email
                              .toLowerCase()
                              .contains(value.toLowerCase());
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

          // Jumlah Data ditemukan
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
        backgroundColor: const Color(0xFF6C63FF),
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
        child: Row(
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
                  // Text(
                  //   'Role: ${user.role}',
                  //   style: const TextStyle(
                  //     color: Colors.grey,
                  //     fontSize: 14,
                  //   ),
                  // ),
                ],
              ),
            ),
            Column(
              children: [
                _buildStatusBadge(user.statusHidup),
                const SizedBox(height: 8),
                _buildActionButton(user),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
