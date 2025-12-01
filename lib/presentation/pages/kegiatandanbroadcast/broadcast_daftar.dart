import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jawara/core/models/broadcast_models.dart';
import 'package:jawara/core/repositories/broadcast_repository.dart'; // Pastikan import ini

@RoutePage()
class BroadcastDaftarPage extends StatefulWidget {
  const BroadcastDaftarPage({super.key});

  @override
  State<BroadcastDaftarPage> createState() => _BroadcastDaftarPageState();
}

class _BroadcastDaftarPageState extends State<BroadcastDaftarPage> {
  // 1. Inisialisasi Repository
  late BroadcastRepository _repository;
  
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'Semua';
  List<String> _availableCategories = [];

  @override
  void initState() {
    super.initState();
    _repository = BroadcastRepository(); // Init di sini
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  void _applyFilter(String kategori) {
    setState(() {
      _selectedFilter = kategori;
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => FilterBroadcastDialog(
        initialKategori: _selectedFilter,
        kategoriList: _availableCategories,
        onApplyFilter: _applyFilter,
      ),
    );
  }

  String _getBulan(int bulan) {
    const namaBulan = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli',
      'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return namaBulan[bulan - 1];
  }

  void _showDeleteConfirmationDialog(BuildContext context, BroadcastModels item) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text(
              'Apakah Anda yakin ingin menghapus broadcast "${item.judulBroadcast}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                try {
                  await _repository.deleteBroadcast(item.docId);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Broadcast berhasil dihapus')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal menghapus: $e')),
                    );
                  }
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
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
                      hintText: 'Cari berdasarkan judul atau kategori...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // StreamBuilder
          Expanded(
            child: StreamBuilder<List<BroadcastModels>>(
              stream: _repository.getBroadcasts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                List<BroadcastModels> allData = snapshot.data ?? [];

                // Update kategori unik untuk filter
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final categories = allData.map((e) => e.kategoriBroadcast).toSet().toList();
                  if (_availableCategories.length != categories.length) {
                    _availableCategories = categories;
                  }
                });

                // Logic Filter
                final filteredData = allData.where((item) {
                  bool matchesCategory = _selectedFilter == 'Semua' || 
                                         item.kategoriBroadcast == _selectedFilter;
                  bool matchesSearch = _searchQuery.isEmpty ||
                      item.judulBroadcast.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                      item.kategoriBroadcast.toLowerCase().contains(_searchQuery.toLowerCase());
                  return matchesCategory && matchesSearch;
                }).toList();

                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        '${filteredData.length} data ditemukan',
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                    Expanded(
                      child: filteredData.isEmpty
                          ? Center(
                              child: Text(
                                'Data tidak ditemukan',
                                style: TextStyle(color: Colors.grey.shade500),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: filteredData.length,
                              itemBuilder: (context, index) {
                                return _buildDataCard(filteredData[index]);
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFilterDialog,
        backgroundColor: const Color(0xFF6C63FF),
        child: const Icon(Icons.filter_list, color: Colors.white),
      ),
    );
  }

  Widget _buildDataCard(BroadcastModels item) {
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
                        item.judulBroadcast,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Kategori: ${item.kategoriBroadcast}',
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Isi Pesan: ${item.isiPesan}',
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tanggal: ${item.tanggalPublikasi.day.toString().padLeft(2, '0')} ${_getBulan(item.tanggalPublikasi.month)} ${item.tanggalPublikasi.year}',
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.black54),
                  onSelected: (String value) {
                    if (value == 'detail') {
                      context.router.pushNamed('/kegiatandanbroadcast/broadcast_detail/${item.docId}');
                    } else if (value == 'edit') {
                      context.router.pushNamed('/kegiatandanbroadcast/broadcast_edit/${item.docId}');
                    } else if (value == 'hapus') {
                      _showDeleteConfirmationDialog(context, item);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'detail', child: Row(children: [SizedBox(width: 8), Text('Detail')])),
                    const PopupMenuItem(value: 'edit', child: Row(children: [SizedBox(width: 8), Text('Edit')])),
                    const PopupMenuItem(value: 'hapus', child: Row(children: [SizedBox(width: 8), Text('Hapus')])),
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

// Widget Dialog Filter (Tetap sama seperti kode Anda, tidak perlu diubah)
class FilterBroadcastDialog extends StatefulWidget {
  final String initialKategori;
  final List<String> kategoriList;
  final Function(String) onApplyFilter;

  const FilterBroadcastDialog({
    super.key,
    required this.initialKategori,
    required this.kategoriList,
    required this.onApplyFilter,
  });

  @override
  State<FilterBroadcastDialog> createState() => _FilterBroadcastDialogState();
}

class _FilterBroadcastDialogState extends State<FilterBroadcastDialog> {
  late String _selectedKategori;

  @override
  void initState() {
    super.initState();
    _selectedKategori = widget.initialKategori;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Broadcast'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: _selectedKategori,
            hint: const Text('Pilih Kategori'),
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
            items: ['Semua', ...widget.kategoriList].map((String kategori) {
              return DropdownMenuItem<String>(value: kategori, child: Text(kategori));
            }).toList(),
            onChanged: (String? newValue) {
              setState(() => _selectedKategori = newValue!);
            },
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal')),
        TextButton(
          onPressed: () {
            widget.onApplyFilter(_selectedKategori);
            Navigator.of(context).pop();
          },
          child: const Text('Terapkan'),
        ),
      ],
    );
  }
}