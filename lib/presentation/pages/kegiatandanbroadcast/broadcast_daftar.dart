import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jawara/core/models/broadcast_models.dart';
import 'package:jawara/core/repositories/broadcast_repository.dart';

@RoutePage()
class BroadcastDaftarPage extends StatefulWidget {
  const BroadcastDaftarPage({super.key});

  @override
  State<BroadcastDaftarPage> createState() => _BroadcastDaftarPageState();
}

class _BroadcastDaftarPageState extends State<BroadcastDaftarPage> {
  final BroadcastRepository broadcastRepo = BroadcastRepository();
  final TextEditingController _searchController = TextEditingController();

  String _selectedFilter = 'Semua';
  List<String> _availableCategories = [];

  @override
  void initState() {
    super.initState();
    // listener hanya melakukan setState() untuk memicu rebuild ketika user mengetik
    _searchController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onFilterChanged(String? newValue) {
    if (newValue == null) return;
    setState(() {
      _selectedFilter = newValue;
    });
  }

  Future<void> _deleteItem(BroadcastModels item) async {
    try {
      await broadcastRepo.deleteBroadcast(item.docId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Broadcast berhasil dihapus")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menghapus: $e")),
        );
      }
    }
  }

  String _getBulan(int bulan) {
    const namaBulan = [
      'Januari','Februari','Maret','April','Mei','Juni',
      'Juli','Agustus','September','Oktober','November','Desember'
    ];
    if (bulan < 1 || bulan > 12) return '';
    return namaBulan[bulan - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<List<BroadcastModels>>(
        stream: broadcastRepo.getBroadcasts(),
        builder: (context, snapshot) {
          // loading / error / no data handling
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          }
          final allData = snapshot.data ?? [];

          // --- HITUNG FILTER & SEARCH SECARA LOKAL (tanpa setState) ---
          List<BroadcastModels> filtered = allData;

          // filter kategori (jika bukan "Semua")
          if (_selectedFilter != 'Semua') {
            filtered = filtered.where((b) {
              final cat = (b.kategoriBroadcast ?? '').toString();
              return cat == _selectedFilter;
            }).toList();
          }

          // search keyword
          final keyword = _searchController.text.trim().toLowerCase();
          if (keyword.isNotEmpty) {
            filtered = filtered.where((b) {
              final judul = (b.judulBroadcast ?? '').toLowerCase();
              final kategori = (b.kategoriBroadcast ?? '').toLowerCase();
              return judul.contains(keyword) || kategori.contains(keyword);
            }).toList();
          }

          // kategori list untuk dropdown (ambil unique dari allData)
          final kategoriSet = <String>{};
          for (var b in allData) {
            final k = (b.kategoriBroadcast ?? '').toString();
            if (k.isNotEmpty) kategoriSet.add(k);
          }
          final kategoriList = ['Semua', ...kategoriSet];

          return Column(
            children: [
              const SizedBox(height: 12),

              // Search input
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: "Cari broadcast...",
                    border: InputBorder.none,
                  ),
                ),
              ),

              // jumlah hasil
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  "${filtered.length} data ditemukan",
                  style: const TextStyle(color: Colors.grey),
                ),
              ),

              // list
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text("Tidak ada hasil"))
                    : ListView.builder(
                        itemCount: filtered.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (_, i) => _buildDataCard(filtered[i]),
                      ),
              ),

              const SizedBox(height: 8),
              // dropdown kategori
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: DropdownButton<String>(
                  value: kategoriList.contains(_selectedFilter) ? _selectedFilter : 'Semua',
                  items: kategoriList.map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  )).toList(),
                  onChanged: _onFilterChanged,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDataCard(BroadcastModels item) {
    final judul = item.judulBroadcast ?? '';
    final kategori = item.kategoriBroadcast ?? '';
    final tanggal = item.tanggalPublikasi;

    String tanggalText = 'Tanggal tidak tersedia';
    if (tanggal != null) {
      tanggalText =
          "${tanggal.day} ${_getBulan(tanggal.month)} ${tanggal.year}";
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          // konten
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(judul,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                const SizedBox(height: 6),
                Text("Kategori: $kategori", style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 6),
                Text(tanggalText, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),

          PopupMenuButton(
            itemBuilder: (_) => const [
              PopupMenuItem(value: "detail", child: Text("Lihat Detail")),
              PopupMenuItem(value: "edit", child: Text("Edit")),
              PopupMenuItem(value: "hapus", child: Text("Hapus")),
            ],
            onSelected: (value) {
              if (value == "hapus") {
                _deleteItem(item);
              } else if (value == "edit") {
                context.router.pushNamed('/kegiatandanbroadcast/broadcast_edit/${item.docId}');
              } else if (value == "detail") {
                context.router.pushNamed('/kegiatandanbroadcast/broadcast_detail/${item.docId}');
              }
            },
          ),
        ],
      ),
    );
  }
}