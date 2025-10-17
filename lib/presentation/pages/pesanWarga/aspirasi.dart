import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'filter.dart';
import 'edit_aspirasi.dart';
import 'delete_aspirasi.dart';
import 'detail_aspirasi.dart';

class AspirationData {
  final int no;
  final String pengirim;
  final String judul;
  final String deskripsi;
  final String tanggal;
  final String status;

  const AspirationData({
    required this.no,
    required this.pengirim,
    required this.judul,
    required this.deskripsi,
    required this.tanggal,
    required this.status,
  });
}

@RoutePage()
class AspirasiPage extends StatefulWidget {
  const AspirasiPage({super.key});

  @override
  State<AspirasiPage> createState() => _AspirasiPageState();
}

class _AspirasiPageState extends State<AspirasiPage>
    with TickerProviderStateMixin {
  final List<AspirationData> _data = [
    const AspirationData(
      no: 1,
      pengirim: 'Habibie Ed Dien',
      judul: 'Tes aspirasi pertama',
      deskripsi:
          'Aku adalah anak gembala, selalu riang serta gembira karena rajin membaca',
      tanggal: '10-10-2025',
      status: 'Pending',
    ),
    const AspirationData(
      no: 2,
      pengirim: 'Budi Santoso',
      judul: 'Lampu Jalan di Blok A Mati',
      deskripsi:
          'Kalau ada sembilan nyawa mau sama mu saja semuanya ini dada isinya kamu semua',
      tanggal: '11-10-2025',
      status: 'Diproses',
    ),
    const AspirationData(
      no: 3,
      pengirim: 'Siti Aisyah',
      judul: 'Masalah Kebersihan Selokan',
      deskripsi:
          'If the sun refuse to shine, would I still be in love with you?',
      tanggal: '12-10-2025',
      status: 'Selesai',
    ),
    const AspirationData(
      no: 4,
      pengirim: 'Joko Widodo',
      judul: 'Perlu Perbaikan Jembatan Kecil',
      deskripsi:
          'Antara aku, kamu, dan samudra kita berbagi tawa dan bahagia tak kenal siang dan malam',
      tanggal: '13-10-2025',
      status: 'Pending',
    ),
    const AspirationData(
      no: 5,
      pengirim: 'Megawati Soekarno',
      judul: 'Polinema Jos Jos Jos',
      deskripsi: 'Eufbebfwiefbiabcoebfuwe',
      tanggal: '14-10-2025',
      status: 'Diproses',
    ),
  ];

  int? _expandedIndex;
  final ScrollController _scrollController = ScrollController();

  // --- Widget Badge Status ---
  Widget statusBadge(String status) {
    final color = switch (status.toLowerCase()) {
      'pending' => Colors.yellow.shade200,
      'diproses' => Colors.blue.shade200,
      'selesai' => Colors.green.shade200,
      _ => Colors.grey.shade300,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }

  // --- Widget Data Row ---
  Widget _dataRow(AspirationData item, int index) {
    final isExpanded = index == _expandedIndex;

    return Column(
      children: [
        // Header Row
        InkWell(
          onTap: () =>
              setState(() => _expandedIndex = isExpanded ? null : index),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                SizedBox(width: 40, child: Text(item.no.toString())),
                Expanded(
                  child: Text(
                    item.pengirim,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.deepPurple,
                ),
              ],
            ),
          ),
        ),

        // Detail Row
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: isExpanded
              ? Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Judul
                          Text(
                            item.judul,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Tanggal
                          Text(
                            'Tanggal: ${item.tanggal}',
                            style: const TextStyle(color: Colors.black54),
                          ),
                          const SizedBox(height: 4),
                          // Status
                          Row(
                            children: [
                              const Text(
                                'Status: ',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              statusBadge(item.status),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Popup Menu (titik tiga) di kanan atas
                    Positioned(
                      top: 0,
                      right: 0,
                      child: PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.deepPurple,
                        ),
                        onSelected: (value) {
                          switch (value) {
                            case 'detail':
                              showDetailModal(context, item);
                              break;
                            case 'edit':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditAspirasiPage(item: item),
                                ),
                              );
                              break;
                            case 'delete':
                              showDeleteConfirmation(context, item);
                              break;
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'detail', child: Text('Detail')),
                          PopupMenuItem(value: 'edit', child: Text('Edit')),
                          PopupMenuItem(value: 'delete', child: Text('Hapus')),
                        ],
                      ),
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ),

        if (index < _data.length - 1)
          Divider(height: 1, color: Colors.grey.shade300),
      ],
    );
  }

  // --- Widget Pagination ---
  Widget _pagination() {
    final int itemsPerPage = 5;
    final int totalPages = (_data.length / itemsPerPage).ceil();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_left)),
          const SizedBox(width: 8),
          for (int i = 1; i <= totalPages; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$i',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          const SizedBox(width: 8),
          IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_right)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header + Filter
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daftar Aspirasi Warga',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const FilterPesanWargaDialog(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Icon(Icons.filter_list, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tabel Container
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header Tabel
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: const Row(
                      children: [
                        SizedBox(
                          width: 40,
                          child: Text(
                            'NO',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'PENGIRIM',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                        SizedBox(width: 40),
                      ],
                    ),
                  ),

                  // Data Rows scrollable
                  SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: List.generate(
                        _data.length,
                        (index) => _dataRow(_data[index], index),
                      ),
                    ),
                  ),

                  // Pagination langsung di bawah tabel
                  _pagination(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
