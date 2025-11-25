import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jawara/core/models/iuran_model.dart';
import 'package:jawara/core/utils/formatter_util.dart';

// Dialog untuk Tambah Iuran
class TambahIuranDialog extends StatefulWidget {
  final Function(IuranModel) onSave;

  const TambahIuranDialog({super.key, required this.onSave});

  @override
  State<TambahIuranDialog> createState() => _TambahIuranDialogState();
}

class _TambahIuranDialogState extends State<TambahIuranDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  String _selectedKategori = '';

  @override
  void initState() {
    super.initState();
    // Set kategori default ke yang pertama jika ada
    final kategoriList = dummyIuran.map((e) => e.kategoriIuran).toSet().toList();
    if (kategoriList.isNotEmpty) {
      _selectedKategori = kategoriList.first;
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _jumlahController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final newIuran = IuranModel(
        id: (dummyIuran.map((e) => e.id ?? 0).reduce((a, b) => a > b ? a : b)) + 1,
        namaIuran: _namaController.text,
        kategoriIuran: _selectedKategori,
        verifikatorId: 1, // Default
        bukti: 'default_bukti.jpg', // Default
        jumlah: double.tryParse(_jumlahController.text) ?? 0.0,
        tanggalIuran: DateTime.now(),
        tanggalTerverifikasi: DateTime.now(),
      );
      widget.onSave(newIuran);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final kategoriList = dummyIuran.map((e) => e.kategoriIuran).toSet().toList();

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
            DropdownButtonFormField<String>(
              value: _selectedKategori,
              decoration: const InputDecoration(labelText: 'Kategori Iuran'),
              items: kategoriList.map((kategori) {
                return DropdownMenuItem(value: kategori, child: Text(kategori));
              }).toList(),
              onChanged: (value) => setState(() => _selectedKategori = value!),
              validator: (value) => value!.isEmpty ? 'Pilih kategori' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal')),
        ElevatedButton(onPressed: _save, child: const Text('Simpan')),
      ],
    );
  }
}

// Dialog untuk Edit Iuran
class EditIuranDialog extends StatefulWidget {
  final IuranModel item;
  final Function(IuranModel) onSave;

  const EditIuranDialog({super.key, required this.item, required this.onSave});

  @override
  State<EditIuranDialog> createState() => _EditIuranDialogState();
}

class _EditIuranDialogState extends State<EditIuranDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _jumlahController;
  late String _kategori;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.item.namaIuran);
    _jumlahController = TextEditingController(text: widget.item.jumlah.toString());
    _kategori = widget.item.kategoriIuran;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _jumlahController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final updatedIuran = IuranModel(
        id: widget.item.id,
        namaIuran: _namaController.text,
        kategoriIuran: _kategori, // Tidak bisa diedit
        verifikatorId: widget.item.verifikatorId,
        bukti: widget.item.bukti,
        jumlah: double.tryParse(_jumlahController.text) ?? 0.0,
        tanggalIuran: widget.item.tanggalIuran,
        tanggalTerverifikasi: widget.item.tanggalTerverifikasi,
      );
      widget.onSave(updatedIuran);
      Navigator.of(context).pop();
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
              readOnly: true, // Tidak bisa diedit
              enabled: false,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal')),
        ElevatedButton(onPressed: _save, child: const Text('Simpan')),
      ],
    );
  }
}

@RoutePage()
class KategoriIuranPage extends StatefulWidget {
  const KategoriIuranPage({super.key});

  @override
  State<KategoriIuranPage> createState() => _KategoriIuranPageState();
}

class _KategoriIuranPageState extends State<KategoriIuranPage> {
  List<IuranModel> _filteredData = dummyIuran;
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Semua';

  @override
  void initState() {
    super.initState();
    _filteredData = dummyIuran;
  }

