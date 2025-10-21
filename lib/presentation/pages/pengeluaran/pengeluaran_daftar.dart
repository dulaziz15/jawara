import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jawara/core/models/pengeluaran_model.dart'; // pastikan path sesuai struktur project-mu

@RoutePage()
class PengeluaranDaftarPage extends StatefulWidget {
  const PengeluaranDaftarPage({super.key});

  @override
  State<PengeluaranDaftarPage> createState() => _PengeluaranDaftarPageState();
}

class _PengeluaranDaftarPageState extends State<PengeluaranDaftarPage> {
  List<PengeluaranModel> _filteredData = dummyPengeluaran;
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Semua';

  @override
  void initState() {
    super.initState();
    _filteredData = dummyPengeluaran;
  }

  void _applyFilter(String kategori) {
    setState(() {
      _selectedFilter = kategori;
      List<PengeluaranModel> kategoriFilteredData;
      if (kategori == 'Semua') {
        kategoriFilteredData = dummyPengeluaran;
      } else {
        kategoriFilteredData = dummyPengeluaran
            .where((data) => data.kategoriPengeluaran == kategori)
            .toList();
      }
      if (_searchController.text.isNotEmpty) {
        _filteredData = kategoriFilteredData
            .where(
              (data) =>
                  data.namaPengeluaran.toLowerCase().contains(
                    _searchController.text.toLowerCase(),
                  ) ||
                  data.kategoriPengeluaran.toLowerCase().contains(
                    _searchController.text.toLowerCase(),
                  ),
            )
            .toList();
      } else {
        _filteredData = kategoriFilteredData;
      }
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      List<PengeluaranModel> searchFilteredData;
      if (value.isEmpty) {
        searchFilteredData = dummyPengeluaran;
      } else {
        searchFilteredData = dummyPengeluaran
            .where(
              (data) =>
                  data.namaPengeluaran.toLowerCase().contains(
                    value.toLowerCase(),
                  ) ||
                  data.kategoriPengeluaran.toLowerCase().contains(
                    value.toLowerCase(),
                  ),
            )
            .toList();
      }
      if (_selectedFilter != 'Semua') {
        _filteredData = searchFilteredData
            .where((data) => data.kategoriPengeluaran == _selectedFilter)
            .toList();
      } else {
        _filteredData = searchFilteredData;
      }
    });
  }

  void _showFilterDialog() {
    final List<String> kategoriList = dummyPengeluaran
        .map((e) => e.kategoriPengeluaran)
        .toSet()
        .toList();
    showDialog(
      context: context,
      builder: (context) => FilterPengeluaranDialog(
        initialKategori: _selectedFilter,
        kategoriList: kategoriList,
        onApplyFilter: _applyFilter,
      ),
    );
  }

  // --- Widget untuk menampilkan badge status verifikasi ---
  Widget _buildVerifikasiBadge(DateTime tanggalTerverifikasi) {
    final now = DateTime.now();
    final diff = now.difference(tanggalTerverifikasi).inDays;

    String status;
    Color backgroundColor;

    if (diff < 2) {
      status = 'Baru Diverifikasi';
      backgroundColor = Colors.green.shade200;
    } else {
      status = 'Terverifikasi';
      backgroundColor = Colors.blue.shade200;
    }

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

  // --- Helper format bulan ---
  String _getBulan(int bulan) {
    const namaBulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return namaBulan[bulan - 1];
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

          // Jumlah data ditemukan
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              '${_filteredData.length} data ditemukan',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),

          // List Data
          Expanded(
            child: _filteredData.isEmpty
                ? Center(
                    child: Text(
                      'Data tidak ditemukan',
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredData.length,
                    itemBuilder: (context, index) {
                      final item = _filteredData[index];
                      return _buildDataCard(item);
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
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Jumlah: Rp ${item.jumlahPengeluaran.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Verifikator: ${item.verifikator}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tanggal: ${item.tanggalPengeluaran.day.toString().padLeft(2, '0')} ${_getBulan(item.tanggalPengeluaran.month)} ${item.tanggalPengeluaran.year}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
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
                          context.router.pushNamed(
                            '/pengeluaran/detail/${item.id}',
                          );
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
