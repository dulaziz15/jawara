import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../core/models/aspirasi_models.dart';
import 'filter.dart';
import 'edit_aspirasi.dart';


@RoutePage()
class AspirasiPage extends StatefulWidget {
  const AspirasiPage({super.key});

  @override
  State<AspirasiPage> createState() => _AspirasiPageState();
}

class _AspirasiPageState extends State<AspirasiPage> {
  

  List<AspirasiModels> _filteredAspirasi = [];
  List<AspirasiModels> _currentPageData = [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Semua';
  
  // Pagination variables
  int _currentPage = 1;
  final int _itemsPerPage = 5;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _filteredAspirasi = List.from(allAspirasi);
    _updatePagination();
  }

  void _updatePagination() {
    try {
      setState(() {
        // Pastikan _filteredAspirasi tidak null
        final filteredList = _filteredAspirasi;
        
        _totalPages = (filteredList.length / _itemsPerPage).ceil();
        if (_totalPages == 0) _totalPages = 1;
        
        if (_currentPage > _totalPages) {
          _currentPage = _totalPages;
        }
        
        final startIndex = (_currentPage - 1) * _itemsPerPage;
        final endIndex = startIndex + _itemsPerPage;
        
        _currentPageData = filteredList.sublist(
          startIndex,
          endIndex > filteredList.length ? filteredList.length : endIndex,
        );
      });
    } catch (e) {
      print('Error in pagination: $e');
      setState(() {
        _currentPageData = [];
        _totalPages = 1;
        _currentPage = 1;
      });
    }
  }

  void _goToPage(int page) {
    if (page >= 1 && page <= _totalPages) {
      setState(() {
        _currentPage = page;
        _updatePagination();
      });
    }
  }

  void _nextPage() {
    if (_currentPage < _totalPages) {
      _goToPage(_currentPage + 1);
    }
  }

  void _previousPage() {
    if (_currentPage > 1) {
      _goToPage(_currentPage - 1);
    }
  }

  void _applyFilter(String status) {
    try {
      setState(() {
        _selectedFilter = status;
        _currentPage = 1;

        // Pastikan _allAspirasi tidak null
        final allData = allAspirasi;
        
        List<AspirasiModels> statusFilteredData;
        if (status == 'Semua') {
          statusFilteredData = List.from(allData);
        } else {
          statusFilteredData = allData
              .where((a) => a.status == status)
              .toList();
        }

        // Handle search text dengan null safety
        final searchText = _searchController.text;
        if (searchText.isNotEmpty) {
          _filteredAspirasi = statusFilteredData
              .where((a) =>
                  (a.judul ?? '').toLowerCase().contains(searchText.toLowerCase()) ||
                  (a.pengirim ?? '').toLowerCase().contains(searchText.toLowerCase()))
              .toList();
        } else {
          _filteredAspirasi = List.from(statusFilteredData);
        }
        
        _updatePagination();
      });
    } catch (e) {
      print('Error applying filter: $e');
      setState(() {
        _filteredAspirasi = List.from(allAspirasi);
        _updatePagination();
      });
    }
  }

