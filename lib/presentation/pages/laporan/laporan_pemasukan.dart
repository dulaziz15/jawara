import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class LaporanPemasukanPage extends StatefulWidget {
  const LaporanPemasukanPage({super.key});

  @override
  State<LaporanPemasukanPage> createState() => _LaporanPemasukanPageState();
}

class _LaporanPemasukanPageState extends State<LaporanPemasukanPage> {
  final TextEditingController _searchController = TextEditingController();
  // Placeholder for pemasukan data - assuming similar structure to pengeluaran
  final List<Map<String, dynamic>> _allData = [
    {
      'id': 1,
      'nama': 'Pemasukan dari Iuran Warga',
      'jenis': 'Iuran',
      'tanggal': DateTime(2025, 1, 15),
      'jumlah': 5000000.0,
    },
    {
      'id': 2,
      'nama': 'Donasi Sosial',
      'jenis': 'Donasi',
      'tanggal': DateTime(2025, 2, 10),
      'jumlah': 2500000.0,
    },
    {
      'id': 3,
      'nama': 'Pendapatan Event',
      'jenis': 'Event',
      'tanggal': DateTime(2025, 3, 5),
      'jumlah': 7500000.0,
    },
  ];

  List<Map<String, dynamic>> _filteredData = [];

  @override
  void initState() {
    super.initState();
    _filteredData = _allData;
  }

  void _onSearchChanged(String value) {
    setState(() {
      if (value.isEmpty) {
        _filteredData = _allData;
      } else {
        _filteredData = _allData
            .where((item) =>
                item['nama'].toString().toLowerCase().contains(value.toLowerCase()) ||
                item['jenis'].toString().toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    });
  }

  void _showFilterDialog() {
    // Placeholder for filter dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Pemasukan'),
        content: const Text('Filter functionality to be implemented'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  // --- Helper format bulan ---
  String _getBulan(int bulan) {
    const namaBulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return namaBulan[bulan - 1];
  }

  Widget _buildDataCard(Map<String, dynamic> item) {
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
                        item['nama'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Jenis: ${item['jenis']}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rp ${item['jumlah'].toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.visibility,
                    color: Color(0xFF4F6DF5),
                  ),
                  onPressed: () {
                    // Navigate to detail page if exists
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${item['tanggal'].day.toString().padLeft(2, '0')} '
              '${_getBulan(item['tanggal'].month)} '
              '${item['tanggal'].year}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
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
          'Laporan Pemasukan',
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
                      hintText: 'Cari berdasarkan nama atau jenis...',
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
}
