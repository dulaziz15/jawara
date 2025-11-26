import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

// Model Data Warga sesuai gambar
class WargaData {
  final String no;
  final String name;
  final String nik;
  final String keluarga;
  final String jenisKelamin;
  final String statusDomisili;
  final String statusHidup;
  final String aksi;

  const WargaData({
    required this.no,
    required this.name,
    required this.nik,
    required this.keluarga,
    required this.jenisKelamin,
    required this.statusDomisili,
    required this.statusHidup,
    required this.aksi,
  });
}

@RoutePage()
class DaftarWargaPage extends StatefulWidget {
  const DaftarWargaPage({super.key});

  @override
  State<DaftarWargaPage> createState() => _DaftarWargaPageState();
}

class _DaftarWargaPageState extends State<DaftarWargaPage> {
  final List<WargaData> _allWarga = [
    WargaData(
      no: '1',
      name: '99999',
      nik: '12345678901234567',
      keluarga: 'Kekanga Pana Namet',
      jenisKelamin: 'Perempuan',
      statusDomisili: 'Aktif',
      statusHidup: 'Hidup',
      aksi: '--',
    ),
    WargaData(
      no: '2',
      name: 'Varsity Nadiba Birma',
      nik: '1371110101000005',
      keluarga: 'Kekanga Varsity Nadiba Birma',
      jenisKelamin: 'Laki-laki',
      statusDomisili: 'Aktif',
      statusHidup: 'Hidup',
      aksi: '--',
    ),
    WargaData(
      no: '3',
      name: 'Tea',
      nik: '22222222222222222',
      keluarga: 'Kekanga Tea',
      jenisKelamin: 'Laki-laki',
      statusDomisili: 'Aktif',
      statusHidup: 'Meninggal',
      aksi: '--',
    ),
    WargaData(
      no: '4',
      name: 'Farhan',
      nik: '44567890844654356',
      keluarga: 'Kekanga Farhan',
      jenisKelamin: 'Laki-laki',
      statusDomisili: 'Aktif',
      statusHidup: 'Hidup',
      aksi: '--',
    ),
    WargaData(
      no: '5',
      name: 'Buncha Putra Rahmedya',
      nik: '3505111510040002',
      keluarga: 'Kekanga Buncha Putra Rahmedya',
      jenisKelamin: 'Laki-laki',
      statusDomisili: 'Aktif',
      statusHidup: 'Hidup',
      aksi: '--',
    ),
    WargaData(
      no: '6',
      name: 'Anti Mota',
      nik: '1234567890087054',
      keluarga: 'Kekanga Anti Mota',
      jenisKelamin: 'Laki-laki',
      statusDomisili: 'Aktif',
      statusHidup: 'Hidup',
      aksi: '--',
    ),
    WargaData(
      no: '7',
      name: 'varsity nadiba irima',
      nik: '1234123412341234',
      keluarga: 'Kekanga varsity nadiba irima',
      jenisKelamin: 'Laki-laki',
      statusDomisili: 'Aktif',
      statusHidup: 'Hidup',
      aksi: '--',
    ),
    WargaData(
      no: '8',
      name: 'Isiluku',
      nik: '1234567890123456',
      keluarga: 'Kekanga Ijat',
      jenisKelamin: 'Perempuan',
      statusDomisili: 'Non-Aktif',
      statusHidup: 'Hidup',
      aksi: '--',
    ),
    WargaData(
      no: '9',
      name: 'Ijat',
      nik: '2005202502050005',
      keluarga: 'Kekanga Ijat',
      jenisKelamin: 'Laki-laki',
      statusDomisili: 'Non-Aktif',
      statusHidup: 'Hidup',
      aksi: '--',
    ),
    WargaData(
      no: '10',
      name: 'Bauditi Firdika Nasrili',
      nik: '3201122501050002',
      keluarga: 'Kekanga Bauditi Firdika Nasrili',
      jenisKelamin: 'Laki-laki',
      statusDomisili: 'Aktif',
      statusHidup: 'Hidup',
      aksi: '--',
    ),
  ];

  List<WargaData> _filteredWarga = [];
  List<WargaData> _currentPageData = [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Semua';
  
  // Pagination variables
  int _currentPage = 1;
  final int _itemsPerPage = 5;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _filteredWarga = List.from(_allWarga);
    _updatePagination();
  }

