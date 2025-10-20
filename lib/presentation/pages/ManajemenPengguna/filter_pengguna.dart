import 'package:flutter/material.dart';

class FilterPengguna extends StatefulWidget {
  final Function(String nama, String? status) onFilter;

  const FilterPengguna({super.key, required this.onFilter});

  @override
  State<FilterPengguna> createState() => _FilterPenggunaState();
}

class _FilterPenggunaState extends State<FilterPengguna> {
  final TextEditingController _namaController = TextEditingController();
  String _selectedStatus = 'Semua';

  final List<String> statusList = [
    'Semua',
    'Diterima',
    'Diproses',
    'Ditolak',
  ];

  void _resetSemuaSetting() {
    setState(() {
      _namaController.clear();
      _selectedStatus = 'Semua';
    });
    widget.onFilter('', null);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =================== HEADER ===================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Data',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black54),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),

            const Divider(),

            const SizedBox(height: 8),

            // =================== STATUS ===================
            const Text(
              'Pilih Status',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 12),

            ...statusList.map(
              (status) => RadioListTile<String>(
                title: Text(status, style: const TextStyle(fontSize: 15)),
                value: status,
                groupValue: _selectedStatus,
                activeColor: Colors.deepPurple,
                contentPadding: EdgeInsets.zero,
                onChanged: (value) {
                  setState(() => _selectedStatus = value!);
                },
              ),
            ),

            const Divider(height: 32),

            // =================== TOMBOL AKSI ===================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Tombol RESET
                TextButton(
                  onPressed: _resetSemuaSetting,
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),

                // Tombol TERAPKAN
                ElevatedButton(
                  onPressed: () {
                    widget.onFilter(
                      _namaController.text,
                      _selectedStatus == 'Semua' ? null : _selectedStatus,
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Terapkan',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