  void _applyFilter(String kategori) {
    setState(() {
      _selectedFilter = kategori;
      List<IuranModel> kategoriFilteredData;
      if (kategori == 'Semua') {
        kategoriFilteredData = dummyIuran;
      } else {
        kategoriFilteredData = dummyIuran.where((data) => data.kategoriIuran == kategori).toList();
      }
      if (_searchController.text.isNotEmpty) {
        _filteredData = kategoriFilteredData
            .where((data) =>
                data.namaIuran.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                data.kategoriIuran.toLowerCase().contains(_searchController.text.toLowerCase()))
            .toList();
      } else {
        _filteredData = kategoriFilteredData;
      }
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      List<IuranModel> searchFilteredData;
      if (value.isEmpty) {
        searchFilteredData = dummyIuran;
      } else {
        searchFilteredData = dummyIuran
            .where((data) =>
                data.namaIuran.toLowerCase().contains(value.toLowerCase()) ||
                data.kategoriIuran.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
      if (_selectedFilter != 'Semua') {
        _filteredData = searchFilteredData.where((data) => data.kategoriIuran == _selectedFilter).toList();
      } else {
        _filteredData = searchFilteredData;
      }
    });
  }

  void _showFilterDialog() {
    final List<String> kategoriList = dummyIuran.map((e) => e.kategoriIuran).toSet().toList();
    showDialog(
      context: context,
      builder: (context) => FilterIuranDialog(
        initialKategori: _selectedFilter,
        kategoriList: kategoriList,
        onApplyFilter: _applyFilter,
      ),
    );
  }

  void _showTambahIuranDialog() {
    showDialog(
      context: context,
      builder: (context) => TambahIuranDialog(
        onSave: (newIuran) {
          setState(() {
            dummyIuran.add(newIuran);
            _applyFilter(_selectedFilter); // Refresh filter
          });
        },
      ),
    );
  }

  void _showEditIuranDialog(IuranModel item) {
    showDialog(
      context: context,
      builder: (context) => EditIuranDialog(
        item: item,
        onSave: (updatedIuran) {
          setState(() {
            final index = dummyIuran.indexWhere((i) => i.id == updatedIuran.id);
            if (index != -1) {
              dummyIuran[index] = updatedIuran;
              _applyFilter(_selectedFilter); // Refresh filter
            }
          });
        },
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

  

  // --- DIALOG UNTUK AKSI HAPUS ---
  void _showDeleteConfirmationDialog(BuildContext context, IuranModel item) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text(
              'Apakah Anda yakin ingin menghapus iuran "${item.namaIuran}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // Tutup dialog
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                // TODO: Tambahkan logika hapus data di sini
                print('Menghapus item ${item.id}');
                Navigator.of(ctx).pop(); // Tutup dialog
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
                      return _buildDataCard(item, index + 1);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTambahIuranDialog,
        backgroundColor: const Color(0xFF6C63FF),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildDataCard(IuranModel item, int no) {
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
                      Row(
                        children: [
                          Text(
                            '$no.',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.namaIuran,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Kategori: ${item.kategoriIuran}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Nominal: Rp ${FormatterUtil.formatCurrency(item.jumlah)}',
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
                      // TODO: Navigate to detail page
                      print('Navigate to detail for ${item.id}');
                    } else if (value == 'edit') {
                      _showEditIuranDialog(item);
                    } else if (value == 'hapus') {
                      _showDeleteConfirmationDialog(context, item);
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'detail',
                      child: Row(
                        children: [
                          Icon(Icons.visibility_outlined, color: Colors.blue, size: 20),
                          SizedBox(width: 10),
                          Text('Lihat Detail'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, color: Colors.green, size: 20),
                          SizedBox(width: 10),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'hapus',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, color: Colors.red, size: 20),
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

class FilterIuranDialog extends StatefulWidget {
  final String initialKategori;
  final List<String> kategoriList;
  final Function(String) onApplyFilter;

  const FilterIuranDialog({
    super.key,
    required this.initialKategori,
    required this.kategoriList,
    required this.onApplyFilter,
  });

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
