import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jawara/presentation/widgets/sidebar/sidebar.dart';

// Model Data Keluarga sesuai gambar
class KeluargaData {
  final String no;
  final String namaKeluarga;
  final String kepalaKeluarga;
  final String alamatRumah;
  final String statusKepemilikan;
  final String status;
  final String aksi;

  const KeluargaData({
    required this.no,
    required this.namaKeluarga,
    required this.kepalaKeluarga,
    required this.alamatRumah,
    required this.statusKepemilikan,
    required this.status,
    required this.aksi,
  });
}

@RoutePage()
class KeluargaPage extends StatefulWidget {
  const KeluargaPage({super.key});

  @override
  State<KeluargaPage> createState() => _KeluargaPageState();
}

class _KeluargaPageState extends State<KeluargaPage> {
  final List<KeluargaData> _allKeluarga = [
    KeluargaData(
      no: '1',
      namaKeluarga: 'Keluarga Vartiöy Naidiba Rimra',
      kepalaKeluarga: 'Vartiöy Naidiba Rimra',
      alamatRumah: '1',
      statusKepemilikan: 'Pernik',
      status: 'Aktif',
      aksi: '--',
    ),
    KeluargaData(
      no: '2',
      namaKeluarga: 'Keluarga Tes',
      kepalaKeluarga: 'Tes',
      alamatRumah: 'Tes',
      statusKepemilikan: 'Penyewa',
      status: 'Aktif',
      aksi: '--',
    ),
    KeluargaData(
      no: '3',
      namaKeluarga: 'Keluarga Farhan',
      kepalaKeluarga: 'Farhan',
      alamatRumah: 'Griyaslaerta L203',
      statusKepemilikan: 'Pernik',
      status: 'Aktif',
      aksi: '--',
    ),
    KeluargaData(
      no: '4',
      namaKeluarga: 'Keluarga Rencha Putra Rahmatya',
      kepalaKeluarga: 'Rencha Putra Rahmatya',
      alamatRumah: 'Helsing',
      statusKepemilikan: 'Pernik',
      status: 'Aktif',
      aksi: '--',
    ),
    KeluargaData(
      no: '5',
      namaKeluarga: 'Keluarga Anti Micha',
      kepalaKeluarga: 'Anti Micha',
      alamatRumah: 'malsing',
      statusKepemilikan: 'Penyewa',
      status: 'Aktif',
      aksi: '--',
    ),
    KeluargaData(
      no: '6',
      namaKeluarga: 'Keluarga vartiöy naidiba rimra',
      kepalaKeluarga: 'vartiöy naidiba rimra',
      alamatRumah: '1',
      statusKepemilikan: 'Pernik',
      status: 'Aktif',
      aksi: '--',
    ),
    KeluargaData(
      no: '7',
      namaKeluarga: 'Keluarga Ijat',
      kepalaKeluarga: 'Ijat',
      alamatRumah: 'Keluar Vilfayah',
      statusKepemilikan: 'Penyewa',
      status: 'Nonaktif',
      aksi: '--',
    ),
    KeluargaData(
      no: '8',
      namaKeluarga: 'Keluarga Raudhi Firdaux Naufal',
      kepalaKeluarga: 'Raudhi Firdaux Naufal',
      alamatRumah: 'Bogor Raya Pennaf 5.2 no 11',
      statusKepemilikan: 'Pernik',
      status: 'Aktif',
      aksi: '--',
    ),
    KeluargaData(
      no: '9',
      namaKeluarga: 'Keluarga Masa Nunez',
      kepalaKeluarga: 'Masa Nunez',
      alamatRumah: 'malsing',
      statusKepemilikan: 'Pernik',
      status: 'Aktif',
      aksi: '--',
    ),
    KeluargaData(
      no: '10',
      namaKeluarga: 'Keluarga Habilite Ed Dien',
      kepalaKeluarga: 'Habilite Ed Dien',
      alamatRumah: 'Bick A49',
      statusKepemilikan: 'Pernik',
      status: 'Aktif',
      aksi: '--',
    ),
  ];

