import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/core/models/kegiatan_models.dart';
import 'package:jawara/core/repositories/kegiatan_repository.dart'; // Pastikan import repo

@RoutePage()
class KegiatanDaftarPage extends StatefulWidget {
  const KegiatanDaftarPage({super.key});

  @override
  State<KegiatanDaftarPage> createState() => _KegiatanDaftarPageState();
}

class _KegiatanDaftarPageState extends State<KegiatanDaftarPage> {
  // 1. Panggil Repository
  final KegiatanRepository _repository = KegiatanRepository();
  
  // Controller & State Filter
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'Semua';

  // Menyimpan daftar kategori unik dari data yang dimuat (untuk Dialog Filter)
  List<String> _availableCategories = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Update state saat ketik search
  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  // Update state saat filter kategori dipilih
  void _applyFilter(String kategori) {
    setState(() {
      _selectedFilter = kategori;
    });
  }

  // Menampilkan Dialog Filter
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => FilterKegiatanDialog(
        initialKategori: _selectedFilter,
        kategoriList: _availableCategories, // Menggunakan kategori dari data asli
        onApplyFilter: _applyFilter,
      ),
    );
  }

  // --- Helper format bulan ---
  String _getBulan(int bulan) {
    const namaBulan = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli',
      'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return namaBulan[bulan - 1];
  }

  // --- LOGIKA HAPUS DENGAN FIREBASE ---
  void _showDeleteConfirmationDialog(BuildContext context, KegiatanModel item) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text(
              'Apakah Anda yakin ingin menghapus kegiatan "${item.namaKegiatan}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(ctx).pop(); // Tutup dialog dulu
                try {
                  // Panggil fungsi delete di repository
                  await _repository.deleteKegiatan(item.docId);
                  
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Kegiatan berhasil dihapus')),
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
                      hintText: 'Cari berdasarkan nama atau kategori...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. Gunakan StreamBuilder untuk data Realtime
          Expanded(
            child: StreamBuilder<List<KegiatanModel>>(
              stream: _repository.getKegiatan(),
              builder: (context, snapshot) {
                // A. Loading State
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // B. Error State
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                // C. Ambil Data
                List<KegiatanModel> allData = snapshot.data ?? [];

                // --- UPDATE KATEGORI UNTUK FILTER DIALOG ---
                // Kita ambil semua kategori unik dari data yang ada
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final categories = allData.map((e) => e.kategoriKegiatan).toSet().toList();
                  if (_availableCategories.length != categories.length) {
                     // Update hanya jika ada perubahan agar tidak loop setState
                     _availableCategories = categories;
                  }
                });

                // --- LOGIKA FILTER CLIENT-SIDE ---
                final filteredData = allData.where((item) {
                  // 1. Cek Filter Kategori
                  bool matchesCategory = _selectedFilter == 'Semua' || 
                                         item.kategoriKegiatan == _selectedFilter;
                  
                  // 2. Cek Search Query
                  bool matchesSearch = _searchQuery.isEmpty ||
                      item.namaKegiatan.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                      item.kategoriKegiatan.toLowerCase().contains(_searchQuery.toLowerCase());

                  return matchesCategory && matchesSearch;
                }).toList();


                // D. Tampilkan Data
                return Column(
                  children: [
                    // Jumlah data ditemukan
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
                                final item = filteredData[index];
                                return _buildDataCard(item);
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

  Widget _buildDataCard(KegiatanModel item) {
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
                        item.namaKegiatan,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Kategori: ${item.kategoriKegiatan}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Penanggung Jawab: ${item.penanggungJawabId}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tanggal: ${item.tanggalPelaksanaan.day.toString().padLeft(2, '0')} ${_getBulan(item.tanggalPelaksanaan.month)} ${item.tanggalPelaksanaan.year}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.black54),
                  onSelected: (String value) {
                    if (value == 'detail') {
                      context.router.pushNamed(
                        '/kegiatandanbroadcast/kegiatan_detail/${item.docId}',
                      );
                    } else if (value == 'edit') {
                      context.router.pushNamed(
                        '/kegiatandanbroadcast/kegiatan_edit/${item.docId}',
                      );
                    } else if (value == 'hapus') {
                      _showDeleteConfirmationDialog(context, item);
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'detail',
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Text('Detail'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'hapus',
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Text('Hapus'),
                        ],
                      ),
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

// === DIALOG FILTER (TETAP SAMA) ===
class FilterKegiatanDialog extends StatefulWidget {
  final String initialKategori;
  final List<String> kategoriList;
  final Function(String) onApplyFilter;

  const FilterKegiatanDialog({
    super.key,
    required this.initialKategori,
    required this.kategoriList,
    required this.onApplyFilter,
  });

  @override
  State<FilterKegiatanDialog> createState() => _FilterKegiatanDialogState();
}

class _FilterKegiatanDialogState extends State<FilterKegiatanDialog> {
  late String _selectedKategori;

  @override
  void initState() {
    super.initState();
    _selectedKategori = widget.initialKategori;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Kegiatan'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: _selectedKategori,
            hint: const Text('Pilih Kategori'),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            // Tambahkan 'Semua' manual + list dari parent
            items: ['Semua', ...widget.kategoriList].map((String kategori) {
              return DropdownMenuItem<String>(
                value: kategori,
                child: Text(kategori),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedKategori = newValue!;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
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