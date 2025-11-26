import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jawara/presentation/widgets/sidebar/sidebar.dart';

// Model Data Rumah sesuai gambar
class RumahData {
  final String no;
  final String alamat;
  final String status;
  final String aksi;

  const RumahData({
    required this.no,
    required this.alamat,
    required this.status,
    required this.aksi,
  });
}

@RoutePage()
class RumahDaftarPage extends StatefulWidget {
  const RumahDaftarPage({super.key});

  @override
  State<RumahDaftarPage> createState() => _RumahDaftarPageState();
}

class _RumahDaftarPageState extends State<RumahDaftarPage> {
  final List<RumahData> _allRumah = [
    RumahData(
      no: '1',
      alamat: '55555',
      status: 'Ditempati',
      aksi: '...',
    ),
    RumahData(
      no: '2',
      alamat: 'jalan achat',
      status: 'Ditempati',
      aksi: '...',
    ),
    RumahData(
      no: '3',
      alamat: '1',
      status: 'Ditempati',
      aksi: '...',
    ),
    RumahData(
      no: '4',
      alamat: 'Tes',
      status: 'Ditempati',
      aksi: '...',
    ),
    RumahData(
      no: '5',
      alamat: 'Jl. Herhabu',
      status: 'Tersedia',
      aksi: '...',
    ),
    RumahData(
      no: '6',
      alamat: 'Malang',
      status: 'Ditempati',
      aksi: '...',
    ),
    RumahData(
      no: '7',
      alamat: 'Griyasharia L203',
      status: 'Ditempati',
      aksi: '...',
    ),
    RumahData(
      no: '8',
      alamat: 'veriver',
      status: 'Tersedia',
      aksi: '...',
    ),
    RumahData(
      no: '9',
      alamat: 'Jl. Banu bangun',
      status: 'Ditempati',
      aksi: '...',
    ),
    RumahData(
      no: '10',
      alamat: 'fasda',
      status: 'Tersedia',
      aksi: '...',
    ),
  ];

  List<RumahData> _filteredRumah = [];
  List<RumahData> _currentPageData = [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Semua';
  
  // Pagination variables
  int _currentPage = 1;
  final int _itemsPerPage = 5;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _filteredRumah = List.from(_allRumah);
    _updatePagination();
  }