  List<KeluargaData> _filteredKeluarga = [];
  List<KeluargaData> _currentPageData = [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Semua';

  // Pagination variables
  int _currentPage = 1;
  final int _itemsPerPage = 5;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _filteredKeluarga = List.from(_allKeluarga);
    _updatePagination();
  }

  void _updatePagination() {
    try {
      setState(() {
        final filteredList = _filteredKeluarga;

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

        final allData = _allKeluarga;

        List<KeluargaData> filteredData;
        if (filter == 'Semua') {
          filteredData = List.from(allData);
        } else {
          filteredData = allData
              .where((k) => k.status == filter || k.statusKepemilikan == filter)
              .toList();
        }

        final searchText = _searchController.text;
        if (searchText.isNotEmpty) {
          _filteredKeluarga = filteredData
              .where(
                (k) =>
                    (k.namaKeluarga).toLowerCase().contains(
                      searchText.toLowerCase(),
                    ) ||
                    (k.kepalaKeluarga).toLowerCase().contains(
                      searchText.toLowerCase(),
                    ) ||
                    (k.alamatRumah).toLowerCase().contains(
                      searchText.toLowerCase(),
                    ),
              )
              .toList();
        } else {
          _filteredKeluarga = List.from(filteredData);
        }

        _updatePagination();
      });
    } catch (e) {
      print('Error applying filter: $e');
      setState(() {
        _filteredKeluarga = List.from(_allKeluarga);
        _updatePagination();
      });
    }
  }

  void _onSearchChanged(String value) {
    try {
      setState(() {
        _currentPage = 1;

        final allData = _allKeluarga;

        List<KeluargaData> searchFilteredData;
        if (value.isEmpty) {
          searchFilteredData = List.from(allData);
        } else {
          searchFilteredData = allData
              .where(
                (k) =>
                    (k.namaKeluarga).toLowerCase().contains(
                      value.toLowerCase(),
                    ) ||
                    (k.kepalaKeluarga).toLowerCase().contains(
                      value.toLowerCase(),
                    ) ||
                    (k.alamatRumah).toLowerCase().contains(value.toLowerCase()),
              )
              .toList();
        }

        if (_selectedFilter != 'Semua') {
          _filteredKeluarga = searchFilteredData
              .where(
                (k) =>
                    k.status == _selectedFilter ||
                    k.statusKepemilikan == _selectedFilter,
              )
              .toList();
        } else {
          _filteredKeluarga = List.from(searchFilteredData);
        }

        _updatePagination();
      });
    } catch (e) {
      print('Error in search: $e');
      setState(() {
        _filteredKeluarga = List.from(_allKeluarga);
        _updatePagination();
      });
    }
  }

