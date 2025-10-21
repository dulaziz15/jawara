import 'package:flutter/material.dart';
import 'model_aspirasi.dart';
import 'filter.dart';
import 'edit_aspirasi.dart';
import 'delete_aspirasi.dart';
import 'detail_aspirasi.dart';

class AspirasiPage extends StatefulWidget {
  const AspirasiPage({super.key});

  @override
  State<AspirasiPage> createState() => _AspirasiPageState();
}

class _AspirasiPageState extends State<AspirasiPage> {
  final List<AspirationData> _allAspirasi = [
    AspirationData(
        judul: 'Lampu jalan di persimpangan padam', 
        deskripsi: 'Pada hari minggu malam saya cek lampu nya berkedip kemudian keesokan hari nya lampu sudah mati total', 
        status: 'Pending', 
        pengirim: 'Tono', 
        tanggal: '10-10-2025'),
    AspirationData(
        judul: 'Tempat sampah kurang', 
        deskripsi: 'aku hanya ingin pergi ke wisata kota yang ada di malang', 
        status: 'Diproses', 
        pengirim: 'Budi Doremi', 
        tanggal: '12-10-2025'),
    AspirationData(
        judul: 'Pipa bocor', 
        deskripsi: 'pipa bocor karena tidak sengaja saat penggalian tanah', 
        status: 'Diproses', 
        pengirim: 'Ehsan', 
        tanggal: '13-10-2025'),
    AspirationData(
        judul: 'Jalan rusak', 
        deskripsi: 'Jalan rusak akibat ada truk tronton lewat dini hari', 
        status: 'Selesai', 
        pengirim: 'Darmini', 
        tanggal: '1-09-2025'),
  ];

  List<AspirationData> _filteredAspirasi = [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Semua';

  @override
  void initState() {
    super.initState();
    _filteredAspirasi = _allAspirasi;
  }

  void _applyFilter(String status) {
    setState(() {
      _selectedFilter = status;
      
      // Apply filter status terlebih dahulu
      List<AspirationData> statusFilteredData;
      if (status == 'Semua') {
        statusFilteredData = _allAspirasi;
      } else {
        statusFilteredData = _allAspirasi.where((a) => a.status == status).toList();
      }
      
      // Kemudian apply search filter jika ada
      if (_searchController.text.isNotEmpty) {
        _filteredAspirasi = statusFilteredData
            .where((a) =>
                a.judul.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                a.pengirim.toLowerCase().contains(_searchController.text.toLowerCase()))
            .toList();
      } else {
        _filteredAspirasi = statusFilteredData;
      }
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      // Apply search filter terlebih dahulu
      List<AspirationData> searchFilteredData;
      if (value.isEmpty) {
        searchFilteredData = _allAspirasi;
      } else {
        searchFilteredData = _allAspirasi
            .where((a) =>
                a.judul.toLowerCase().contains(value.toLowerCase()) ||
                a.pengirim.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
      
      // Kemudian apply status filter jika bukan 'Semua'
      if (_selectedFilter != 'Semua') {
        _filteredAspirasi = searchFilteredData.where((a) => a.status == _selectedFilter).toList();
      } else {
        _filteredAspirasi = searchFilteredData;
      }
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => FilterPesanWargaDialog(
        initialStatus: _selectedFilter,
        onApplyFilter: _applyFilter,
      ),
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
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: const InputDecoration(
                      hintText: 'Cari berdasarkan judul atau pengirim...',
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
              '${_filteredAspirasi.length} data ditemukan',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),

          // List Aspirasi
          Expanded(
            child: _filteredAspirasi.isEmpty
                ? Center(
                    child: Text(
                      'Data tidak ditemukan',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredAspirasi.length,
                    itemBuilder: (context, index) {
                      final item = _filteredAspirasi[index];
                      return _buildAspirasiCard(item);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFilterDialog,
        backgroundColor: const Color(0xFF6C63FF),
        child: const Icon(Icons.filter_list, color: Colors.white),
      ),
    );
  }

  Widget _buildAspirasiCard(AspirationData item) {
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
                  child: Text(
                    item.judul,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditAspirasiPage(item: item),
                          ),
                        );
                        break;
                      case 'delete':
                        showDeleteConfirmation(context, item);
                        break;
                      case 'detail':
                        showDetailModal(context, item);
                        break;
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'detail', child: Text('Detail')),
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Hapus')),
                  ],
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Dikirim oleh: ${item.pengirim}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tanggal: ${item.tanggal}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(item.status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'diproses':
        return Colors.blue;
      case 'selesai':
        return Colors.green;
      case 'ditolak':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}