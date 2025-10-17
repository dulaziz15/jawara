import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/core/models/kegiatan_models.dart';

@RoutePage()
class KegiatanDaftarPage extends StatelessWidget {
  const KegiatanDaftarPage({super.key});
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

// --- Widget Pagination ---
  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.chevron_left),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: const Text(
            '1',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.chevron_right),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
      ],
    );
  }  
  @override
  Widget build(BuildContext context) {
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: ElevatedButton(
                          onPressed: () {
                            // nanti bisa diisi aksi tambah broadcast
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            padding: const EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            minimumSize: const Size(60, 50),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
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
                          dataRowColor: WidgetStateProperty.all(Colors.white),
                          border: TableBorder.symmetric(
                            inside: const BorderSide(
                              color: Color(0xFFE5E7EB),
                              width: 1,
                            ),
                          ),
                          columns: const [
                            DataColumn(
                              label: Text(
                                'NO',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'NAMA KEGIATAN',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'KATEGORI',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'PENANGGUNG JAWAB',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'TANGGAL PELAKSANAAN',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ),
                            // column aksi lihat detail
                            DataColumn(
                              label: Text(
                                'AKSI',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ),
  
                          ],
                          rows: dummyPengeluaran
                              .map(
                                (item) => DataRow(
                                  cells: [
                                    DataCell(Text(item.id.toString())),
                                    DataCell(Text(item.namaKegiatan)),
                                    DataCell(SizedBox(
                                      width: 200,
                                      child: Text(
                                        item.kategoriKegiatan,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )),
                                    DataCell(Text(item.penanggungJawab)),
                                    DataCell(Text(
                                      '${item.tanggalPelaksanaan.day.toString().padLeft(2, '0')} '
                                      '${_getBulan(item.tanggalPelaksanaan.month)} '
                                      '${item.tanggalPelaksanaan.year}',
                                    )),
                                    // DataCell(Text(item.dibuatOleh)),
                                    // DataCell(Row(
                                    //   children: [
                                    //     const Icon(Icons.image, size: 16, color: Colors.blueAccent),
                                    //     const SizedBox(width: 4),
                                    //     Text(item.lampiranGambar,
                                    //         style: const TextStyle(fontSize: 12)),
                                    //   ],
                                    // )),
                                    // DataCell(Row(
                                    //   children: [
                                    //     const Icon(Icons.picture_as_pdf, size: 16, color: Colors.redAccent),
                                    //     const SizedBox(width: 4),
                                    //     Text(item.lampiranDokumen,
                                    //         style: const TextStyle(fontSize: 12)),
                                    //   ],
                                    // )),
                                    DataCell(
                                      IconButton(
                                        icon: const Icon(
                                          Icons.visibility,
                                          color: Colors.deepPurple,
                                        ),
                                        onPressed: () {
                                          // aksi lihat detail broadcast
                                        },
                                      ),
                                    ),
                                    
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPagination(),
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