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
      statusRegistrasi: 'Pending',
    ),
    RegistrationData(
      no: 4,
      nama: 'Abdul Aziz',
      nik: '3201122501050002',
      email: 'dulaziz@gmail.com',
      jenisKelamin: 'L',
      fotoIdentitasAsset: 'assets/4.png',
      statusRegistrasi: 'Pending',
    ),
      RegistrationData(
      no: 5,
      nama: 'Abdul Aziz',
      nik: '3201122501050002',
      email: 'dulaziz@gmail.com',
      jenisKelamin: 'L',
      fotoIdentitasAsset: 'assets/5.png',
      statusRegistrasi: 'Diterima',
    ),
      RegistrationData(
      no: 6,
      nama: 'Abdul Aziz',
      nik: '3201122501050002',
      email: 'dulaziz@gmail.com',
      jenisKelamin: 'L',
      fotoIdentitasAsset: 'assets/6.png',
      statusRegistrasi: 'Diterima',
    ),
      RegistrationData(
      no: 7,
      nama: 'Abdul Aziz',
      nik: '3201122501050002',
      email: 'dulaziz@gmail.com',
      jenisKelamin: 'L',
      fotoIdentitasAsset: 'assets/7.png',
      statusRegistrasi: 'Diterima',
    ),
      RegistrationData(
      no: 8,
      nama: 'Abdul Aziz',
      nik: '3201122501050002',
      email: 'dulaziz@gmail.com',
      jenisKelamin: 'L',
      fotoIdentitasAsset: 'assets/8.png',
      statusRegistrasi: 'Diterima',
    ),
      RegistrationData(
      no: 9,
      nama: 'Abdul Aziz',
      nik: '3201122501050002',
      email: 'dulaziz@gmail.com',
      jenisKelamin: 'L',
      fotoIdentitasAsset: 'assets/9.png',
      statusRegistrasi: 'Diterima',
    ),
  ];

  List<RegistrationData> _filteredData = [];
  List<RegistrationData> _currentPageData = [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Semua';
  
  // Pagination variables
  int _currentPage = 1;
  final int _itemsPerPage = 5;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _filteredData = _allData;
    _updatePagination();
  }

  void _updatePagination() {
    try {
      // Pastikan _filteredData tidak null
      final safeFilteredData = _filteredData;
      
      setState(() {
        _totalPages = (safeFilteredData.length / _itemsPerPage).ceil();
        if (_totalPages == 0) _totalPages = 1;
        
        if (_currentPage > _totalPages) {
          _currentPage = _totalPages;
        }
        
        final startIndex = (_currentPage - 1) * _itemsPerPage;
        var endIndex = startIndex + _itemsPerPage;
        if (endIndex > safeFilteredData.length) {
          endIndex = safeFilteredData.length;
        }
        
        _currentPageData = safeFilteredData.sublist(startIndex, endIndex);
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

        // Apply filter status
        List<RegistrationData> statusFilteredData;
        if (status == 'Semua') {
          statusFilteredData = _allData;
        } else {
          statusFilteredData = _allData.where((data) => data.statusRegistrasi == status).toList();
        }
        
        // Apply search filter jika ada
        final searchText = _searchController.text.trim();
        if (searchText.isNotEmpty) {
          _filteredData = statusFilteredData.where((data) {
            final nama = data.nama.toLowerCase();
            final nik = data.nik.toLowerCase();
            final searchLower = searchText.toLowerCase();
            return nama.contains(searchLower) || nik.contains(searchLower);
          }).toList();
        } else {
          _filteredData = statusFilteredData;
        }
        
        _updatePagination();
      });
    } catch (e) {
      print('Error applying filter: $e');
      setState(() {
        _filteredData = _allData;
        _updatePagination();
      });
    }
  }

  void _onSearchChanged(String value) {
    try {
      setState(() {
        _currentPage = 1;
        
        // Apply search filter
        final searchText = value.trim();
        List<RegistrationData> searchFilteredData;
        if (searchText.isEmpty) {
          searchFilteredData = _allData;
        } else {
          searchFilteredData = _allData.where((data) {
            final nama = data.nama.toLowerCase();
            final nik = data.nik.toLowerCase();
            final searchLower = searchText.toLowerCase();
            return nama.contains(searchLower) || nik.contains(searchLower);
          }).toList();
        }
        
        // Apply status filter
        if (_selectedFilter != 'Semua') {
          _filteredData = searchFilteredData.where((data) => data.statusRegistrasi == _selectedFilter).toList();
        } else {
          _filteredData = searchFilteredData;
        }
        
        _updatePagination();
      });
    } catch (e) {
      print('Error in search: $e');
      setState(() {
        _filteredData = _allData;
        _updatePagination();
      });
    }
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

                // Nama
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

                // Status Pendaftaran
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

  Widget _buildPaginationControls() {
    // Pastikan _totalPages valid
    final totalPages = _totalPages;
    final currentPage = _currentPage;
    
    if (totalPages <= 1) return const SizedBox.shrink();

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
            onPressed: currentPage > 1 ? _previousPage : null,
            icon: const Icon(Icons.chevron_left),
            color: currentPage > 1 ? const Color(0xFF6C63FF) : Colors.grey,
          ),

          // Page Numbers
          ...List.generate(totalPages, (index) {
            final pageNumber = index + 1;
            final isCurrentPage = pageNumber == currentPage;
            
            // Tampilkan nomor halaman dengan logika yang aman
            if (totalPages <= 7 || 
                pageNumber == 1 || 
                pageNumber == totalPages ||
                (pageNumber >= currentPage - 1 && pageNumber <= currentPage + 1)) {
              
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
            } else if (pageNumber == currentPage - 2 || pageNumber == currentPage + 2) {
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
            onPressed: currentPage < totalPages ? _nextPage : null,
            icon: const Icon(Icons.chevron_right),
            color: currentPage < totalPages ? const Color(0xFF6C63FF) : Colors.grey,
          ),
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
                      hintText: 'Cari berdasarkan Nama atau NIK...',
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
                  '${_filteredData.length} data ditemukan',
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

          // List Data
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
                      return _buildDataCard(item);
                    },
                  ),
          ),

          // Pagination Controls
          _buildPaginationControls(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFilterDialog,
        backgroundColor: const Color(0xFF6C63FF),
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