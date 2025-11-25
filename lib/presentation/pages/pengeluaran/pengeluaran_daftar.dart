import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jawara/core/models/pengeluaran_model.dart';
import 'package:jawara/core/repositories/pengeluaran_repository.dart'; 

@RoutePage()
class PengeluaranDaftarPage extends StatefulWidget {
  const PengeluaranDaftarPage({super.key});

  @override
  State<PengeluaranDaftarPage> createState() => _PengeluaranDaftarPageState();
}

class _PengeluaranDaftarPageState extends State<PengeluaranDaftarPage> {
  // 1. Inisialisasi Repository
  final PengeluaranRepository _repository = PengeluaranRepository();
  
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Semua';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 2. Fungsi Filter Lokal (Dijalankan setiap kali data stream masuk atau user mengetik)
  List<PengeluaranModel> _filterList(List<PengeluaranModel> allData) {
    return allData.where((data) {
      // Filter Kategori
      final matchKategori = _selectedFilter == 'Semua' || 
                            data.kategoriPengeluaran == _selectedFilter;
      
      // Filter Search
      final query = _searchController.text.toLowerCase();
      final matchSearch = query.isEmpty ||
          data.namaPengeluaran.toLowerCase().contains(query) ||
          data.kategoriPengeluaran.toLowerCase().contains(query);

      return matchKategori && matchSearch;
    }).toList();
  }

  void _onSearchChanged(String value) {
    setState(() {
      // Cukup panggil setState agar UI merebuild dan memanggil _filterList ulang
    });
  }

  void _showFilterDialog(List<PengeluaranModel> currentData) {
    // Ambil daftar kategori unik dari data yang ada di Firebase saat ini
    final List<String> kategoriList = currentData
        .map((e) => e.kategoriPengeluaran)
        .toSet()
        .toList();

    showDialog(
      context: context,
      builder: (context) => FilterPengeluaranDialog(
        initialKategori: _selectedFilter,
        kategoriList: kategoriList,
        onApplyFilter: (kategori) {
          setState(() {
            _selectedFilter = kategori;
          });
        },
      ),
    );
  }

  // ... (Widget _buildVerifikasiBadge dan _getBulan sama seperti sebelumnya) ...
  Widget _buildVerifikasiBadge(DateTime tanggalTerverifikasi) {
    final now = DateTime.now();
    final diff = now.difference(tanggalTerverifikasi).inDays;
    String status = diff < 2 ? 'Baru Diverifikasi' : 'Terverifikasi';
    Color backgroundColor = diff < 2 ? Colors.green.shade200 : Colors.blue.shade200;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }

  String _getBulan(int bulan) {
    const namaBulan = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 
                       'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
    return namaBulan[bulan - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 3. Gunakan StreamBuilder
      body: StreamBuilder<List<PengeluaranModel>>(
        stream: _repository.getPengeluaran(),
        builder: (context, snapshot) {
          // A. Handle Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // B. Handle Error
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // C. Ambil Data
          final List<PengeluaranModel> allData = snapshot.data ?? [];
          
          // D. Terapkan Filter Lokal pada Data Stream
          final List<PengeluaranModel> filteredData = _filterList(allData);

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

              // Jumlah data ditemukan
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  '${filteredData.length} data ditemukan',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),

              // List Data
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
      floatingActionButton: StreamBuilder<List<PengeluaranModel>>(
        // Kita butuh stream lagi atau simpan snapshot di parent untuk filter dialog
        // Agar efisien, kita gunakan tombol yang memanggil data saat diklik
        stream: _repository.getPengeluaran(), 
        builder: (context, snapshot) {
          final data = snapshot.data ?? [];
          return FloatingActionButton(
            onPressed: () => _showFilterDialog(data),
            backgroundColor: const Color(0xFF6C63FF),
            child: const Icon(Icons.filter_list, color: Colors.white),
          );
        }
      ),
    );
  }

  Widget _buildDataCard(PengeluaranModel item) {
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
                        item.namaPengeluaran,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Kategori: ${item.kategoriPengeluaran}',
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Jumlah: Rp ${item.jumlahPengeluaran.toStringAsFixed(0)}',
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        // Menggunakan Verifikator ID
                        'Verifikator ID: ${item.verifikatorId}', 
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tanggal: ${item.tanggalPengeluaran.day.toString().padLeft(2, '0')} ${_getBulan(item.tanggalPengeluaran.month)} ${item.tanggalPengeluaran.year}',
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    _buildVerifikasiBadge(item.tanggalTerverifikasi),
                    const SizedBox(height: 8),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'detail') {
                          // Pastikan route menerima parameter String ID
                          context.router.pushNamed(
                            '/pengeluaran/detail/${item.id}',
                          );
                        } else if (value == 'hapus') {
                          // Contoh implementasi hapus
                          if (item.id != null) {
                            _repository.deletePengeluaran(item.id! as String);
                          }
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'detail', child: Text('Detail')),
                        PopupMenuItem(value: 'hapus', child: Text('Hapus')),
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

// Dialog Filter Tetap Sama seperti kode awal Anda
class FilterPengeluaranDialog extends StatefulWidget {
  final String initialKategori;
  final List<String> kategoriList;
  final Function(String) onApplyFilter;

  const FilterPengeluaranDialog({
    super.key,
    required this.initialKategori,
    required this.kategoriList,
    required this.onApplyFilter,
  });

  @override
  State<FilterPengeluaranDialog> createState() =>
      _FilterPengeluaranDialogState();
}

class _FilterPengeluaranDialogState extends State<FilterPengeluaranDialog> {
  late String _selectedKategori;

  @override
  void initState() {
    super.initState();
    _selectedKategori = widget.initialKategori;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Pengeluaran'),
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