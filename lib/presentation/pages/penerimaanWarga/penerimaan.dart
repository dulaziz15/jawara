import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'filter_accept.dart';
import '../../../core/models/penerimaan_warga_model.dart';

@RoutePage()
class PenerimaanPage extends StatefulWidget {
  const PenerimaanPage({super.key});

  @override
  State<PenerimaanPage> createState() => _PenerimaanPageState();
}

class _PenerimaanPageState extends State<PenerimaanPage> {
  // --- BAGIAN BACKEND (TIDAK DIUBAH) ---
  List<RegistrationData> _filteredData = dummyRegistrationData;
  List<RegistrationData> _currentPageData = [];

  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Semua';

  // Pagination
  int _currentPage = 1;
  final int _itemsPerPage = 5;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _updatePagination();
  }

  void _updatePagination() {
    setState(() {
      _totalPages = (_filteredData.length / _itemsPerPage).ceil();
      if (_totalPages == 0) _totalPages = 1;

      if (_currentPage > _totalPages) _currentPage = _totalPages;

      final startIndex = (_currentPage - 1) * _itemsPerPage;
      final endIndex =
          (_currentPage * _itemsPerPage).clamp(0, _filteredData.length);

      if (startIndex < _filteredData.length) {
        _currentPageData = _filteredData.sublist(startIndex, endIndex);
      } else {
        _currentPageData = [];
      }
    });
  }

  void _applyFilter(String status) {
    setState(() {
      _selectedFilter = status;
      _currentPage = 1;

      if (status == 'Semua') {
        _filteredData = dummyRegistrationData;
      } else {
        _filteredData = dummyRegistrationData
            .where((d) => d.statusRegistrasi == status)
            .toList();
      }
      _updatePagination();
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _currentPage = 1;
      final keyword = value.toLowerCase();
      _filteredData = dummyRegistrationData.where((d) {
        return d.nama.toLowerCase().contains(keyword) ||
            d.nik.toLowerCase().contains(keyword);
      }).toList();

      if (_selectedFilter != 'Semua') {
        _filteredData = _filteredData
            .where((d) => d.statusRegistrasi == _selectedFilter)
            .toList();
      }

      _updatePagination();
    });
  }
  // --- AKHIR BAGIAN BACKEND ---

  // --- UI HELPER ---

  void _changePage(int newPage) {
    if (newPage >= 1 && newPage <= _totalPages) {
      setState(() {
        _currentPage = newPage;
        _updatePagination();
      });
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange[800]!;
      case 'diterima':
        return Colors.green[800]!;
      case 'ditolak':
        return Colors.red[800]!;
      default:
        return Colors.grey[800]!;
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange[50]!;
      case 'diterima':
        return Colors.green[50]!;
      case 'ditolak':
        return Colors.red[50]!;
      default:
        return Colors.grey[100]!;
    }
  }

  // PERBAIKAN DI SINI: Menggunakan dialogContext
  void _showDetail(RegistrationData item) {
    showDialog(
      context: context,
      // Ubah '_' menjadi 'dialogContext' agar spesifik
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Foto
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF6C63FF).withOpacity(0.7),
                          const Color(0xFF6C63FF)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(item.fotoIdentitasAsset),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),

              // Nama & Status
              Text(
                item.nama,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusBgColor(item.statusRegistrasi),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item.statusRegistrasi.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: _getStatusTextColor(item.statusRegistrasi),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),

              // Detail Info
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.credit_card, "NIK", item.nik),
                    const SizedBox(height: 15),
                    _buildInfoRow(Icons.email_outlined, "Email", item.email),
                  ],
                ),
              ),

              // Tombol Tutup
              Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    // PERBAIKAN: Gunakan Navigator.pop(dialogContext)
                    onPressed: () => Navigator.pop(dialogContext), 
                    child: const Text("Tutup"),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF6C63FF), size: 20),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              Text(value,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   centerTitle: true,
      //   title: const Text(
      //     "Penerimaan Warga",
      //     style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
      //   ),
      // ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF6C63FF),
        elevation: 4,
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => FilterPenerimaanWargaDialog(
              initialStatus: _selectedFilter,
              onApplyFilter: _applyFilter,
            ),
          );
        },
        icon: const Icon(Icons.filter_list, color: Colors.white),
        label: const Text("Filter", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Cari Nama atau NIK...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),

          // List Data
          Expanded(
            child: _currentPageData.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded,
                            size: 60, color: Colors.grey[300]),
                        const SizedBox(height: 10),
                        Text("Data tidak ditemukan",
                            style: TextStyle(color: Colors.grey[500])),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _currentPageData.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, index) {
                      final d = _currentPageData[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => _showDetail(d),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  // Avatar
                                  Hero(
                                    tag: d.nik,
                                    child: CircleAvatar(
                                      radius: 28,
                                      backgroundImage:
                                          AssetImage(d.fotoIdentitasAsset),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Text Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          d.nama,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "NIK: ${d.nik}",
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Status Badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _getStatusBgColor(
                                          d.statusRegistrasi),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      d.statusRegistrasi,
                                      style: TextStyle(
                                        color: _getStatusTextColor(
                                            d.statusRegistrasi),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Pagination Controls
          if (_totalPages > 1)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, -4),
                    blurRadius: 10,
                  )
                ],
              ),
              child: Row(
                // PERUBAHAN DISINI: Mengatur posisi ke tengah
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  IconButton(
                    onPressed: _currentPage > 1
                        ? () => _changePage(_currentPage - 1)
                        : null,
                    icon: Icon(Icons.chevron_left_rounded,
                        color: _currentPage > 1
                            ? Colors.black87
                            : Colors.grey[300]), // Ubah ke grey agar konsisten saat disable
                  ),
                  
                  // Jarak pemanis
                  const SizedBox(width: 16), 
                  
                  Text(
                    "Halaman $_currentPage dari $_totalPages",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),

                  // Jarak pemanis
                  const SizedBox(width: 16), 

                  IconButton(
                    onPressed: _currentPage < _totalPages
                        ? () => _changePage(_currentPage + 1)
                        : null,
                    icon: Icon(Icons.chevron_right_rounded,
                        color: _currentPage < _totalPages
                            ? Colors.black87
                            : Colors.grey[300]),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}