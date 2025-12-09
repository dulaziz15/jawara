import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../core/models/mutasi_model.dart';
import '../../../core/repositories/mutasi_repository.dart';
import 'filter_mutasi.dart';

@RoutePage()
class DaftarMutasiPage extends StatefulWidget {
  const DaftarMutasiPage({super.key});

  @override
  State<DaftarMutasiPage> createState() => _DaftarMutasiPageState();
}

class _DaftarMutasiPageState extends State<DaftarMutasiPage> {
  final TextEditingController _searchController = TextEditingController();
  final MutasiRepository _repo = MutasiRepository();

  late Stream<List<MutasiData>> _stream;

  List<MutasiData> _allData = [];
  List<MutasiData> _filteredData = [];
  List<MutasiData> _currentPageData = [];

  int _currentPage = 1;
  final int _itemsPerPage = 6;
  int _totalPages = 1;

  String _selectedFilter = 'Semua';

  @override
  void initState() {
    super.initState();
    // Buat stream dari collection mutasi; fallback ke dummy apabila kosong
    _stream = FirebaseFirestore.instance.collection('mutasi').snapshots().map(
      (snapshot) {
        if (snapshot.docs.isEmpty) {
          return MutasiDataProvider.dummyDataMutasi;
        }
        return snapshot.docs
            .map((doc) => MutasiData.fromMap(doc.data(), doc.id))
            .toList();
      },
    );
  }

  // Hitung pagination & current page data **tanpa** memanggil setState
  void _computePaginationNoSetState() {
    final safeData = _filteredData;
    final totalPages = (safeData.length / _itemsPerPage).ceil();
    final tPages = totalPages == 0 ? 1 : totalPages;
    var currentPage = _currentPage;
    if (currentPage > tPages) currentPage = tPages;

    final start = (currentPage - 1) * _itemsPerPage;
    var end = start + _itemsPerPage;
    if (end > safeData.length) end = safeData.length;

    // Update fields (we'll call setState once later)
    _totalPages = tPages;
    _currentPage = currentPage;
    _currentPageData = safeData.isEmpty ? [] : safeData.sublist(start, end);
  }

  // Public update method that will setState (call this outside build)
  void _updatePagination() {
    _computePaginationNoSetState();
    setState(() {});
  }

  void _applyFilter(String jenis) {
    // perubahan filter berasal dari UI (bukan di dalam build) => aman setState langsung
    setState(() {
      _selectedFilter = jenis;
      _currentPage = 1;

      List<MutasiData> d = jenis == 'Semua'
          ? _allData
          : _allData.where((e) => e.jenisMutasi == jenis).toList();

      final q = _searchController.text.trim().toLowerCase();
      if (q.isNotEmpty) {
        d = d
            .where((e) =>
                e.keluarga.toLowerCase().contains(q) ||
                e.jenisMutasi.toLowerCase().contains(q))
            .toList();
      }

      _filteredData = d;
      _computePaginationNoSetState(); // compute first
    });
  }

  void _onSearch(String v) {
    // onChanged dari TextField -> aman memanggil apply filter
    _applyFilter(_selectedFilter);
  }

  Color _badgeColor(String jenis) {
    switch (jenis.toLowerCase()) {
      case 'pindah domisili':
        return Colors.blue;
      case 'pindah kota':
        return Colors.green;
      case 'pindah provinsi':
        return Colors.orange;
      case 'pindah negara':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void _showDetail(MutasiData d) {
  showDialog(
    context: context,
    barrierDismissible: true, // Memungkinkan klik di luar untuk menutup
    builder: (c) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Detail Mutasi",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Badge Status dipindah ke dekat judul agar langsung terlihat
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _badgeColor(d.jenisMutasi).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: _badgeColor(d.jenisMutasi), width: 1),
                          ),
                          child: Text(
                            d.jenisMutasi,
                            style: TextStyle(
                              color: _badgeColor(d.jenisMutasi),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(c),
                    icon: Icon(Icons.close, color: Colors.grey[600]),
                    splashRadius: 20,
                  )
                ],
              ),
              const SizedBox(height: 20),
              const Divider(thickness: 1, height: 1),
              const SizedBox(height: 20),

              // --- CONTENT ---

              // 1. Informasi Keluarga
              _buildInfoRow(
                Icons.family_restroom_rounded,
                "Nama Keluarga",
                d.keluarga,
              ),
              const SizedBox(height: 16),

              // 2. Tanggal
              _buildInfoRow(
                Icons.calendar_today_rounded,
                "Tanggal Mutasi",
                d.tanggalMutasi,
              ),
              const SizedBox(height: 16),

              // 3. Alur Perpindahan (Visualisasi Dari -> Ke)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    _buildAddressRow(
                      Icons.location_off_outlined,
                      "Dari (Alamat Lama)",
                      d.alamatLama,
                      Colors.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          const SizedBox(width: 13), // Align arrow with icons
                          Icon(Icons.arrow_downward_rounded,
                              size: 18, color: Colors.blue[300]),
                        ],
                      ),
                    ),
                    _buildAddressRow(
                      Icons.location_on_rounded,
                      "Ke (Alamat Baru)",
                      d.alamatBaru,
                      Colors.blue,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 4. Alasan
              _buildInfoRow(
                Icons.note_alt_outlined,
                "Keterangan / Alasan",
                d.alasan.isNotEmpty ? d.alasan : "-",
              ),
              
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    ),
  );
}

