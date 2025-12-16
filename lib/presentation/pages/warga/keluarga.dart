import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // Untuk StreamSubscription
import 'package:jawara/presentation/widgets/sidebar/sidebar.dart';
import 'package:jawara/core/models/family_models.dart'; 
import 'keluarga_detail.dart'; 
import 'keluarga_edit.dart'; 
import 'package:jawara/core/repositories/family_repository.dart'; 
@RoutePage()
class KeluargaPage extends StatefulWidget {
  const KeluargaPage({super.key});

  @override
  State<KeluargaPage> createState() => _KeluargaPageState();
}

class _KeluargaPageState extends State<KeluargaPage> {
  // Repository Instance
  final FamilyRepository _repo = FamilyRepository();
  StreamSubscription<List<FamilyModel>>? _familySubscription;

  // State Variables
  List<FamilyModel> _allKeluarga = [];
  List<FamilyModel> _filteredKeluarga = [];
  List<FamilyModel> _currentPageData = [];
  
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
    _familySubscription?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  // 1. LISTEN DATA DARI REPOSITORY
  void _initDataListener() {
    _familySubscription = _repo.getAllFamilies().listen((families) {
      if (mounted) {
        setState(() {
          _allKeluarga = families;
          // Re-apply filter setiap ada data baru dari Firestore
          _applyFilter(_selectedFilter); 
        });
      }
    }, onError: (e) {
      print("Error fetching families: $e");
    });
  }

  // 2. LOGIKA PAGINATION (Sama seperti sebelumnya)
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
    if (_currentPage < _totalPages) _goToPage(_currentPage + 1);
  }

  void _previousPage() {
    if (_currentPage > 1) _goToPage(_currentPage - 1);
  }

  // 3. LOGIKA FILTER & SEARCH
  void _applyFilter(String filter) {
    try {
      setState(() {
        _selectedFilter = filter;
        _currentPage = 1;
        
        final allData = _allKeluarga;
        List<FamilyModel> filteredData;

        // Filter Dropdown
        if (filter == 'Semua') {
          filteredData = List.from(allData);
        } else {
          filteredData = allData.where((k) => 
            k.statusDomisiliKeluarga == filter || 
            k.statusKepemilikanRumah == filter
          ).toList();
        }

        // Search Text
        final searchText = _searchController.text;
        if (searchText.isNotEmpty) {
          _filteredKeluarga = filteredData.where((k) =>
              (k.namaKeluarga).toLowerCase().contains(searchText.toLowerCase()) ||
              (k.nikKepalaKeluarga).toLowerCase().contains(searchText.toLowerCase()) ||
              (k.alamatRumah).toLowerCase().contains(searchText.toLowerCase())).toList();
        } else {
          _filteredKeluarga = List.from(filteredData);
        }
        _updatePagination();
      });
    } catch (e) {
      print('Error applying filter: $e');
    }
  }

  void _onSearchChanged(String value) {
    // Memanggil _applyFilter ulang karena logic search sudah ada di sana
    _applyFilter(_selectedFilter);
  }

  void _showFilterDialog() {
    // Ambil unique status dari data real
    final uniqueStatus = _allKeluarga.map((k) => k.statusDomisiliKeluarga).toSet().toList();
    uniqueStatus.addAll(_allKeluarga.map((k) => k.statusKepemilikanRumah).toSet());
    uniqueStatus.remove(''); // Hapus string kosong jika ada
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

  // 4. CRUD ACTIONS VIA REPOSITORY

  // Update Data
  void _updateKeluarga(FamilyModel updatedItem) async {
    try {
      await _repo.updateFamily(updatedItem);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data keluarga "${updatedItem.namaKeluarga}" berhasil diupdate'), backgroundColor: Colors.green),
      );
      // Note: Data akan auto-refresh karena kita listen stream di _initDataListener
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal update: $e'), backgroundColor: Colors.red),
      );
    }
  }

  // Delete Data
  void _deleteKeluarga(FamilyModel item) async {
    try {
      await _repo.deleteFamily(item.noKk); // Menggunakan NoKK sebagai ID sesuai Repo
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data keluarga "${item.namaKeluarga}" berhasil dihapus'), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal hapus: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _showDeleteConfirmation(FamilyModel item) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus data keluarga "${item.namaKeluarga}"?'),
          actions: [
            TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('Batal')),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _deleteKeluarga(item);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Hapus', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // 5. MODAL TRIGGERS
  void _showDetailModal(FamilyModel item) {
    showDialog(
      context: context,
      builder: (context) => KeluargaDetailDialog(
        item: item,
        onEditPressed: () => _showEditModal(item),
      ),
    );
  }

  void _showEditModal(FamilyModel item) {
    showDialog(
      context: context,
      builder: (context) => KeluargaEditDialog(
        item: item,
        onSave: (updatedFamily) => _updateKeluarga(updatedFamily),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Data Keluarga', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
        actions: [
          IconButton(onPressed: () => context.router.pushNamed('/keluarga/tambah'), icon: const Icon(Icons.add))
        ],
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
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.grey),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: const InputDecoration(hintText: 'Cari Nama Keluarga, NIK, atau Alamat...', border: InputBorder.none, hintStyle: TextStyle(color: Colors.grey)),
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
                Text('${_filteredKeluarga.length} data ditemukan', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                if (_totalPages > 1) Text('Halaman $_currentPage dari $_totalPages', style: const TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          ),

          // List View
          Expanded(
            child: _currentPageData.isEmpty
                ? Center(child: Text('Data tidak ditemukan', style: TextStyle(color: Colors.grey.shade500)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _currentPageData.length,
                    itemBuilder: (context, index) {
                      final item = _currentPageData[index];
                      return _buildKeluargaCard(item);
                    },
                  ),
          ),

          // Pagination
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

  // WIDGETS PENDUKUNG (Pagination & Card)

  Widget _buildPaginationControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey.shade300))),
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
            // Simple logic untuk menampilkan page number
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

  Widget _buildKeluargaCard(FamilyModel item) {
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
                  Text(item.namaKeluarga, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('No KK: ${item.noKk}', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text('Kepala: ${item.nikKepalaKeluarga}', style: const TextStyle(color: Colors.grey, fontSize: 14)), // Idealnya ini Nama, bukan NIK
                      const SizedBox(height: 4),
                      Text('Alamat: ${item.alamatRumah}', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text('Status: ${item.statusKepemilikanRumah}', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: _getStatusColor(item.statusDomisiliKeluarga), borderRadius: BorderRadius.circular(20)),
                  child: Text(item.statusDomisiliKeluarga, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
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
    if (status.toLowerCase() == 'nonaktif') return Colors.grey;
    return Colors.blueGrey;
  }
}

// 5. FILTER BOTTOM SHEET (Bisa dipisah file juga jika mau)
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