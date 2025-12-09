import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
// Ganti import ini dengan path routing Anda yang benar
import 'package:jawara/core/models/tagihan_model.dart';
import 'package:jawara/core/repositories/tagihan_repository.dart';
import 'package:jawara/core/utils/formatter_util.dart';
import 'package:jawara/core/routes/app_router.dart';



@RoutePage()
class TagihanDaftarPage extends StatefulWidget {
  const TagihanDaftarPage({super.key});

  @override
  State<TagihanDaftarPage> createState() => _TagihanDaftarPageState();
}

class _TagihanDaftarPageState extends State<TagihanDaftarPage> {
  final TagihanRepository _repository = TagihanRepository();
  
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Semua';

  // --- LOGIC FILTER DATA (SAFE MODE) ---
  List<TagihanModel> _processData(List<TagihanModel> allData) {
    if (allData.isEmpty) return [];

    return allData.where((data) {
      // 1. Filter Kategori
      bool matchKategori = _selectedFilter == 'Semua' || data.kategori == _selectedFilter;

      // 2. Filter Search (Safe Null Check)
      String query = _searchController.text.toLowerCase();
      
      // Pastikan field tidak null sebelum toLowerCase()
      String namaIuran = (data.namaIuran ?? '').toLowerCase();
      String namaWarga = (data.namaWarga ?? '').toLowerCase();
      String kategori = (data.kategori ?? '').toLowerCase();

      bool matchSearch = query.isEmpty ||
          namaIuran.contains(query) ||
          namaWarga.contains(query) ||
          kategori.contains(query);

      return matchKategori && matchSearch;
    }).toList();
  }

  void _showFilterDialog(List<String> kategoriList) {
    showDialog(
      context: context,
      builder: (context) => FilterTagihanDialog(
        initialKategori: _selectedFilter,
        kategoriList: kategoriList,
        onApplyFilter: (val) {
          setState(() {
            _selectedFilter = val;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // StreamBuilder memanggil Repository
      body: StreamBuilder<List<TagihanModel>>(
        stream: _repository.getTagihanWithWargaStream(), 
        builder: (context, snapshot) {
          // 1. Handle Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          // 2. Handle Error
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          // 3. Ambil Data
          final allData = snapshot.data ?? [];
          final filteredData = _processData(allData);
          
          // Ambil kategori unik untuk filter
          final uniqueCategories = allData.map((e) => e.kategori).toSet().toList();

          return Column(
            children: [
              // --- SEARCH BAR ---
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
                        onChanged: (v) => setState(() {}), 
                        decoration: const InputDecoration(
                          hintText: 'Cari nama iuran atau warga...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // --- INFO JUMLAH DATA ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  '${filteredData.length} data ditemukan' + 
                  (_selectedFilter != 'Semua' ? ' (Filter: $_selectedFilter)' : ''),
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),

              // --- LIST DATA ---
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
      
      // Floating Action Button untuk Filter
      floatingActionButton: StreamBuilder<List<TagihanModel>>(
        stream: _repository.getTagihanWithWargaStream(),
        builder: (context, snapshot) {
          // Ambil kategori hanya jika data tersedia
          final categories = (snapshot.data ?? []).map((e) => e.kategori).toSet().toList();
          return FloatingActionButton(
            onPressed: () => _showFilterDialog(categories),
            backgroundColor: const Color(0xFF6C63FF),
            child: const Icon(Icons.filter_list, color: Colors.white),
          );
        }
      ),
    );
  }

  Widget _buildDataCard(TagihanModel item) {
    // Logic warna status (Safe check)
    bool isLunas = (item.status ?? '').toLowerCase() == 'lunas' || 
                   (item.status ?? '').toLowerCase() == 'paid';
                   
    Color statusColor = isLunas ? Colors.green.shade100 : Colors.red.shade100;
    String statusText = isLunas ? 'Lunas' : 'Belum Lunas';

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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // NAVIGASI KE HALAMAN DETAIL
            // Pastikan Anda sudah menjalankan: dart run build_runner build
            context.router.push(TagihanDetailRoute(tagihanId: item.docId ?? ''));
          },
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
                            item.namaIuran, 
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Kategori: ${item.kategori}', 
                            style: const TextStyle(color: Colors.grey, fontSize: 14)
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Nominal: Rp ${FormatterUtil.formatCurrency(item.nominal)}', 
                            style: const TextStyle(color: Colors.grey, fontSize: 14)
                          ),
                          const SizedBox(height: 8),
                          
                          // Tampilkan Nama Warga (Hasil Join)
                          Row(
                            children: [
                              const Icon(Icons.person, size: 16, color: Colors.blueGrey),
                              const SizedBox(width: 4),
                              Text(
                                item.namaWarga, 
                                style: const TextStyle(
                                  color: Colors.black87, 
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor, 
                            borderRadius: BorderRadius.circular(6)
                          ),
                          child: Text(
                            statusText, 
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ... (FilterTagihanDialog tetap sama seperti kode Anda)
class FilterTagihanDialog extends StatefulWidget {
  final String initialKategori;
  final List<String> kategoriList;
  final Function(String) onApplyFilter;

  const FilterTagihanDialog({
    super.key,
    required this.initialKategori,
    required this.kategoriList,
    required this.onApplyFilter,
  });

  @override
  State<FilterTagihanDialog> createState() => _FilterTagihanDialogState();
}

class _FilterTagihanDialogState extends State<FilterTagihanDialog> {
  late String _selectedKategori;

  @override
  void initState() {
    super.initState();
    _selectedKategori = widget.initialKategori;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Tagihan'),
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