import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jawara/core/models/kategori_iuran_models.dart';
// Pastikan path import repository sudah benar
import 'package:jawara/core/repositories/kategori_iuran_repository.dart';
import 'package:jawara/core/utils/formatter_util.dart';

// ============================================================================
// 1. DIALOG TAMBAH IURAN
// ============================================================================
class TambahIuranDialog extends StatefulWidget {
  final KategoriIuranRepository repository;

  const TambahIuranDialog({super.key, required this.repository});

  @override
  State<TambahIuranDialog> createState() => _TambahIuranDialogState();
}

class _TambahIuranDialogState extends State<TambahIuranDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  String? _selectedKategori;
  bool _isLoading = false;
  
  // List manual sesuai permintaan
  final List<String> manualKategoriList = [
    'Kebersihan',
    'Keamanan',
    'Sosial',
    'Operasional',
    'Lainnya',
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _jumlahController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final newKategoriIuranModel = KategoriIuranModel(
          docId: '', // ID otomatis dari Firebase
          namaIuran: _namaController.text,
          kategoriIuran: _selectedKategori!,
          jumlah: double.tryParse(_jumlahController.text) ?? 0.0,
        );

        // Panggil method addKategoriIuran di Repository
        await widget.repository.addKategoriIuran(newKategoriIuranModel);

        if (mounted) Navigator.of(context).pop();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Buat Iuran Baru'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: 'Nama Iuran'),
              validator: (value) => value!.isEmpty ? 'Nama iuran tidak boleh kosong' : null,
            ),
            TextFormField(
              controller: _jumlahController,
              decoration: const InputDecoration(labelText: 'Jumlah'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) return 'Jumlah tidak boleh kosong';
                if (double.tryParse(value) == null) return 'Jumlah harus angka';
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedKategori,
              decoration: const InputDecoration(labelText: 'Kategori Iuran'),
              items: manualKategoriList.map((kategori) {
                return DropdownMenuItem(value: kategori, child: Text(kategori));
              }).toList(),
              onChanged: (value) => setState(() => _selectedKategori = value),
              validator: (value) => value == null ? 'Pilih kategori' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal')),
        ElevatedButton(
          onPressed: _isLoading ? null : _save,
          child: _isLoading
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Simpan'),
        ),
      ],
    );
  }
}

// ============================================================================
// 2. DIALOG EDIT IURAN
// ============================================================================
class EditIuranDialog extends StatefulWidget {
  final KategoriIuranModel item;
  final KategoriIuranRepository repository;

  const EditIuranDialog({
    super.key,
    required this.item,
    required this.repository,
  });

  @override
  State<EditIuranDialog> createState() => _EditIuranDialogState();
}

class _EditIuranDialogState extends State<EditIuranDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _jumlahController;
  late String _kategori;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.item.namaIuran);
    _jumlahController = TextEditingController(text: widget.item.jumlah.toStringAsFixed(0));
    _kategori = widget.item.kategoriIuran;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _jumlahController.dispose();
    super.dispose();
  }

  Future<void> _update() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final updatedIuran = KategoriIuranModel(
          docId: widget.item.docId,
          namaIuran: _namaController.text,
          kategoriIuran: _kategori,
          jumlah: double.tryParse(_jumlahController.text) ?? 0.0,
        );

        // Panggil method updateKategoriIuran di Repository
        await widget.repository.updateKategoriIuran(updatedIuran);
        
        if (mounted) Navigator.of(context).pop();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal update: $e')));
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Iuran'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: 'Nama Iuran'),
              validator: (value) => value!.isEmpty ? 'Nama iuran tidak boleh kosong' : null,
            ),
            TextFormField(
              controller: _jumlahController,
              decoration: const InputDecoration(labelText: 'Jumlah'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) return 'Jumlah tidak boleh kosong';
                if (double.tryParse(value) == null) return 'Jumlah harus angka';
                return null;
              },
            ),
            TextFormField(
              initialValue: _kategori,
              decoration: const InputDecoration(labelText: 'Kategori Iuran'),
              readOnly: true,
              enabled: false,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal')),
        ElevatedButton(
          onPressed: _isLoading ? null : _update,
          child: const Text('Update'),
        ),
      ],
    );
  }
}

// ============================================================================
// 3. HALAMAN UTAMA
// ============================================================================
@RoutePage()
class KategoriIuranPage extends StatefulWidget {
  const KategoriIuranPage({super.key});

  @override
  State<KategoriIuranPage> createState() => _KategoriIuranPageState();
}

