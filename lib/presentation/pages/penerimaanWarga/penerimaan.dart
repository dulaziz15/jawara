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
      if (_currentPage > _totalPages) _currentPage = _totalPages;

      final startIndex = (_currentPage - 1) * _itemsPerPage;
      final endIndex = (_currentPage * _itemsPerPage).clamp(0, _filteredData.length);

      _currentPageData = _filteredData.sublist(startIndex, endIndex);
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'diterima':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _showDetail(RegistrationData item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(item.nama),
        content: Text("NIK: ${item.nik}\nEmail: ${item.email}"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Penerimaan Warga")),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6C63FF),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => FilterPenerimaanWargaDialog(
              initialStatus: _selectedFilter,
              onApplyFilter: _applyFilter,
            ),
          );
        },
        child: const Icon(Icons.filter_list),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: const InputDecoration(
                hintText: 'Cari Nama/NIK...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _currentPageData.length,
              itemBuilder: (_, index) {
                final d = _currentPageData[index];
                return ListTile(
                  leading: CircleAvatar(backgroundImage: AssetImage(d.fotoIdentitasAsset)),
                  title: Text(d.nama),
                  subtitle: Text("NIK: ${d.nik}"),
                  trailing: Chip(
                    label: Text(d.statusRegistrasi),
                    backgroundColor: _getStatusColor(d.statusRegistrasi),
                  ),
                  onTap: () => _showDetail(d),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
