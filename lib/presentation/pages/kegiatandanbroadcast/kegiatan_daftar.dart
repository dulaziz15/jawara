import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/core/models/kegiatan_models.dart';
import 'package:jawara/core/repositories/kegiatan_repository.dart';

@RoutePage()
class KegiatanDaftarPage extends StatefulWidget {
  const KegiatanDaftarPage({super.key});

  @override
  State<KegiatanDaftarPage> createState() => _KegiatanDaftarPageState();
}

class _KegiatanDaftarPageState extends State<KegiatanDaftarPage> {
  final KegiatanRepository _repo = KegiatanRepository();
  final TextEditingController _searchController = TextEditingController();

  String _selectedFilter = 'Semua';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  void _applyFilter(String kategori) {
    setState(() {
      _selectedFilter = kategori;
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => StreamBuilder<List<KegiatanModel>>(
        stream: _repo.getKegiatan(),
        builder: (context, snapshot) {
          final kategoriList = snapshot.data
                  ?.map((e) => e.kategoriKegiatan)
                  .toSet()
                  .toList() ??
              [];

          return FilterKegiatanDialog(
            initialKategori: _selectedFilter,
            kategoriList: kategoriList,
            onApplyFilter: _applyFilter,
          );
        },
      ),
    );
  }

  String _getBulan(int bulan) {
    const namaBulan = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return namaBulan[bulan - 1];
  }

  void _showDeleteConfirmationDialog(BuildContext context, KegiatanModel item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus kegiatan "${item.namaKegiatan}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Batal')),
          TextButton(
            onPressed: () async {
              await _repo.deleteKegiatan(item.docId);
              Navigator.of(ctx).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<List<KegiatanModel>>(
        stream: _repo.getKegiatan(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          List<KegiatanModel> data = snapshot.data ?? [];

          // --- FILTER CATEGORY ---
          if (_selectedFilter != 'Semua') {
            data = data.where((d) => d.kategoriKegiatan == _selectedFilter).toList();
          }

          // --- FILTER SEARCH ---
          if (_searchController.text.isNotEmpty) {
            final search = _searchController.text.toLowerCase();
            data = data.where((d) =>
              d.namaKegiatan.toLowerCase().contains(search) ||
              d.kategoriKegiatan.toLowerCase().contains(search),
            ).toList();
          }

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

              // Jumlah data ditemukan
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  '${data.length} data ditemukan',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),

              // List Data
              Expanded(
                child: data.isEmpty
                    ? Center(child: Text('Data tidak ditemukan', style: TextStyle(color: Colors.grey.shade500)))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: data.length,
                        itemBuilder: (context, index) => _buildDataCard(data[index]),
                      ),
              ),
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

  Widget _buildDataCard(KegiatanModel item) {
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.namaKegiatan, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text('Kategori: ${item.kategoriKegiatan}', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('Penanggung Jawab: ${item.penanggungJawabId}', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(
                    'Tanggal: ${item.tanggalPelaksanaan.day.toString().padLeft(2, '0')} '
                    '${_getBulan(item.tanggalPelaksanaan.month)} '
                    '${item.tanggalPelaksanaan.year}',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.black54),
              onSelected: (value) {
                if (value == 'detail') {
                  context.router.pushNamed('/kegiatandanbroadcast/kegiatan_detail/${item.docId}');
                } else if (value == 'edit') {
                  context.router.pushNamed('/kegiatandanbroadcast/kegiatan_edit/${item.docId}');
                } else if (value == 'hapus') {
                  _showDeleteConfirmationDialog(context, item);
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'detail', child: Text('Detail')),
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'hapus', child: Text('Hapus')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


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
      content: DropdownButtonFormField<String>(
        value: _selectedKategori,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        items: ['Semua', ...widget.kategoriList]
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (v) => setState(() => _selectedKategori = v!),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
        TextButton(onPressed: () { widget.onApplyFilter(_selectedKategori); Navigator.pop(context); }, child: const Text('Terapkan')),
      ],
    );
  }
}
