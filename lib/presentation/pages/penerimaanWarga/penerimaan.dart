import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'filter_accept.dart';

// --- DATA MODEL ---
class RegistrationData {
  final int no;
  final String nama;
  final String nik;
  final String email;
  final String jenisKelamin; // 'L' atau 'P'
  final String fotoIdentitasAsset;
  final String statusRegistrasi;

  const RegistrationData({
    required this.no,
    required this.nama,
    required this.nik,
    required this.email,
    required this.jenisKelamin,
    required this.fotoIdentitasAsset,
    required this.statusRegistrasi,
  });
}

@RoutePage()
class PenerimaanPage extends StatefulWidget {
  const PenerimaanPage({super.key});

  @override
  State<PenerimaanPage> createState() => _PenerimaanPageState();
}

class _PenerimaanPageState extends State<PenerimaanPage> {
  final List<RegistrationData> _allData = const [
    RegistrationData(
      no: 1,
      nama: 'Mara Nunez',
      nik: '1234567890123456',
      email: 'mara.nunez@gmail.com',
      jenisKelamin: 'P',
      fotoIdentitasAsset: 'assets/1.png',
      statusRegistrasi: 'Pending',
    ),
    RegistrationData(
      no: 2,
      nama: 'Sinta Sulistya',
      nik: '1234567890987654',
      email: 'Sisulis13@gmail.com',
      jenisKelamin: 'P',
      fotoIdentitasAsset: 'assets/2.png',
      statusRegistrasi: 'Pending',
    ),
    RegistrationData(
      no: 3,
      nama: 'Intan Sari',
      nik: '2025202520252025',
      email: 'sariIntan@gmail.com',
      jenisKelamin: 'P',
      fotoIdentitasAsset: 'assets/3.png',
      statusRegistrasi: 'Diterima',
    ),
    RegistrationData(
      no: 4,
      nama: 'Abdul Aziz',
      nik: '3201122501050002',
      email: 'dulaziz@gmail.com',
      jenisKelamin: 'L',
      fotoIdentitasAsset: 'assets/4.png',
      statusRegistrasi: 'Diterima',
    ),
  ];

  List<RegistrationData> _filteredData = [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Semua';

  @override
  void initState() {
    super.initState();
    _filteredData = _allData;
  }

  void _applyFilter(String status) {
    setState(() {
      _selectedFilter = status;
      
      // Apply filter status terlebih dahulu
      List<RegistrationData> statusFilteredData;
      if (status == 'Semua') {
        statusFilteredData = _allData;
      } else {
        statusFilteredData = _allData.where((data) => data.statusRegistrasi == status).toList();
      }
      
      // Kemudian apply search filter jika ada
      if (_searchController.text.isNotEmpty) {
        _filteredData = statusFilteredData
            .where((data) =>
                data.nama.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                data.nik.toLowerCase().contains(_searchController.text.toLowerCase()))
            .toList();
      } else {
        _filteredData = statusFilteredData;
      }
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      // Apply search filter terlebih dahulu
      List<RegistrationData> searchFilteredData;
      if (value.isEmpty) {
        searchFilteredData = _allData;
      } else {
        searchFilteredData = _allData
            .where((data) =>
                data.nama.toLowerCase().contains(value.toLowerCase()) ||
                data.nik.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
      
      // Kemudian apply status filter jika bukan 'Semua'
      if (_selectedFilter != 'Semua') {
        _filteredData = searchFilteredData.where((data) => data.statusRegistrasi == _selectedFilter).toList();
      } else {
        _filteredData = searchFilteredData;
      }
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => FilterPenerimaanWargaDialog(
        initialStatus: _selectedFilter,
        onApplyFilter: _applyFilter,
      ),
    );
  }

  void _showDetailModal(BuildContext context, RegistrationData item) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Dialog
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Detail Pendaftaran Warga',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4F6DF5),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.of(dialogContext).pop(),
                    ),
                  ],
                ),
                const Divider(thickness: 1.2),
                const SizedBox(height: 16),

                // Nama (besar dan bold di kiri)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item.nama,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // NIK
                _detailRow('NIK', item.nik),
                const SizedBox(height: 12),

                // Email
                _detailRow('Email', item.email),
                const SizedBox(height: 12),

                // Jenis Kelamin
                _detailRow(
                  'Jenis Kelamin',
                  item.jenisKelamin == 'L' ? 'Laki-laki' : 'Perempuan',
                ),
                const SizedBox(height: 12),

                // Status Pendaftaran dengan label warna
                Row(
                  children: [
                    const SizedBox(
                      width: 120,
                      child: Text(
                        'Status Pendaftaran:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(item.statusRegistrasi),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item.statusRegistrasi,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Foto Identitas
                const Text(
                  'Foto Identitas:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 150,
                      height: 150,
                      color: Colors.grey.shade200,
                      child: Image.asset(
                        item.fotoIdentitasAsset,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Tombol Tutup (sebelah kiri)
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F6DF5),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Tutup',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'diterima':
        return Colors.green;
      case 'ditolak':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Data Pendaftaran Warga',
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
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: const InputDecoration(
                      hintText: 'Cari berdasarkan Nama atau NIK...',
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
              '${_filteredData.length} data ditemukan',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),

          // List Data
          Expanded(
            child: _filteredData.isEmpty
                ? Center(
                    child: Text(
                      'Data tidak ditemukan',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredData.length,
                    itemBuilder: (context, index) {
                      final item = _filteredData[index];
                      return _buildDataCard(item);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFilterDialog,
        backgroundColor: const Color(0xFF4F6DF5),
        child: const Icon(Icons.filter_list, color: Colors.white),
      ),
    );
  }

  Widget _buildDataCard(RegistrationData item) {
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
                        item.nama,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'NIK: ${item.nik}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Email: ${item.email}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    _buildStatusBadge(item.statusRegistrasi),
                    const SizedBox(width: 8),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'detail') {
                          _showDetailModal(context, item);
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'detail', child: Text('Detail')),
                      ],
                      icon: const Icon(Icons.more_vert, color: Colors.grey),
                    ),
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