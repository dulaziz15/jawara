import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'filter_mutasi.dart';

// --- DATA MODEL ---
class MutasiData {
  final int no;
  final String keluarga;
  final String alamatLama;
  final String alamatBaru;
  final String tanggalMutasi;
  final String jenisMutasi;
  final String alasan;

  const MutasiData({
    required this.no,
    required this.keluarga,
    required this.alamatLama,
    required this.alamatBaru,
    required this.tanggalMutasi,
    required this.jenisMutasi,
    required this.alasan,
  });
}

@RoutePage()
class DaftarMutasiPage extends StatefulWidget {
  const DaftarMutasiPage({super.key});

  @override
  State<DaftarMutasiPage> createState() => _MutasiKeluargaPageState();
}

class _MutasiKeluargaPageState extends State<DaftarMutasiPage> {
  final List<MutasiData> _allData = const [
    MutasiData(
      no: 1,
      keluarga: 'Keluarga Rendha Putra Rahmadya',
      alamatLama: 'Jl. Merdeka No. 123, Jakarta Pusat',
      alamatBaru: 'Jl. Sudirman No. 456, Jakarta Selatan',
      tanggalMutasi: '15-10-2025',
      jenisMutasi: 'Pindah Domisili',
      alasan: 'Pekerjaan',
    ),
    MutasiData(
      no: 2,
      keluarga: 'Keluarga Anti Micin',
      alamatLama: 'Jl. Pahlawan No. 78, Bandung',
      alamatBaru: 'Jl. Gatot Subroto No. 90, Surabaya',
      tanggalMutasi: '20-10-2025',
      jenisMutasi: 'Pindah Kota',
      alasan: 'Pendidikan',
    ),
    MutasiData(
      no: 3,
      keluarga: 'Keluarga varizky naldiba rimra',
      alamatLama: 'Jl. Melati No. 11, Yogyakarta',
      alamatBaru: 'Jl. Kenanga No. 22, Semarang',
      tanggalMutasi: '25-10-2025',
      jenisMutasi: 'Pindah Domisili',
      alasan: 'Keluarga',
    ),
    MutasiData(
      no: 4,
      keluarga: 'Keluarga Ijat',
      alamatLama: 'Jl. Mawar No. 33, Medan',
      alamatBaru: 'Jl. Anggrek No. 44, Palembang',
      tanggalMutasi: '30-10-2025',
      jenisMutasi: 'Pindah Kota',
      alasan: 'Bisnis',
    ),
  ];

  List<MutasiData> _filteredData = [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Semua';

  @override
  void initState() {
    super.initState();
    _filteredData = _allData;
  }

  void _applyFilter(String jenisMutasi) {
    setState(() {
      _selectedFilter = jenisMutasi;
      
      // Apply filter jenis mutasi terlebih dahulu
      List<MutasiData> jenisFilteredData;
      if (jenisMutasi == 'Semua') {
        jenisFilteredData = _allData;
      } else {
        jenisFilteredData = _allData.where((data) => data.jenisMutasi == jenisMutasi).toList();
      }
      
      // Kemudian apply search filter jika ada
      if (_searchController.text.isNotEmpty) {
        _filteredData = jenisFilteredData
            .where((data) =>
                data.keluarga.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                data.jenisMutasi.toLowerCase().contains(_searchController.text.toLowerCase()))
            .toList();
      } else {
        _filteredData = jenisFilteredData;
      }
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      // Apply search filter terlebih dahulu
      List<MutasiData> searchFilteredData;
      if (value.isEmpty) {
        searchFilteredData = _allData;
      } else {
        searchFilteredData = _allData
            .where((data) =>
                data.keluarga.toLowerCase().contains(value.toLowerCase()) ||
                data.jenisMutasi.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
      
      // Kemudian apply jenis mutasi filter jika bukan 'Semua'
      if (_selectedFilter != 'Semua') {
        _filteredData = searchFilteredData.where((data) => data.jenisMutasi == _selectedFilter).toList();
      } else {
        _filteredData = searchFilteredData;
      }
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => FilterMutasiKeluargaDialog(
        initialJenisMutasi: _selectedFilter,
        onApplyFilter: _applyFilter,
      ),
    );
  }

  void _showDetailModal(BuildContext context, MutasiData item) {
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
                      'Detail Mutasi Keluarga',
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

                // Keluarga
                _detailRow('Keluarga', item.keluarga),
                const SizedBox(height: 12),

                // Alamat Lama
                _detailRow('Alamat Lama', item.alamatLama),
                const SizedBox(height: 12),

                // Alamat Baru
                _detailRow('Alamat Baru', item.alamatBaru),
                const SizedBox(height: 12),

                // Tanggal Mutasi
                _detailRow('Tanggal Mutasi', item.tanggalMutasi),
                const SizedBox(height: 12),

                // Jenis Mutasi dengan label warna
                Row(
                  children: [
                    const SizedBox(
                      width: 120,
                      child: Text(
                        'Jenis Mutasi:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getJenisMutasiColor(item.jenisMutasi),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item.jenisMutasi,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Alasan
                _detailRow('Alasan', item.alasan),
                const SizedBox(height: 20),

                // Tombol Tutup (sebelah kiri)
                Align(
                  alignment: Alignment.centerRight,
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

  Color _getJenisMutasiColor(String jenisMutasi) {
    switch (jenisMutasi.toLowerCase()) {
      case 'pindah domisili':
        return Colors.blue;
      case 'pindah kota':
        return Colors.green;
      case 'pindah provinsi':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget _buildJenisMutasiBadge(String jenisMutasi) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getJenisMutasiColor(jenisMutasi),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        jenisMutasi,
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
          'Data Mutasi Keluarga',
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
                      hintText: 'Cari berdasarkan keluarga atau jenis mutasi...',
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

  Widget _buildDataCard(MutasiData item) {
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
                        item.keluarga,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Jenis Mutasi: ${item.jenisMutasi}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
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
      ),
    );
  }
}