// --- Helper Widgets untuk merapikan kode ---

// Widget untuk baris info standar
Widget _buildInfoRow(IconData icon, String label, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 20, color: Colors.grey[600]),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

// Widget khusus untuk alamat agar lebih rapi
Widget _buildAddressRow(IconData icon, String label, String value, Color iconColor) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 20, color: iconColor),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
  
  // Helper untuk menangani snapshot baru secara aman (tidak memanggil setState di build)
  void _handleNewSnapshot(List<MutasiData> incoming) {
    // bandingkan referensi atau panjang untuk mencegah loop tak berujung
    final bool different =
        _allData.length != incoming.length || !_listEqualsById(_allData, incoming);

    if (different) {
      // update internal lists first (tidak memanggil setState)
      _allData = incoming;
      // jika filtered masih kosong (pertama kali) gunakan allData, 
      // kalau ada filter gunakan filtered yang sudah ada dan lakukan filter ulang
      if (_filteredData.isEmpty) {
        _filteredData = _allData;
      } else {
        // apply currently selected filter/search to new data
        List<MutasiData> d = _selectedFilter == 'Semua'
            ? _allData
            : _allData.where((e) => e.jenisMutasi == _selectedFilter).toList();
        final q = _searchController.text.trim().toLowerCase();
        if (q.isNotEmpty) {
          d = d
              .where((e) =>
                  e.keluarga.toLowerCase().contains(q) ||
                  e.jenisMutasi.toLowerCase().contains(q))
              .toList();
        }
        _filteredData = d;
      }

      // compute pages without setState
      _computePaginationNoSetState();

      // schedule one setState after build finishes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {});
      });
    }
  }

  // simple id-based equality check
  bool _listEqualsById(List<MutasiData> a, List<MutasiData> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].docId != b[i].docId) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6C63FF),
        onPressed: () => showDialog(
          context: context,
          builder: (_) => FilterMutasiKeluargaDialog(
            initialJenisMutasi: _selectedFilter,
            onApplyFilter: _applyFilter,
          ),
        ),
        child: const Icon(Icons.filter_list, color: Colors.white),
      ),
      body: StreamBuilder<List<MutasiData>>(
        stream: _stream,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final incoming = snap.data!;

          // Jangan panggil setState langsung di sini.
          // Tangani snapshot baru secara aman:
          _handleNewSnapshot(incoming);

          return Column(
            children: [
              // SEARCH
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearch,
                        decoration: const InputDecoration(
                          hintText: "Cari keluarga atau jenis mutasi...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${_filteredData.length} data ditemukan",
                        style: const TextStyle(color: Colors.grey)),
                    if (_totalPages > 1)
                      Text("Halaman $_currentPage / $_totalPages",
                          style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),

              // LIST
              Expanded(
                child: _currentPageData.isEmpty
                    ? const Center(child: Text("Tidak ada data"))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _currentPageData.length,
                        itemBuilder: (context, i) {
                          final d = _currentPageData[i];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(d.keluarga,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text("Jenis Mutasi: ${d.jenisMutasi}",
                                          style: const TextStyle(color: Colors.grey))
                                    ]),
                                IconButton(
                                  icon: const Icon(Icons.info_outline),
                                  onPressed: () => _showDetail(d),
                                )
                              ],
                            ),
                          );
                        },
                      ),
              ),

              // PAGINATION
              if (_totalPages > 1)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _currentPage > 1
                            ? () {
                                setState(() => _currentPage--);
                                _updatePagination();
                              }
                            : null,
                        icon: const Icon(Icons.chevron_left),
                      ),
                      IconButton(
                        onPressed: _currentPage < _totalPages
                            ? () {
                                setState(() => _currentPage++);
                                _updatePagination();
                              }
                            : null,
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
