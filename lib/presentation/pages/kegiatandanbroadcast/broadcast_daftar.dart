import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jawara/core/models/broadcast_models.dart'; // pastikan path sesuai struktur project-mu

@RoutePage()
class BroadcastDaftarPage extends StatefulWidget {
  const BroadcastDaftarPage({super.key});

  @override
  State<BroadcastDaftarPage> createState() => _BroadcastDaftarPageState();
}

class _BroadcastDaftarPageState extends State<BroadcastDaftarPage> {
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
              : null,
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
              : null,
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

  // --- DIALOG UNTUK AKSI HAPUS ---
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

  // ### WIDGET BARU UNTUK DIALOG FILTER ###
  void _showFilterDialog(BuildContext context) {
    // Controller untuk field di dalam dialog
    final TextEditingController judulController = TextEditingController();
    DateTime? selectedDate; // Variabel untuk menyimpan tanggal

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        // StatefulBuilder agar UI di dalam dialog bisa di-update (khususnya tanggal)
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
                    // 1. Judul Dialog dan Tombol Close (X)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filter Broadcast', // Judul disesuaikan
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

                    // 2. Field "Judul Broadcast"
                    const Text('Judul Broadcast', style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: judulController,
                      decoration: InputDecoration(
                        hintText: 'Cari broadcast...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 3. Field "Tanggal Publikasi" (Custom Date Picker)
                    const Text('Tanggal Publikasi', style: TextStyle(fontWeight: FontWeight.w500)),
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
                          setDialogState(() { // Update state di dalam dialog
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
                                // Tombol Clear (X)
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
                                // Ikon Kalender
                                Icon(Icons.calendar_today, size: 20, color: Colors.grey.shade700),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // 4. Tombol Aksi (Reset & Terapkan)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Tombol Reset
                        ElevatedButton(
                          onPressed: () {
                            setDialogState(() {
                              judulController.clear();
                              selectedDate = null;
                            });
                            // TODO: Panggil fungsi reset filter di halaman utama
                            print('Filter Direset');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade200,
                            foregroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                          ),
                          child: const Text('Reset Filter'),
                        ),
                        // Tombol Terapkan
                        ElevatedButton(
                          onPressed: () {
                            // TODO: Panggil fungsi terapkan filter di halaman utama
                            final String judul = judulController.text;
                            print('Filter Diterapkan: Judul=$judul, Tanggal=$selectedDate');
                            Navigator.of(ctx).pop(); // Tutup dialog
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
  
  // --- Widget utama ---
  @override
  Widget build(BuildContext context) {
    // Logika untuk memotong data sesuai halaman
    final int startIndex = (_currentPage - 1) * _rowsPerPage;
    final int endIndex = (startIndex + _rowsPerPage > dummyBroadcast.length)
        ? dummyBroadcast.length
        : startIndex + _rowsPerPage;
    final List<BroadcastModels> paginatedData =
        dummyBroadcast.sublist(startIndex, endIndex);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- Card Container ---
            Card(
              color: Colors.white,
              elevation: 2,
              shadowColor: Colors.black12,
              // ### PERBAIKAN ERROR TYPO DI SINI ###
              shape: RoundedRectangleBorder( // Sebelumnya: RoundedRectangleBord.er
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ### PERUBAHAN TOMBOL TAMBAH MENJADI FILTER ###
                    Align(
                      alignment: Alignment.centerLeft, // Diubah dari .center
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Memanggil dialog filter
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
                    // ### AKHIR PERUBAHAN ###

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
                            DataColumn(label: Text('JUDUL BROADCAST', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF6B7280)))),
                            DataColumn(label: Text('ISI PESAN', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF6B7280)))),
                            DataColumn(label: Text('TANGGAL PUBLIKASI', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF6B7280)))),
                            DataColumn(label: Text('AKSI', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF6B7280)))),
                          ],
                          rows: paginatedData.map((item) {
                            final itemNumber =
                                startIndex + paginatedData.indexOf(item) + 1;
                            return DataRow(
                              cells: [
                                DataCell(Text(itemNumber.toString())),
                                DataCell(Text(item.judulBroadcast)),
                                DataCell(
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      item.isiPesan,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '${item.tanggalPublikasi.day.toString().padLeft(2, '0')} '
                                    '${_getBulan(item.tanggalPublikasi.month)} '
                                    '${item.tanggalPublikasi.year}',
                                  ),
                                ),
                                
                                // Kolom Aksi (Popup Menu)
                                DataCell(
                                  PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert, color: Colors.black54),
                                    onSelected: (String value) {
                                      if (value == 'detail') {
                                        context.router.pushNamed(
                                          '/kegiatandanbroadcast/broadcast_detail/${item.id}',
                                        );
                                      } else if (value == 'edit') {
                                        context.router.pushNamed(
                                          '/kegiatandanbroadcast/broadcast_edit/${item.id}',
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
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPagination(dummyBroadcast.length),
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