  void _onSearchChanged(String value) {
    try {
      setState(() {
        _currentPage = 1;
        
        // Pastikan allAspirasi tidak null
        final allData = allAspirasi;
        
        List<AspirasiModels> searchFilteredData;
        if (value.isEmpty) {
          searchFilteredData = List.from(allData);
        } else {
          searchFilteredData = allData
              .where((a) =>
                  (a.judul ?? '').toLowerCase().contains(value.toLowerCase()) ||
                  (a.pengirim ?? '').toLowerCase().contains(value.toLowerCase()))
              .toList();
        }

        if (_selectedFilter != 'Semua') {
          _filteredAspirasi = searchFilteredData
              .where((a) => a.status == _selectedFilter)
              .toList();
        } else {
          _filteredAspirasi = List.from(searchFilteredData);
        }
        
        _updatePagination();
      });
    } catch (e) {
      print('Error in search: $e');
      setState(() {
        _filteredAspirasi = List.from(allAspirasi);
        _updatePagination();
      });
    }
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

  // FUNGSI DELETE CONFIRMATION
  void _showDeleteConfirmation(BuildContext context, AspirasiModels item) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus aspirasi "${item.judul}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteAspirasi(item);
                Navigator.of(dialogContext).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Hapus', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // FUNGSI DELETE ASPIRASI
  void _deleteAspirasi(AspirasiModels item) {
    setState(() {
      allAspirasi.removeWhere((a) => a.judul == item.judul);
      _applyFilter(_selectedFilter); // Re-apply filter to update the list
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Aspirasi "${item.judul}" berhasil dihapus'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // FUNGSI DETAIL MODAL
  void _showDetailModal(BuildContext context, AspirasiModels item) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Detail Aspirasi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6C63FF),
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

                // Content
                _buildDetailRow('Judul', item.judul ?? '-'),
                const SizedBox(height: 12),
                _buildDetailRow('Pengirim', item.pengirim ?? '-'),
                const SizedBox(height: 12),
                _buildDetailRow('Tanggal', item.tanggal ?? '-'),
                const SizedBox(height: 12),
                
                // Status
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 80,
                      child: Text(
                        'Status:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(item.status),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item.status ?? 'Unknown',
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

                // Deskripsi
                const Text(
                  'Deskripsi:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  item.deskripsi ?? '-',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  // HELPER FUNCTION UNTUK DETAIL ROW
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

          // Jumlah data ditemukan dan info pagination
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_filteredAspirasi.length} data ditemukan',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                if (_totalPages > 1)
                  Text(
                    'Halaman $_currentPage dari $_totalPages',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
              ],
            ),
          ),

          // List Aspirasi
          Expanded(
            child: _currentPageData.isEmpty
                ? Center(
                    child: Text(
                      'Data tidak ditemukan',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _currentPageData.length,
                    itemBuilder: (context, index) {
                      final item = _currentPageData[index];
                      return _buildAspirasiCard(item);
                    },
                  ),
          ),

          // Pagination Controls
          if (_totalPages > 1) _buildPaginationControls(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFilterDialog,
        backgroundColor: const Color(0xFF6C63FF),
        child: const Icon(Icons.filter_list, color: Colors.white),
      ),
    );
  }

  Widget _buildPaginationControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous Button
          IconButton(
            onPressed: _currentPage > 1 ? _previousPage : null,
            icon: const Icon(Icons.chevron_left),
            color: _currentPage > 1 ? const Color(0xFF6C63FF) : Colors.grey,
          ),

          // Page Numbers
          ...List.generate(_totalPages, (index) {
            final pageNumber = index + 1;
            final isCurrentPage = pageNumber == _currentPage;
            
            // Show limited page numbers for better UX
            if (_totalPages <= 7 || 
                pageNumber == 1 || 
                pageNumber == _totalPages ||
                (pageNumber >= _currentPage - 1 && pageNumber <= _currentPage + 1)) {
              
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: InkWell(
                  onTap: () => _goToPage(pageNumber),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isCurrentPage ? const Color(0xFF6C63FF) : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isCurrentPage ? const Color(0xFF6C63FF) : Colors.grey.shade300,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$pageNumber',
                        style: TextStyle(
                          color: isCurrentPage ? Colors.white : Colors.grey.shade700,
                          fontWeight: isCurrentPage ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else if (pageNumber == _currentPage - 2 || pageNumber == _currentPage + 2) {
              // Show ellipsis for skipped pages
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text('...', style: TextStyle(color: Colors.grey)),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),

          // Next Button
          IconButton(
            onPressed: _currentPage < _totalPages ? _nextPage : null,
            icon: const Icon(Icons.chevron_right),
            color: _currentPage < _totalPages ? const Color(0xFF6C63FF) : Colors.grey,
          ),
        ],
      ),
    );
  }

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
                    item.judul ?? 'Judul tidak tersedia',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dikirim oleh: ${item.pengirim ?? 'Tidak diketahui'}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tanggal: ${item.tanggal ?? 'Tidak diketahui'}',
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
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getStatusColor(item.status),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              item.status ?? 'Unknown',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
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
                                  _showDeleteConfirmation(context, item); // FIXED
                                  break;
                                case 'detail':
                                  _showDetailModal(context, item); // FIXED
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
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    final statusValue = status?.toLowerCase() ?? '';
    switch (statusValue) {
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