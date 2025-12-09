import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jawara/core/models/rumah_models.dart';
import 'package:jawara/core/repositories/rumah_repository.dart';

@RoutePage()
class RumahDaftarPage extends StatefulWidget {
  const RumahDaftarPage({super.key});

  @override
  State<RumahDaftarPage> createState() => _RumahDaftarPageState();
}

class _RumahDaftarPageState extends State<RumahDaftarPage> {
  final RumahRepository _repo = RumahRepository();
  final TextEditingController _searchController = TextEditingController();
  
  String _selectedFilter = 'Semua';
  String _searchQuery = '';
  
  // Pagination State
  int _currentPage = 1;
  final int _itemsPerPage = 10; // Saya naikkan sedikit biar enak dilihat

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter Logic
  List<RumahModel> _applyFilterAndSearch(List<RumahModel> allData) {
    return allData.where((rumah) {
      bool matchStatus = _selectedFilter == 'Semua' || rumah.status.toLowerCase() == _selectedFilter.toLowerCase();
      
      // Search bisa berdasarkan Alamat ATAU Nomor Rumah
      bool matchSearch = _searchQuery.isEmpty || 
          rumah.alamat.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          rumah.no.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchStatus && matchSearch;
    }).toList();
  }

  // --- ACTIONS ---

