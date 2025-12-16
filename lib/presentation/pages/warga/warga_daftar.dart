import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:jawara/core/models/warga_models.dart';
import 'package:jawara/core/repositories/warga_repository.dart';
import 'package:jawara/presentation/widgets/sidebar/sidebar.dart'; // Pastikan import Sidebar ada
import 'warga_detail.dart';
import 'warga_edit.dart';

@RoutePage()
class WargaDaftarPage extends StatefulWidget {
  const WargaDaftarPage({super.key});

  @override
  State<WargaDaftarPage> createState() => _WargaDaftarPageState();
}

class _WargaDaftarPageState extends State<WargaDaftarPage> {
  // Repository
  final CitizenRepository _repo = CitizenRepository();
  StreamSubscription<List<WargaModel>>? _subscription;

  // Data
  List<WargaModel> _allWarga = [];
  List<WargaModel> _filteredWarga = [];
  List<WargaModel> _currentPageData = [];
  
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Semua';
  
  // Pagination variables
  int _currentPage = 1;
  final int _itemsPerPage = 5;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _initDataListener();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  // LISTENER: Mendengarkan perubahan data dari Firestore realtime
  void _initDataListener() {
    _subscription = _repo.getAllCitizens().listen((data) {
      if (mounted) {
        setState(() {
          _allWarga = data;
          _applyFilter(_selectedFilter); // Refresh filter & pagination saat data berubah
        });
      }
    });
  }

  // --- LOGIC PAGINATION & FILTER ---

  void _updatePagination() {
    try {
      setState(() {
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
    if (_currentPage < _totalPages) _goToPage(_currentPage + 1);
  }

  void _previousPage() {
    if (_currentPage > 1) _goToPage(_currentPage - 1);
  }

  void _applyFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
      _currentPage = 1;

      final allData = _allWarga;
      List<WargaModel> filteredData;
      
      if (filter == 'Semua') {
        filteredData = List.from(allData);
      } else {
        filteredData = allData
            .where((w) => w.statusDomisili == filter || w.statusHidup == filter)
            .toList();
      }

      final searchText = _searchController.text;
      if (searchText.isNotEmpty) {
        _filteredWarga = filteredData.where((w) =>
                (w.nama).toLowerCase().contains(searchText.toLowerCase()) ||
                (w.nik).contains(searchText) ||
                (w.keluarga).toLowerCase().contains(searchText.toLowerCase()))
            .toList();
      } else {
        _filteredWarga = List.from(filteredData);
      }
      
      _updatePagination();
    });
  }

  void _onSearchChanged(String value) {
    _applyFilter(_selectedFilter);
  }

