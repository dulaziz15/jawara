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
      builder: (c) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Detail Mutasi Keluarga",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: () => Navigator.pop(c),
                    icon: const Icon(Icons.close),
                  )
                ],
              ),
              const Divider(),
              const SizedBox(height: 12),
              Text("Keluarga: ${d.keluarga}"),
              Text("Alamat Lama: ${d.alamatLama}"),
              Text("Alamat Baru: ${d.alamatBaru}"),
              Text("Tanggal Mutasi: ${d.tanggalMutasi}"),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: _badgeColor(d.jenisMutasi),
                ),
                child:
                    Text(d.jenisMutasi, style: const TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 8),
              Text("Alasan: ${d.alasan}"),
            ],
          ),
        ),
      ),
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
        child: const Icon(Icons.filter_list),
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