  // Update function terima parameter 'no'
  void _updateRumah(RumahModel item, String newNo, String newAlamat, String newStatus) async {
    try {
      await _repo.updateRumah(item.id, newNo, newAlamat, newStatus);
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rumah No ${item.no} berhasil diupdate'), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal update: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _deleteRumah(RumahModel item) async {
    try {
      await _repo.deleteRumah(item.id);
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rumah No ${item.no} berhasil dihapus'), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal hapus: $e'), backgroundColor: Colors.red),
      );
    }
  }

  // --- MODALS ---

  void _showDetailModal(RumahModel item) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Detail Rumah', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6C63FF))),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const Divider(),
              // Tampilkan Data
              _buildDetailRow('No. Rumah', item.no), // Tampilkan Nomor Rumah
              _buildDetailRow('Alamat', item.alamat),
              _buildDetailRow('Status', item.status),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showEditModal(item);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C63FF)),
                  child: const Text('Edit', style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showEditModal(RumahModel item) {
    // Controller untuk Nomor dan Alamat
    final noController = TextEditingController(text: item.no);
    final alamatController = TextEditingController(text: item.alamat);
    String selectedStatus = item.status;

    // Normalisasi status agar sesuai dengan dropdown (Case sensitive fix)
    if (selectedStatus.toLowerCase() == 'ditempati') selectedStatus = 'Ditempati';
    else if (selectedStatus.toLowerCase() == 'tersedia') selectedStatus = 'Tersedia';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Edit Data Rumah', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6C63FF))),
                    const SizedBox(height: 16),
                    
                    // Input Nomor Rumah
                    _buildEditField('No. Rumah', noController),
                    const SizedBox(height: 12),
                    
                    // Input Alamat
                    _buildEditField('Alamat', alamatController),
                    const SizedBox(height: 12),
                    
                    const Text('Status', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: ['Ditempati', 'Tersedia'].contains(selectedStatus) ? selectedStatus : null,
                      items: ['Ditempati', 'Tersedia'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (val) => setModalState(() => selectedStatus = val!),
                      decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), contentPadding: const EdgeInsets.symmetric(horizontal: 12)),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
                        ElevatedButton(
                          onPressed: () {
                            _updateRumah(item, noController.text, alamatController.text, selectedStatus);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C63FF)),
                          child: const Text('Simpan', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  void _showDeleteConfirmation(RumahModel item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Hapus rumah No. ${item.no}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              _deleteRumah(item);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _FilterBottomSheet(
        selectedFilter: _selectedFilter,
        onFilterApplied: (val) {
          setState(() {
            _selectedFilter = val;
            _currentPage = 1; 
          });
        },
      ),
    );
  }

  // --- BUILD UI ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<List<RumahModel>>(
        stream: _repo.getAllRumah(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final allData = snapshot.data ?? [];
          final filteredData = _applyFilterAndSearch(allData);

          // Pagination Logic
          final totalPages = (filteredData.length / _itemsPerPage).ceil();
          final safeTotalPages = totalPages == 0 ? 1 : totalPages;
          if (_currentPage > safeTotalPages) _currentPage = safeTotalPages;

          final startIndex = (_currentPage - 1) * _itemsPerPage;
          final endIndex = startIndex + _itemsPerPage;
          final pagedData = filteredData.sublist(
            startIndex, 
            endIndex > filteredData.length ? filteredData.length : endIndex
          );

          return Column(
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
                        onChanged: (val) => setState(() {
                          _searchQuery = val;
                          _currentPage = 1;
                        }),
                        decoration: const InputDecoration(
                          hintText: 'Cari No Rumah / Alamat...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Info Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${filteredData.length} rumah ditemukan', style: const TextStyle(color: Colors.grey)),
                    if (safeTotalPages > 1)
                      Text('Halaman $_currentPage dari $safeTotalPages', style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),

              // List View
              Expanded(
                child: pagedData.isEmpty
                    ? Center(child: Text('Data tidak ditemukan', style: TextStyle(color: Colors.grey.shade500)))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: pagedData.length,
                        itemBuilder: (context, index) => _buildRumahCard(pagedData[index]),
                      ),
              ),

              if (safeTotalPages > 1) _buildPaginationControls(safeTotalPages),
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

  // --- WIDGETS ---

  Widget _buildPaginationControls(int totalPages) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey.shade300))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
            icon: const Icon(Icons.chevron_left),
            color: _currentPage > 1 ? const Color(0xFF6C63FF) : Colors.grey,
          ),
           Text("$_currentPage", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          IconButton(
            onPressed: _currentPage < totalPages ? () => setState(() => _currentPage++) : null,
            icon: const Icon(Icons.chevron_right),
            color: _currentPage < totalPages ? const Color(0xFF6C63FF) : Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildRumahCard(RumahModel item) {
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
          crossAxisAlignment: CrossAxisAlignment.center, // Center vertical
          children: [
            // Lingkaran Nomer Rumah
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  item.no, // Tampilkan Nomor Rumah
                  style: const TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold, 
                    color: Color(0xFF6C63FF)
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Info Alamat
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.alamat, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  // Tampilkan Status dengan warna
                  Text(
                    item.status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: item.status.toLowerCase() == 'ditempati' ? Colors.orange : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            
            // Tombol Aksi
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') _showEditModal(item);
                if (value == 'delete') _showDeleteConfirmation(item);
                if (value == 'detail') _showDetailModal(item);
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
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text('$label:', style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildEditField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(controller: controller, decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8))),
      ],
    );
  }
}

// Widget Bottom Sheet Filter (Sama seperti sebelumnya)
class _FilterBottomSheet extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterApplied;

  const _FilterBottomSheet({required this.selectedFilter, required this.onFilterApplied});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text('Filter Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ListTile(
            title: const Text('Semua'),
            leading: Icon(selectedFilter == 'Semua' ? Icons.radio_button_checked : Icons.radio_button_off, color: const Color(0xFF6C63FF)),
            onTap: () { onFilterApplied('Semua'); Navigator.pop(context); },
          ),
          ListTile(
            title: const Text('Ditempati'),
            leading: Icon(selectedFilter == 'Ditempati' ? Icons.radio_button_checked : Icons.radio_button_off, color: const Color(0xFF6C63FF)),
            onTap: () { onFilterApplied('Ditempati'); Navigator.pop(context); },
          ),
          ListTile(
            title: const Text('Tersedia'),
            leading: Icon(selectedFilter == 'Tersedia' ? Icons.radio_button_checked : Icons.radio_button_off, color: const Color(0xFF6C63FF)),
            onTap: () { onFilterApplied('Tersedia'); Navigator.pop(context); },
          ),
        ],
      ),
    );
  }
}