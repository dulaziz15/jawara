import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
// Pastikan path import ini benar menunjuk ke file di mana KegiatanModel didefinisikan
import 'package:jawara/core/models/kegiatan_models.dart';

@RoutePage()
class KegiatanDaftarPage extends StatefulWidget {
  const KegiatanDaftarPage({super.key});

  @override
  State<KegiatanDaftarPage> createState() => _KegiatanDaftarPageState();
}

class _KegiatanDaftarPageState extends State<KegiatanDaftarPage> {
  // --- State untuk pagination ---
  int _currentPage = 1;
  final int _rowsPerPage = 10;

  // --- Helper format bulan ---
  String _getBulan(int bulan) {
    const namaBulan = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli',
      'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return namaBulan[bulan - 1];
  }

  // --- Widget Pagination Dinamis ---
  Widget _buildPagination(int totalItems) {
    final int totalPages = (totalItems / _rowsPerPage).ceil();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Tombol Halaman Sebelumnya
        IconButton(
          onPressed: _currentPage > 1
              ? () {
                  setState(() {
                    _currentPage--;
                  });
                }
              : null, // Nonaktifkan jika di halaman pertama
          icon: const Icon(Icons.chevron_left),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: Colors.grey, width: 0.5),
            disabledBackgroundColor: Colors.grey.shade200,
          ),
        ),
        const SizedBox(width: 16),
        // Teks penunjuk halaman
        Text(
          'Halaman $_currentPage dari $totalPages',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 16),
        // Tombol Halaman Berikutnya
        IconButton(
          onPressed: _currentPage < totalPages
              ? () {
                  setState(() {
                    _currentPage++;
                  });
                }
              : null, // Nonaktifkan jika di halaman terakhir
          icon: const Icon(Icons.chevron_right),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: Colors.grey, width: 0.5),
            disabledBackgroundColor: Colors.grey.shade200,
          ),
        ),
      ],
    );
  }

  // --- CONTOH DIALOG UNTUK AKSI HAPUS KEGIATAN ---
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
              onPressed: () {
                Navigator.of(ctx).pop(); // Tutup dialog
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                // TODO: logika hapus data di sini
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

  // --- WIDGET UNTUK DIALOG FILTER KEGIATAN ---
  void _showFilterDialog(BuildContext context) {
    final TextEditingController namaController = TextEditingController();
    DateTime? selectedDate;
    String? selectedKategori;

    final List<String> kategoriList =
        dummyPengeluaran.map((e) => e.kategoriKegiatan).toSet().toList();

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filter Kegiatan',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(ctx).pop(),
                          splashRadius: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Field "Nama Kegiatan"
                    const Text('Nama Kegiatan', style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: namaController,
                      decoration: InputDecoration(
                        hintText: 'Cari kegiatan...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Field "Tanggal Pelaksanaan"
                    const Text('Tanggal Pelaksanaan', style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null && picked != selectedDate) {
                          setDialogState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedDate == null
                                  ? '--/--/----'
                                  : '${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}',
                            ),
                            Row(
                              children: [
                                if (selectedDate != null)
                                  InkWell(
                                    onTap: () {
                                      setDialogState(() {
                                        selectedDate = null;
                                      });
                                    },
                                    child: const Icon(Icons.close, size: 20, color: Colors.grey),
                                  ),
                                if (selectedDate != null) const SizedBox(width: 8),
                                Icon(Icons.calendar_today, size: 20, color: Colors.grey.shade700),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Field "Kategori"
                    const Text('Kategori', style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedKategori,
                      hint: const Text('-- Pilih Kategori --'),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                      items: kategoriList.map((String kategori) {
                        return DropdownMenuItem<String>(
                          value: kategori,
                          child: Text(kategori),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setDialogState(() {
                          selectedKategori = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    // Tombol Aksi (Reset & Terapkan)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setDialogState(() {
                              namaController.clear();
                              selectedDate = null;
                              selectedKategori = null;
                            });
                            print('Filter Direset');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade200,
                            foregroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                          ),
                          child: const Text('Reset Filter'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final String nama = namaController.text;
                            print('Filter Diterapkan: Nama=$nama, Tanggal=$selectedDate, Kategori=$selectedKategori');
                            Navigator.of(ctx).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                          ),
                          child: const Text('Terapkan'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // --- Logika untuk memotong data sesuai halaman ---
    final int startIndex = (_currentPage - 1) * _rowsPerPage;
    final int endIndex = (startIndex + _rowsPerPage > dummyPengeluaran.length)
        ? dummyPengeluaran.length
        : startIndex + _rowsPerPage;
    final List<KegiatanModel> paginatedData =
        dummyPengeluaran.sublist(startIndex, endIndex);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              color: Colors.white,
              elevation: 2,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Tombol Filter
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showFilterDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          icon: const Icon(Icons.filter_list, size: 20),
                          label: const Text('Filter'),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 40,
                          headingRowColor: WidgetStateProperty.all(
                            const Color(0xFFF9FAFB),
                          ),
                          border: TableBorder.symmetric(
                            inside: const BorderSide(
                              color: Color(0xFFE5E7EB),
                              width: 1,
                            ),
                          ),
                          columns: const [
                            DataColumn(label: Text('NO', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF6B7280)))),
                            DataColumn(label: Text('NAMA KEGIATAN', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF6B7280)))),
                            DataColumn(label: Text('KATEGORI', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF6B7280)))),
                            DataColumn(label: Text('PENANGGUNG JAWAB', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF6B7280)))),
                            DataColumn(label: Text('TANGGAL PELAKSANAAN', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF6B7280)))),
                            DataColumn(label: Text('AKSI', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF6B7280)))),
                          ],
                          rows: paginatedData.map((item) {
                            final itemNumber =
                                startIndex + paginatedData.indexOf(item) + 1;
                            return DataRow(
                              cells: [
                                DataCell(Text(itemNumber.toString())),
                                DataCell(Text(item.namaKegiatan)),
                                DataCell(
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      item.kategoriKegiatan,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(Text(item.penanggungJawab)),
                                DataCell(
                                  Text(
                                    '${item.tanggalPelaksanaan.day.toString().padLeft(2, '0')} '
                                    '${_getBulan(item.tanggalPelaksanaan.month)} '
                                    '${item.tanggalPelaksanaan.year}',
                                  ),
                                ),
                                
                                // ### PERUBAHAN KOLOM AKSI (IconButton -> PopupMenuButton) ###
                                DataCell(
                                  PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert, color: Colors.black54),
                                    onSelected: (String value) {
                                      if (value == 'detail') {
                                        // 1. Aksi Lihat Detail
                                        context.router.pushNamed(
                                          '/kegiatandanbroadcast/kegiatan_detail/${item.id}',
                                        );
                                      } else if (value == 'edit') {
                                        // 2. Aksi Edit (TODO: Buat halaman edit)
                                        context.router.pushNamed(
                                          '/kegiatandanbroadcast/kegiatan_edit/${item.id}',
                                        );
                                      } else if (value == 'hapus') {
                                        // 3. Aksi Hapus (memanggil dialog)
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
                                ),
                                // ### AKHIR PERUBAHAN ###
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPagination(dummyPengeluaran.length),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}