class _KategoriIuranPageState extends State<KategoriIuranPage> {
  final KategoriIuranRepository _repository = KategoriIuranRepository();

  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Semua';
  String _searchQuery = '';

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value.toLowerCase();
    });
  }

  List<KategoriIuranModel> _applyFilters(List<KategoriIuranModel> allData) {
    return allData.where((data) {
      final matchKategori = _selectedFilter == 'Semua' || data.kategoriIuran == _selectedFilter;
      final matchSearch = _searchQuery.isEmpty ||
          data.namaIuran.toLowerCase().contains(_searchQuery) ||
          data.kategoriIuran.toLowerCase().contains(_searchQuery);

      return matchKategori && matchSearch;
    }).toList();
  }

  void _showFilterDialog(List<String> availableKategoris) {
    showDialog(
      context: context,
      builder: (context) => FilterIuranDialog(
        initialKategori: _selectedFilter,
        kategoriList: availableKategoris,
        onApplyFilter: (kategori) {
          setState(() => _selectedFilter = kategori);
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, KategoriIuranModel item) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus iuran "${item.namaIuran}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                try {
                  // Panggil method deleteKategoriIuran di Repository
                  await _repository.deleteKategoriIuran(item.docId);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Data berhasil dihapus')),
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
      body: StreamBuilder<List<KategoriIuranModel>>(
        // Gunakan stream yang sudah mengembalikan List Model
        stream: _repository.getKategoriIuranStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final allData = snapshot.data ?? [];
          final filteredData = _applyFilters(allData);
          final uniqueCategories = allData.map((e) => e.kategoriIuran).toSet().toList();

          return Column(
            children: [
              // Search & Filter
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
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
                          hintText: 'Cari nama atau kategori...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.filter_list,
                        color: _selectedFilter == 'Semua' ? Colors.grey : const Color(0xFF6C63FF),
                      ),
                      onPressed: () => _showFilterDialog(uniqueCategories),
                    ),
                  ],
                ),
              ),
              
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  '${filteredData.length} data ditemukan' + (_selectedFilter != 'Semua' ? ' (Filter: $_selectedFilter)' : ''),
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
                          return _buildDataCard(item, index + 1);
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => TambahIuranDialog(repository: _repository),
          );
        },
        backgroundColor: const Color(0xFF6C63FF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildDataCard(KategoriIuranModel item, int no) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
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
                      Row(
                        children: [
                          Text(
                            '$no.',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.namaIuran,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('Kategori: ${item.kategoriIuran}', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text('Nominal: Rp ${FormatterUtil.formatCurrency(item.jumlah)}', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.black54),
                  onSelected: (String value) {
                    if (value == 'edit') {
                      showDialog(
                        context: context,
                        builder: (context) => EditIuranDialog(item: item, repository: _repository),
                      );
                    } else if (value == 'hapus') {
                      _showDeleteConfirmationDialog(context, item);
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(value: 'edit', child: Row(children: [Icon(Icons.edit_outlined, color: Colors.green, size: 20), SizedBox(width: 10), Text('Edit')])),
                    const PopupMenuItem<String>(value: 'hapus', child: Row(children: [Icon(Icons.delete_outline, color: Colors.red, size: 20), SizedBox(width: 10), Text('Hapus')])),
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

// ============================================================================
// 4. DIALOG FILTER (TIDAK PERLU DIUBAH)
// ============================================================================
class FilterIuranDialog extends StatefulWidget {
  final String initialKategori;
  final List<String> kategoriList;
  final Function(String) onApplyFilter;

  const FilterIuranDialog({super.key, required this.initialKategori, required this.kategoriList, required this.onApplyFilter});

  @override
  State<FilterIuranDialog> createState() => _FilterIuranDialogState();
}

class _FilterIuranDialogState extends State<FilterIuranDialog> {
  late String _selectedKategori;

  @override
  void initState() {
    super.initState();
    _selectedKategori = widget.initialKategori;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Iuran'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: _selectedKategori,
            hint: const Text('Pilih Kategori'),
            decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0))),
            items: ['Semua', ...widget.kategoriList].map((String kategori) {
              return DropdownMenuItem<String>(value: kategori, child: Text(kategori));
            }).toList(),
            onChanged: (String? newValue) => setState(() => _selectedKategori = newValue!),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal')),
        TextButton(onPressed: () { widget.onApplyFilter(_selectedKategori); Navigator.of(context).pop(); }, child: const Text('Terapkan')),
      ],
    );
  }
}