import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jawara/core/models/aspirasi_models.dart';
import 'package:jawara/core/repositories/aspirasi_repository.dart';
import 'package:jawara/core/routes/app_router.dart';

@RoutePage()
class AspirasiPage extends StatefulWidget {
  const AspirasiPage({super.key});

  @override
  State<AspirasiPage> createState() => _AspirasiPageState();
}

class _AspirasiPageState extends State<AspirasiPage> {
  // 1. Inisialisasi Repository
  final AspirasiRepository _repository = AspirasiRepository();

  // 2. Controller & State UI
  final TextEditingController _searchController = TextEditingController();
  String _searchKeyword = '';
  String _selectedFilter = 'Semua';

  // 3. Pagination State
  int _currentPage = 1;
  final int _itemsPerPage = 5;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Fungsi mengubah filter (dipanggil dari Dialog)
  void _applyFilter(String status) {
    setState(() {
      _selectedFilter = status;
      _currentPage = 1; // Reset ke halaman 1 saat filter berubah
    });
  }

  // Fungsi Dialog Filter (Mockup, sesuaikan dengan widget FilterPesanWargaDialog Anda)
  void _showFilterDialog() {
    // Contoh implementasi sederhana jika file filter.dart belum siap
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Pilih Status'),
        children: ['Semua', 'Pending', 'Diproses', 'Selesai', 'Ditolak']
            .map(
              (status) => SimpleDialogOption(
                onPressed: () {
                  _applyFilter(status);
                  Navigator.pop(context);
                },
                child: Text(status),
              ),
            )
            .toList(),
      ),
    );
    // Jika menggunakan widget custom Anda:
    // showDialog(
    //   context: context,
    //   builder: (context) => FilterPesanWargaDialog(
    //     initialStatus: _selectedFilter,
    //     onApplyFilter: _applyFilter,
    //   ),
    // );
  }

  // Fungsi Hapus Data ke Firebase
  void _deleteAspirasi(AspirasiModels item) async {
    try {
      await _repository.deleteAspirasi(item.docId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Aspirasi "${item.judul}" berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDeleteConfirmation(BuildContext context, AspirasiModels item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Hapus aspirasi "${item.judul}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _deleteAspirasi(item);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDetailModal(BuildContext context, AspirasiModels item) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Detail Aspirasi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Judul', item.judul),
              _buildDetailRow('Pengirim', item.pengirim),
              _buildDetailRow('Tanggal', item.tanggal),
              _buildDetailRow('Status', item.status),
              const SizedBox(height: 12),
              const Text(
                'Deskripsi:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(item.deskripsi),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tutup'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<List<AspirasiModels>>(
        stream: _repository.getAspirasi(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // 1. Ambil Data Mentah
          final allData = snapshot.data ?? [];

          // 2. Lakukan Filtering & Searching (Client Side)
          final filteredData = allData.where((item) {
            // Filter Status
            if (_selectedFilter != 'Semua' && item.status != _selectedFilter) {
              return false;
            }
            // Filter Search (Judul atau Pengirim)
            if (_searchKeyword.isNotEmpty) {
              final keyword = _searchKeyword.toLowerCase();
              return item.judul.toLowerCase().contains(keyword) ||
                  item.pengirim.toLowerCase().contains(keyword);
            }
            return true;
          }).toList();

          // 3. Lakukan Pagination Logic
          final int totalItems = filteredData.length;
          final int totalPages = (totalItems / _itemsPerPage).ceil();

          // Safety check jika current page melebihi total pages setelah delete/filter
          if (_currentPage > totalPages && totalPages > 0) {
            _currentPage = totalPages;
          } else if (totalPages == 0) {
            _currentPage = 1;
          }

          final int startIndex = (_currentPage - 1) * _itemsPerPage;
          final int endIndex = (startIndex + _itemsPerPage) > totalItems
              ? totalItems
              : (startIndex + _itemsPerPage);

          final List<AspirasiModels> currentDisplayData = filteredData.isEmpty
              ? []
              : filteredData.sublist(startIndex, endIndex);

          return Column(
            children: [
              // --- SEARCH BAR ---
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
                        onChanged: (value) {
                          setState(() {
                            _searchKeyword = value;
                            _currentPage = 1; // Reset pagination saat search
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Cari judul atau pengirim...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // --- INFO JUMLAH DATA ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$totalItems data ditemukan',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    if (totalPages > 1)
                      Text(
                        'Halaman $_currentPage dari $totalPages',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
              ),

              // --- LIST VIEW ---
              Expanded(
                child: currentDisplayData.isEmpty
                    ? Center(
                        child: Text(
                          'Data tidak ditemukan',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: currentDisplayData.length,
                        itemBuilder: (context, index) {
                          return _buildAspirasiCard(currentDisplayData[index]);
                        },
                      ),
              ),

              // --- PAGINATION CONTROLS ---
              if (totalPages > 1) _buildPaginationControls(totalPages),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFilterDialog,
        backgroundColor: const Color(0xFF6C63FF),
        child: const Icon(Icons.filter_list, color: Colors.white),
      ),
    );
  }

  // Widget Control Pagination
  Widget _buildPaginationControls(int totalPages) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _currentPage > 1
                ? () => setState(() => _currentPage--)
                : null,
            icon: const Icon(Icons.chevron_left),
            color: _currentPage > 1 ? const Color(0xFF6C63FF) : Colors.grey,
          ),
          // Simple Page Number Display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$_currentPage',
              style: const TextStyle(
                color: Color(0xFF6C63FF),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: _currentPage < totalPages
                ? () => setState(() => _currentPage++)
                : null,
            icon: const Icon(Icons.chevron_right),
            color: _currentPage < totalPages
                ? const Color(0xFF6C63FF)
                : Colors.grey,
          ),
        ],
      ),
    );
  }

  // Widget Card Aspirasi
  Widget _buildAspirasiCard(AspirasiModels item) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.judul,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dikirim oleh: ${item.pengirim}',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  Text(
                    'Tanggal: ${item.tanggal}',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
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
            ),
            // Popup Menu Action
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              onSelected: (value) {
                if (value == 'delete') _showDeleteConfirmation(context, item);
                if (value == 'detail') _showDetailModal(context, item);
                if (value == 'edit') {
                  // Arahkan ke halaman edit_aspirasi
                    AutoRouter.of(context).push(AspirasiEditRoute(aspirasiId: item.docId));
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'detail', child: Text('Detail')),
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Hapus', style: TextStyle(color: Colors.red)),
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
