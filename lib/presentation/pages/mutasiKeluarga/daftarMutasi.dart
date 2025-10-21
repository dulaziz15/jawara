import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'filter_mutasi.dart';

// -----------------------------------------------------------------------------
// DATA MODEL
// -----------------------------------------------------------------------------
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

// -----------------------------------------------------------------------------
// PAGE: Daftar Mutasi Keluarga
// -----------------------------------------------------------------------------
@RoutePage()
class DaftarMutasiPage extends StatefulWidget {
  const DaftarMutasiPage({super.key});

  @override
  State<DaftarMutasiPage> createState() => _DaftarMutasiPageState();
}

class _DaftarMutasiPageState extends State<DaftarMutasiPage> {
  // ---------------------------------------------------------------------------
  // DATA DUMMY
  // ---------------------------------------------------------------------------
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
      keluarga: 'Keluarga Varizky Naldiba Rimra',
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
    MutasiData(
      no: 5,
      keluarga: 'Keluarga Raudhli Firdaus Naufal',
      alamatLama: 'Jl. Diponegoro No. 55, Semarang',
      alamatBaru: 'Jl. Ahmad Yani No. 66, Jakarta',
      tanggalMutasi: '05-11-2025',
      jenisMutasi: 'Pindah Provinsi',
      alasan: 'Pekerjaan',
    ),
    MutasiData(
      no: 6,
      keluarga: 'Keluarga Surya Dharma',
      alamatLama: 'Jl. Gajah Mada No. 77, Denpasar',
      alamatBaru: 'Jl. Thamrin No. 88, Medan',
      tanggalMutasi: '10-11-2025',
      jenisMutasi: 'Pindah Kota',
      alasan: 'Bisnis',
    ),
    MutasiData(
      no: 7,
      keluarga: 'Keluarga Putri Maharani',
      alamatLama: 'Jl. Merpati No. 99, Malang',
      alamatBaru: 'Jl. Rajawali No. 111, Surabaya',
      tanggalMutasi: '15-11-2025',
      jenisMutasi: 'Pindah Domisili',
      alasan: 'Pendidikan',
    ),
    MutasiData(
      no: 8,
      keluarga: 'Keluarga Ahmad Fauzi',
      alamatLama: 'Jl. Cendrawasih No. 222, Bogor',
      alamatBaru: 'Jl. Elang No. 333, Bandung',
      tanggalMutasi: '20-11-2025',
      jenisMutasi: 'Pindah Kota',
      alasan: 'Keluarga',
    ),
    MutasiData(
      no: 9,
      keluarga: 'Keluarga Sari Indah',
      alamatLama: 'Jl. Kenari No. 444, Yogyakarta',
      alamatBaru: 'Jl. Merak No. 555, Solo',
      tanggalMutasi: '25-11-2025',
      jenisMutasi: 'Pindah Domisili',
      alasan: 'Pekerjaan',
    ),
    MutasiData(
      no: 10,
      keluarga: 'Keluarga Budi Santoso',
      alamatLama: 'Jl. Jalak No. 666, Surakarta',
      alamatBaru: 'Jl. Kutilang No. 777, Semarang',
      tanggalMutasi: '30-11-2025',
      jenisMutasi: 'Pindah Kota',
      alasan: 'Bisnis',
    ),
  ];

  // ---------------------------------------------------------------------------
  // STATE VARIABLES
  // ---------------------------------------------------------------------------
  final TextEditingController _searchController = TextEditingController();
  List<MutasiData> _filteredData = [];
  List<MutasiData> _currentPageData = [];

  String _selectedFilter = 'Semua';
  int _currentPage = 1;
  final int _itemsPerPage = 5;
  int _totalPages = 1;

  // ---------------------------------------------------------------------------
  // INIT
  // ---------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _filteredData = _allData;
    _updatePagination();
  }

  // ---------------------------------------------------------------------------
  // PAGINATION
  // ---------------------------------------------------------------------------
  void _updatePagination() {
    try {
      final safeData = _filteredData;

      setState(() {
        _totalPages = (safeData.length / _itemsPerPage).ceil();
        if (_totalPages == 0) _totalPages = 1;

        if (_currentPage > _totalPages) _currentPage = _totalPages;

        final startIndex = (_currentPage - 1) * _itemsPerPage;
        var endIndex = startIndex + _itemsPerPage;
        if (endIndex > safeData.length) endIndex = safeData.length;

        _currentPageData = safeData.sublist(startIndex, endIndex);
      });
    } catch (e) {
      debugPrint('Error in pagination: $e');
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

  void _nextPage() => _goToPage(_currentPage + 1);
  void _previousPage() => _goToPage(_currentPage - 1);

  // ---------------------------------------------------------------------------
  // FILTER & SEARCH
  // ---------------------------------------------------------------------------
  void _applyFilter(String jenisMutasi) {
    try {
      setState(() {
        _selectedFilter = jenisMutasi;
        _currentPage = 1;

        // Filter jenis mutasi
        List<MutasiData> filtered = jenisMutasi == 'Semua'
            ? _allData
            : _allData.where((d) => d.jenisMutasi == jenisMutasi).toList();

        // Filter pencarian
        final query = _searchController.text.trim().toLowerCase();
        if (query.isNotEmpty) {
          filtered = filtered.where((d) {
            return d.keluarga.toLowerCase().contains(query) ||
                d.jenisMutasi.toLowerCase().contains(query);
          }).toList();
        }

        _filteredData = filtered;
        _updatePagination();
      });
    } catch (e) {
      debugPrint('Error applying filter: $e');
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
        final query = value.trim().toLowerCase();

        List<MutasiData> searchResults = query.isEmpty
            ? _allData
            : _allData.where((d) {
                return d.keluarga.toLowerCase().contains(query) ||
                    d.jenisMutasi.toLowerCase().contains(query);
              }).toList();

        _filteredData = _selectedFilter == 'Semua'
            ? searchResults
            : searchResults
                .where((d) => d.jenisMutasi == _selectedFilter)
                .toList();

        _updatePagination();
      });
    } catch (e) {
      debugPrint('Error in search: $e');
      setState(() {
        _filteredData = _allData;
        _updatePagination();
      });
    }
  }

  // ---------------------------------------------------------------------------
  // UI HELPERS
  // ---------------------------------------------------------------------------
  Color _getJenisMutasiColor(String jenis) {
    switch (jenis.toLowerCase()) {
      case 'pindah domisili':
        return Colors.blue;
      case 'pindah kota':
        return Colors.green;
      case 'pindah provinsi':
        return Colors.orange;
      case 'pindah negara':
        return Colors.purple;
      default:
        return Colors.grey;
    }
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

  // ---------------------------------------------------------------------------
  // DIALOGS
  // ---------------------------------------------------------------------------
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
      builder: (ctx) {
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
                      'Detail Mutasi Keluarga',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4F6DF5),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const Divider(thickness: 1.2),
                const SizedBox(height: 16),

                _detailRow('Keluarga', item.keluarga),
                const SizedBox(height: 12),
                _detailRow('Alamat Lama', item.alamatLama),
                const SizedBox(height: 12),
                _detailRow('Alamat Baru', item.alamatBaru),
                const SizedBox(height: 12),
                _detailRow('Tanggal Mutasi', item.tanggalMutasi),
                const SizedBox(height: 12),

                // Jenis Mutasi Badge
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

                _detailRow('Alasan', item.alasan),
                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(),
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

  // ---------------------------------------------------------------------------
  // UI COMPONENTS
  // ---------------------------------------------------------------------------
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
        child: Row(
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
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              onSelected: (value) {
                if (value == 'detail') _showDetailModal(context, item);
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'detail', child: Text('Detail')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationControls() {
    if (_totalPages <= 1) return const SizedBox.shrink();

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
            onPressed: _currentPage > 1 ? _previousPage : null,
            icon: const Icon(Icons.chevron_left),
            color: _currentPage > 1 ? const Color(0xFF4F6DF5) : Colors.grey,
          ),
          ...List.generate(_totalPages, (i) {
            final page = i + 1;
            final active = page == _currentPage;

            if (_totalPages <= 7 ||
                page == 1 ||
                page == _totalPages ||
                (page >= _currentPage - 1 && page <= _currentPage + 1)) {
              return GestureDetector(
                onTap: () => _goToPage(page),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: active ? const Color(0xFF4F6DF5) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: active
                          ? const Color(0xFF4F6DF5)
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$page',
                      style: TextStyle(
                        color: active ? Colors.white : Colors.grey.shade700,
                        fontWeight:
                            active ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            } else if (page == _currentPage - 2 || page == _currentPage + 2) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text('...', style: TextStyle(color: Colors.grey)),
              );
            }
            return const SizedBox.shrink();
          }),
          IconButton(
            onPressed: _currentPage < _totalPages ? _nextPage : null,
            icon: const Icon(Icons.chevron_right),
            color: _currentPage < _totalPages
                ? const Color(0xFF4F6DF5)
                : Colors.grey,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: _showFilterDialog,
        backgroundColor: const Color(0xFF4F6DF5),
        child: const Icon(Icons.filter_list, color: Colors.white),
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
                          'Cari berdasarkan keluarga atau jenis mutasi...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Info
          Padding(
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
                      return _buildDataCard(_currentPageData[index]);
                    },
                  ),
          ),

          // Pagination
          _buildPaginationControls(),
        ],
      ),
    );
  }
}
