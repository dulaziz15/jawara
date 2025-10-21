import 'package:flutter/material.dart';
import 'package:jawara/core/models/family_model.dart';

class WargaDaftarPage extends StatefulWidget {
  const WargaDaftarPage({super.key});

  @override
  State<WargaDaftarPage> createState() => _WargaDaftarPageState();
}

class _WargaDaftarPageState extends State<WargaDaftarPage> {
  final List<Family> _allFamilies = [
    Family(nik: '3505111512040002', name: 'Keluarga Rendha Putra Rahmadya'),
    Family(nik: '1234567890987654', name: 'Keluarga Anti Micin'),
    Family(nik: '137111101030005', name: 'Keluarga varizky naldiba rimra'),
    Family(nik: '1234567890123456', name: 'Keluarga Ijat'),
    Family(nik: '2025202520252025', name: 'Keluarga Ijat'),
    Family(nik: '3201122501050002', name: 'Keluarga Raudhli Firdaus Naufal'),
    Family(nik: '1234567891234567', name: 'Keluarga Habibie Ed Dien'),
    Family(nik: '1234567890123456', name: 'Keluarga Mara Nunez'),
    Family(nik: '2341123456756789', name: 'Keluarga Habibie Ed Dien'),
  ];

  List<Family> _filteredFamilies = [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Semua';

  @override
  void initState() {
    super.initState();
    _filteredFamilies = _allFamilies;
  }

  void _applyFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
      
      if (filter == 'Semua') {
        _filteredFamilies = _allFamilies;
      } else {
        _filteredFamilies = _allFamilies.where((family) {
          return family.name.toLowerCase().contains(filter.toLowerCase());
        }).toList();
      }
      
      // Apply search filter if there's search text
      if (_searchController.text.isNotEmpty) {
        _filteredFamilies = _filteredFamilies.where((family) {
          return family.nik.contains(_searchController.text) ||
                 family.name.toLowerCase().contains(_searchController.text.toLowerCase());
        }).toList();
      }
    });
  }

  void _showFilterDialog() {
    final uniqueNames = _allFamilies.map((f) => f.name).toSet().toList();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FilterBottomSheet(
          uniqueNames: uniqueNames,
          selectedFilter: _selectedFilter,
          onFilterApplied: _applyFilter,
          onReset: _resetFilters,
        );
      },
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedFilter = 'Semua';
      _searchController.clear();
      _filteredFamilies = _allFamilies;
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      if (value.isEmpty) {
        _filteredFamilies = _allFamilies;
      } else {
        _filteredFamilies = _allFamilies.where((family) {
          return family.nik.contains(value) ||
                 family.name.toLowerCase().contains(value.toLowerCase());
        }).toList();
      }
      
      // Apply category filter if selected
      if (_selectedFilter != 'Semua') {
        _filteredFamilies = _filteredFamilies.where((family) {
          return family.name == _selectedFilter;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Search and Filter Section
          _buildSearchFilterSection(),
          
          // Results Info
          _buildResultsInfo(),
          
          // Data Table
          _buildDataTable(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildSearchFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Cari berdasarkan NIK atau Nama...',
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Active Filter Chip
          if (_selectedFilter != 'Semua')
            Row(
              children: [
                Text(
                  'Filter aktif:',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(_selectedFilter),
                  backgroundColor: Colors.blue[50],
                  deleteIcon: Icon(Icons.close, size: 16),
                  onDeleted: _resetFilters,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildResultsInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_filteredFamilies.length} data ditemukan',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          if (_selectedFilter != 'Semua' || _searchController.text.isNotEmpty)
            GestureDetector(
              onTap: _resetFilters,
              child: Text(
                'Reset Filter',
                style: TextStyle(
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    return Expanded(
      child: _filteredFamilies.isEmpty
          ? _buildEmptyState()
          : Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Scrollbar(
                child: ListView.builder(
                  padding: const EdgeInsets.all(0),
                  itemCount: _filteredFamilies.length,
                  itemBuilder: (context, index) {
                    final family = _filteredFamilies[index];
                    return _buildFamilyItem(family, index);
                  },
                ),
              ),
            ),
    );
  }

  Widget _buildFamilyItem(Family family, int index) {
    return Container(
      decoration: BoxDecoration(
        border: index < _filteredFamilies.length - 1
            ? Border(
                bottom: BorderSide(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              )
            : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.blue[50],
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person,
            color: Colors.blue[700],
            size: 20,
          ),
        ),
        title: Text(
          family.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          'NIK: ${family.nik}',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.grey[400],
        ),
        onTap: () {
          // Handle item tap
          _showFamilyDetail(family);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Data tidak ditemukan',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coba ubah kata kunci atau reset filter',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _resetFilters,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Reset Filter',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _showFilterDialog,
      backgroundColor: Colors.blue[700],
      child: const Icon(Icons.filter_list, color: Colors.white),
    );
  }

  void _showFamilyDetail(Family family) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Detail Keluarga',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blue[700],
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem('NIK', family.nik),
            _buildDetailItem('Nama Keluarga', family.name),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('TUTUP'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  final List<String> uniqueNames;
  final String selectedFilter;
  final Function(String) onFilterApplied;
  final VoidCallback onReset;

  const FilterBottomSheet({
    super.key,
    required this.uniqueNames,
    required this.selectedFilter,
    required this.onFilterApplied,
    required this.onReset,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String _tempSelectedFilter = 'Semua';

  @override
  void initState() {
    super.initState();
    _tempSelectedFilter = widget.selectedFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Data',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pilih Keluarga',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // All Option
                  _buildFilterOption('Semua', _tempSelectedFilter == 'Semua'),

                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),

                  // Family Options
                  ...widget.uniqueNames.map((name) => 
                    _buildFilterOption(name, _tempSelectedFilter == name)
                  ).toList(),
                ],
              ),
            ),
          ),

          // Action Buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      widget.onReset();
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'RESET',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onFilterApplied(_tempSelectedFilter);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'TERAPKAN',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption(String name, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _tempSelectedFilter = name;
            });
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue[50] : Colors.transparent,
              border: Border.all(
                color: isSelected ? Colors.blue[700]! : Colors.grey[300]!,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: isSelected ? Colors.blue[700] : Colors.grey[400],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? Colors.blue[700] : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}