  void _showFilterDialog() {
    final uniqueStatus = _allKeluarga.map((k) => k.status).toSet().toList();
    uniqueStatus.addAll(_allKeluarga.map((k) => k.statusKepemilikan).toSet());
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
      _filteredKeluarga = List.from(_allKeluarga);
      _updatePagination();
    });
  }

  // FUNGSI DELETE CONFIRMATION
  void _showDeleteConfirmation(KeluargaData item) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text(
            'Apakah Anda yakin ingin menghapus data keluarga "${item.namaKeluarga}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteKeluarga(item);
                Navigator.of(dialogContext).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Hapus', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // FUNGSI DELETE KELUARGA
  void _deleteKeluarga(KeluargaData item) {
    setState(() {
      _allKeluarga.removeWhere((k) => k.no == item.no);
      _applyFilter(_selectedFilter);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data keluarga "${item.namaKeluarga}" berhasil dihapus'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // FUNGSI DETAIL MODAL
  void _showDetailModal(KeluargaData item) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
                      'Detail Keluarga',
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
                _buildDetailRow('Nama Keluarga', item.namaKeluarga),
                const SizedBox(height: 12),
                _buildDetailRow('Kepala Keluarga', item.kepalaKeluarga),
                const SizedBox(height: 12),
                _buildDetailRow('Alamat Rumah', item.alamatRumah),
                const SizedBox(height: 12),
                _buildDetailRow('Status Kepemilikan', item.statusKepemilikan),
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
                      child: const Text(
                        'Edit',
                        style: TextStyle(color: Colors.white),
                      ),
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
  void _showEditModal(KeluargaData item) {
    // Controllers untuk form edit
    final namaKeluargaController = TextEditingController(
      text: item.namaKeluarga,
    );
    final kepalaKeluargaController = TextEditingController(
      text: item.kepalaKeluarga,
    );
    final alamatRumahController = TextEditingController(text: item.alamatRumah);
    String? selectedStatusKepemilikan = item.statusKepemilikan;
    String? selectedStatus = item.status;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
                      'Edit Data Keluarga',
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
                _buildEditField('Nama Keluarga', namaKeluargaController),
                const SizedBox(height: 12),
                _buildEditField('Kepala Keluarga', kepalaKeluargaController),
                const SizedBox(height: 12),
                _buildEditField('Alamat Rumah', alamatRumahController),
                const SizedBox(height: 12),

                // Dropdown Status Kepemilikan
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status Kepemilikan',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedStatusKepemilikan,
                      items: ['Pernik', 'Penyewa']
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedStatusKepemilikan = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ],
                ),
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
                      items: ['Aktif', 'Nonaktif']
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ),
                          )
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
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
                        _updateKeluarga(
                          item,
                          namaKeluargaController.text,
                          kepalaKeluargaController.text,
                          alamatRumahController.text,
                          selectedStatusKepemilikan!,
                          selectedStatus!,
                        );
                        Navigator.of(dialogContext).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                      ),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(color: Colors.white),
                      ),
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

  // FUNGSI UPDATE KELUARGA
  void _updateKeluarga(
    KeluargaData item,
    String namaKeluarga,
    String kepalaKeluarga,
    String alamatRumah,
    String statusKepemilikan,
    String status,
  ) {
    setState(() {
      final index = _allKeluarga.indexWhere((k) => k.no == item.no);
      if (index != -1) {
        _allKeluarga[index] = KeluargaData(
          no: item.no,
          namaKeluarga: namaKeluarga,
          kepalaKeluarga: kepalaKeluarga,
          alamatRumah: alamatRumah,
          statusKepemilikan: statusKepemilikan,
          status: status,
          aksi: item.aksi,
        );
        _applyFilter(_selectedFilter);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data keluarga "$namaKeluarga" berhasil diupdate'),
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
            width: 120,
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
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Data Keluarga',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        centerTitle: false,
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
                      hintText:
                          'Cari berdasarkan Nama Keluarga, Kepala Keluarga, atau Alamat...',
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
                  '${_filteredKeluarga.length} data ditemukan',
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

          // List Data Keluarga
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
                      return _buildKeluargaCard(item);
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
                (pageNumber >= _currentPage - 1 &&
                    pageNumber <= _currentPage + 1)) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: InkWell(
                  onTap: () => _goToPage(pageNumber),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isCurrentPage
                          ? const Color(0xFF6C63FF)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isCurrentPage
                            ? const Color(0xFF6C63FF)
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$pageNumber',
                        style: TextStyle(
                          color: isCurrentPage
                              ? Colors.white
                              : Colors.grey.shade700,
                          fontWeight: isCurrentPage
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else if (pageNumber == _currentPage - 2 ||
                pageNumber == _currentPage + 2) {
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
            color: _currentPage < _totalPages
                ? const Color(0xFF6C63FF)
                : Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildKeluargaCard(KeluargaData item) {
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
                    item.namaKeluarga,
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
                        'Kepala Keluarga: ${item.kepalaKeluarga}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Alamat: ${item.alamatRumah}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Status Kepemilikan: ${item.statusKepemilikan}',
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
      case 'Aktif':
        return Colors.green;
      case 'Nonaktif':
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
                  ...widget.uniqueStatus
                      .map(
                        (status) => _buildFilterOption(
                          status,
                          _tempSelectedFilter == status,
                        ),
                      )
                      .toList(),
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
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
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
                    child: const Text(
                      'TERAPKAN',
                      style: TextStyle(color: Colors.white),
                    ),
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