  void _updatePagination() {
    try {
      setState(() {
        // Pastikan _filteredWarga tidak null
        final filteredList = _filteredWarga;
        
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

        // Pastikan _allWarga tidak null
        final allData = _allWarga;
        
        List<WargaData> filteredData;
        if (filter == 'Semua') {
          filteredData = List.from(allData);
        } else {
          filteredData = allData
              .where((w) => w.statusDomisili == filter || w.statusHidup == filter)
              .toList();
        }

        // Handle search text dengan null safety
        final searchText = _searchController.text;
        if (searchText.isNotEmpty) {
          _filteredWarga = filteredData
              .where((w) =>
                  (w.name).toLowerCase().contains(searchText.toLowerCase()) ||
                  (w.nik).contains(searchText) ||
                  (w.keluarga).toLowerCase().contains(searchText.toLowerCase()))
              .toList();
        } else {
          _filteredWarga = List.from(filteredData);
        }
        
        _updatePagination();
      });
    } catch (e) {
      print('Error applying filter: $e');
      setState(() {
        _filteredWarga = List.from(_allWarga);
        _updatePagination();
      });
    }
  }

  void _onSearchChanged(String value) {
    try {
      setState(() {
        _currentPage = 1;
        
        // Pastikan _allWarga tidak null
        final allData = _allWarga;
        
        List<WargaData> searchFilteredData;
        if (value.isEmpty) {
          searchFilteredData = List.from(allData);
        } else {
          searchFilteredData = allData
              .where((w) =>
                  (w.name).toLowerCase().contains(value.toLowerCase()) ||
                  (w.nik).contains(value) ||
                  (w.keluarga).toLowerCase().contains(value.toLowerCase()))
              .toList();
        }

        if (_selectedFilter != 'Semua') {
          _filteredWarga = searchFilteredData
              .where((w) => w.statusDomisili == _selectedFilter || w.statusHidup == _selectedFilter)
              .toList();
        } else {
          _filteredWarga = List.from(searchFilteredData);
        }
        
        _updatePagination();
      });
    } catch (e) {
      print('Error in search: $e');
      setState(() {
        _filteredWarga = List.from(_allWarga);
        _updatePagination();
      });
    }
  }

  void _showFilterDialog() {
    final uniqueStatus = _allWarga.map((w) => w.statusDomisili).toSet().toList();
    uniqueStatus.addAll(_allWarga.map((w) => w.statusHidup).toSet());
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
      _filteredWarga = List.from(_allWarga);
      _updatePagination();
    });
  }

  // FUNGSI DELETE CONFIRMATION
  void _showDeleteConfirmation(WargaData item) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus data warga "${item.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteWarga(item);
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

  // FUNGSI DELETE WARGA
  void _deleteWarga(WargaData item) {
    setState(() {
      _allWarga.removeWhere((w) => w.nik == item.nik);
      _applyFilter(_selectedFilter); // Re-apply filter to update the list
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data warga "${item.name}" berhasil dihapus'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // FUNGSI DETAIL MODAL
  void _showDetailModal(WargaData item) {
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
                      'Detail Warga',
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
                _buildDetailRow('Nama', item.name),
                const SizedBox(height: 12),
                _buildDetailRow('NIK', item.nik),
                const SizedBox(height: 12),
                _buildDetailRow('Keluarga', item.keluarga),
                const SizedBox(height: 12),
                _buildDetailRow('Jenis Kelamin', item.jenisKelamin),
                const SizedBox(height: 12),
                _buildDetailRow('Status Domisili', item.statusDomisili),
                const SizedBox(height: 12),
                _buildDetailRow('Status Hidup', item.statusHidup),
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
            width: 100,
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
                      hintText: 'Cari berdasarkan Nama, NIK, atau Keluarga...',
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
                  '${_filteredWarga.length} data ditemukan',
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

          // List Data Warga
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
                      return _buildWargaCard(item);
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

  Widget _buildWargaCard(WargaData item) {
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
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NIK: ${item.nik}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Jenis Kelamin: ${item.jenisKelamin}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusDomisiliColor(item.statusDomisili),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.statusDomisili,
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
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (_) => EditWargaPage(item: item),
                        //   ),
                        // );
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

  Color _getStatusDomisiliColor(String status) {
    switch (status) {
      case 'Aktif':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusHidupColor(String status) {
    switch (status) {
      case 'Hidup':
        return Colors.green;
      case 'Wafat':
        return Colors.grey;
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
                  'Filter Data',
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