  void _updatePagination() {
    try {
      setState(() {
        final filteredList = _filteredRumah;
        
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

  void _applyFilter(String filter) {
    try {
      setState(() {
        _selectedFilter = filter;
        _currentPage = 1;

        final allData = _allRumah;
        
        List<RumahData> filteredData;
        if (filter == 'Semua') {
          filteredData = List.from(allData);
        } else {
          filteredData = allData
              .where((r) => r.status == filter)
              .toList();
        }

        final searchText = _searchController.text;
        if (searchText.isNotEmpty) {
          _filteredRumah = filteredData
              .where((r) =>
                  (r.alamat).toLowerCase().contains(searchText.toLowerCase()))
              .toList();
        } else {
          _filteredRumah = List.from(filteredData);
        }
        
        _updatePagination();
      });
    } catch (e) {
      print('Error applying filter: $e');
      setState(() {
        _filteredRumah = List.from(_allRumah);
        _updatePagination();
      });
    }
  }

  void _onSearchChanged(String value) {
    try {
      setState(() {
        _currentPage = 1;
        
        final allData = _allRumah;
        
        List<RumahData> searchFilteredData;
        if (value.isEmpty) {
          searchFilteredData = List.from(allData);
        } else {
          searchFilteredData = allData
              .where((r) =>
                  (r.alamat).toLowerCase().contains(value.toLowerCase()))
              .toList();
        }

        if (_selectedFilter != 'Semua') {
          _filteredRumah = searchFilteredData
              .where((r) => r.status == _selectedFilter)
              .toList();
        } else {
          _filteredRumah = List.from(searchFilteredData);
        }
        
        _updatePagination();
      });
    } catch (e) {
      print('Error in search: $e');
      setState(() {
        _filteredRumah = List.from(_allRumah);
        _updatePagination();
      });
    }
  }

  void _showFilterDialog() {
    final uniqueStatus = _allRumah.map((r) => r.status).toSet().toList();
    uniqueStatus.insert(0, 'Semua');

    showModalBottomSheet(
      context: context,
      builder: (context) => _FilterBottomSheet(
        uniqueStatus: uniqueStatus,
        selectedFilter: _selectedFilter,
        onFilterApplied: _applyFilter,
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedFilter = 'Semua';
      _searchController.clear();
      _filteredRumah = List.from(_allRumah);
      _updatePagination();
    });
  }

  // FUNGSI DELETE CONFIRMATION
  void _showDeleteConfirmation(RumahData item) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus data rumah "${item.alamat}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteRumah(item);
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

  // FUNGSI DELETE RUMAH
  void _deleteRumah(RumahData item) {
    setState(() {
      _allRumah.removeWhere((r) => r.no == item.no);
      _applyFilter(_selectedFilter);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data rumah "${item.alamat}" berhasil dihapus'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // FUNGSI DETAIL MODAL
  void _showDetailModal(RumahData item) {
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
                      'Detail Rumah',
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
                _buildDetailRow('No', item.no),
                const SizedBox(height: 12),
                _buildDetailRow('Alamat', item.alamat),
                const SizedBox(height: 12),
                _buildDetailRow('Status', item.status),
                const SizedBox(height: 20),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: const Text('Tutup'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        _showEditModal(item);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                      ),
                      child: const Text('Edit', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // FUNGSI EDIT MODAL
  void _showEditModal(RumahData item) {
    // Controllers untuk form edit
    final alamatController = TextEditingController(text: item.alamat);
    String? selectedStatus = item.status;

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
                      'Edit Data Rumah',
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

                // Form Edit
                _buildEditField('Alamat', alamatController),
                const SizedBox(height: 12),

                // Dropdown Status
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      items: ['Ditempati', 'Tersedia']
                          .map((status) => DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedStatus = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: const Text('Batal'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        _updateRumah(
                          item,
                          alamatController.text,
                          selectedStatus!,
                        );
                        Navigator.of(dialogContext).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                      ),
                      child: const Text('Simpan', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // FUNGSI UPDATE RUMAH
  void _updateRumah(
    RumahData item,
    String alamat,
    String status,
  ) {
    setState(() {
      final index = _allRumah.indexWhere((r) => r.no == item.no);
      if (index != -1) {
        _allRumah[index] = RumahData(
          no: item.no,
          alamat: alamat,
          status: status,
          aksi: item.aksi,
        );
        _applyFilter(_selectedFilter);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data rumah "$alamat" berhasil diupdate'),
        backgroundColor: Colors.green,
      ),
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

  // HELPER FUNCTION UNTUK EDIT FIELD
  Widget _buildEditField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: const InputDecoration(
                      hintText: 'Cari berdasarkan alamat...',
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
                  '${_filteredRumah.length} data ditemukan',
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

          // List Data Rumah
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
                      return _buildRumahCard(item);
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

  Widget _buildRumahCard(RumahData item) {
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
                    item.alamat,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No: ${item.no}',
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
                    item.status,
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
                        _showEditModal(item);
                        break;
                      case 'delete':
                        _showDeleteConfirmation(item);
                        break;
                      case 'detail':
                        _showDetailModal(item);
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
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Ditempati':
        return Colors.orange;
      case 'Tersedia':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

// Filter Bottom Sheet
class _FilterBottomSheet extends StatefulWidget {
  final List<String> uniqueStatus;
  final String selectedFilter;
  final Function(String) onFilterApplied;

  const _FilterBottomSheet({
    required this.uniqueStatus,
    required this.selectedFilter,
    required this.onFilterApplied,
  });

  @override
  State<_FilterBottomSheet> createState() => __FilterBottomSheetState();
}

class __FilterBottomSheetState extends State<_FilterBottomSheet> {
  late String _tempSelectedFilter;

  @override
  void initState() {
    super.initState();
    _tempSelectedFilter = widget.selectedFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Data Rumah',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pilih Status',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  ...widget.uniqueStatus.map((status) => 
                    _buildFilterOption(status, _tempSelectedFilter == status)
                  ).toList(),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                    child: const Text('BATAL'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onFilterApplied(_tempSelectedFilter);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('TERAPKAN', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption(String status, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
          color: isSelected ? const Color(0xFF6C63FF) : Colors.grey,
        ),
        title: Text(status),
        onTap: () => setState(() => _tempSelectedFilter = status),
      ),
    );
  }
}