  void _showFilterDialog() {
    final uniqueStatus = _allWarga.map((w) => w.statusDomisili).toSet().toList();
    uniqueStatus.addAll(_allWarga.map((w) => w.statusHidup).toSet());
    uniqueStatus.remove(''); 
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

  // --- CRUD ACTIONS ---

  void _showDeleteConfirmation(WargaModel item) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus data warga "${item.nama}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _deleteWarga(item);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Hapus', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteWarga(WargaModel item) async {
    try {
      await _repo.deleteCitizen(item.docId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data warga "${item.nama}" berhasil dihapus'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _updateWarga(WargaModel item) async {
    try {
      await _repo.updateCitizen(item);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data warga "${item.nama}" berhasil diupdate'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal update: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // --- SHOW DIALOGS ---

  void _showDetailModal(WargaModel item) {
    showDialog(
      context: context,
      builder: (context) => WargaDetailDialog(
        item: item,
        onEditPressed: () => _showEditModal(item),
      ),
    );
  }

  void _showEditModal(WargaModel item) {
    showDialog(
      context: context,
      builder: (context) => WargaEditDialog(
        item: item,
        onSave: (updated) => _updateWarga(updated),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(), // UI UPDATE: Added Sidebar
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
                BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2)),
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

          // Info Data
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${_filteredWarga.length} data ditemukan', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                if (_totalPages > 1)
                  Text('Halaman $_currentPage dari $_totalPages', style: const TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          ),

          // List Data
          Expanded(
            child: _currentPageData.isEmpty
                ? Center(child: Text('Data tidak ditemukan', style: TextStyle(color: Colors.grey.shade500)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _currentPageData.length,
                    itemBuilder: (context, index) {
                      final item = _currentPageData[index];
                      return _buildWargaCard(item);
                    },
                  ),
          ),

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

  // --- WIDGETS KECIL (Pagination, Card, Filter) ---

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
          IconButton(
            onPressed: _currentPage > 1 ? _previousPage : null,
            icon: const Icon(Icons.chevron_left),
            color: _currentPage > 1 ? const Color(0xFF6C63FF) : Colors.grey,
          ),
          ...List.generate(_totalPages, (index) {
            final pageNumber = index + 1;
            final isCurrentPage = pageNumber == _currentPage;
            if (_totalPages <= 7 || pageNumber == 1 || pageNumber == _totalPages || (pageNumber >= _currentPage - 1 && pageNumber <= _currentPage + 1)) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: InkWell(
                  onTap: () => _goToPage(pageNumber),
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: isCurrentPage ? const Color(0xFF6C63FF) : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: isCurrentPage ? const Color(0xFF6C63FF) : Colors.grey.shade300),
                    ),
                    child: Center(child: Text('$pageNumber', style: TextStyle(color: isCurrentPage ? Colors.white : Colors.grey.shade700, fontWeight: isCurrentPage ? FontWeight.bold : FontWeight.normal))),
                  ),
                ),
              );
            } else if (pageNumber == _currentPage - 2 || pageNumber == _currentPage + 2) {
              return const Padding(padding: EdgeInsets.symmetric(horizontal: 4), child: Text('...', style: TextStyle(color: Colors.grey)));
            } else {
              return const SizedBox.shrink();
            }
          }),
          IconButton(
            onPressed: _currentPage < _totalPages ? _nextPage : null,
            icon: const Icon(Icons.chevron_right),
            color: _currentPage < _totalPages ? const Color(0xFF6C63FF) : Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildWargaCard(WargaModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
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
                  Text(item.nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('NIK: ${item.nik}', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text('Keluarga: ${item.keluarga}', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text('Gender: ${item.jenisKelamin}', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text('Tanggal Lahir: ${item.tanggalLahir != null ? '${item.tanggalLahir!.day.toString().padLeft(2, '0')}/${item.tanggalLahir!.month.toString().padLeft(2, '0')}/${item.tanggalLahir!.year}' : '-'}', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text('Status Hidup: ${item.statusHidup}', style: const TextStyle(color: Colors.grey, fontSize: 14)),
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
                    color: _getStatusColor(item.statusDomisili),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(item.statusDomisili, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit': _showEditModal(item); break;
                      case 'delete': _showDeleteConfirmation(item); break;
                      case 'detail': _showDetailModal(item); break;
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
    if (status.toLowerCase() == 'aktif') return Colors.green;
    return Colors.grey;
  }
}

// Filter Bottom Sheet
class _FilterBottomSheet extends StatefulWidget {
  final List<String> uniqueStatus;
  final String selectedFilter;
  final Function(String) onFilterApplied;

  const _FilterBottomSheet({required this.uniqueStatus, required this.selectedFilter, required this.onFilterApplied});

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
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Filter Data', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close)),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pilih Status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  ...widget.uniqueStatus.map((status) => _buildFilterOption(status, _tempSelectedFilter == status)).toList(),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade300))),
            child: Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () => Navigator.of(context).pop(), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)), child: const Text('BATAL'))),
                const SizedBox(width: 12),
                Expanded(child: ElevatedButton(onPressed: () { widget.onFilterApplied(_tempSelectedFilter); Navigator.of(context).pop(); }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C63FF), padding: const EdgeInsets.symmetric(vertical: 12)), child: const Text('TERAPKAN', style: TextStyle(color: Colors.white)))),
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
        leading: Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: isSelected ? const Color(0xFF6C63FF) : Colors.grey),
        title: Text(status),
        onTap: () => setState(() => _tempSelectedFilter = status),
      ),
    );
  }
}