import 'package:flutter/material.dart';

typedef ApplyFilterCallback = void Function(String newStatus);

class FilterWargaDialog extends StatefulWidget {
  final String initialStatus;
  final ApplyFilterCallback onApplyFilter;

  const FilterWargaDialog({
    super.key,
    required this.initialStatus,
    required this.onApplyFilter,
  });

  @override
  State<FilterWargaDialog> createState() => _FilterWargaDialogState();
}

class _FilterWargaDialogState extends State<FilterWargaDialog> {
  String? _selectedStatus;
  final List<String> statusOptions = const [
    'Semua',
    'Domisili',
    'Non-Domisili',
    'Meninggal',
  ];

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.initialStatus == '-- Pilih Status --'
        ? 'Semua'
        : widget.initialStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Dialog
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Data Warga',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6C63FF),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(thickness: 1.2),
            const SizedBox(height: 16),

            // Pilih Status
            const Text(
              'Pilih Status Domisili',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            // Daftar Status
            Column(
              children: statusOptions.map((status) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedStatus = status;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Radio<String>(
                          value: status,
                          groupValue: _selectedStatus,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedStatus = value;
                            });
                          },
                          activeColor: const Color(0xFF6C63FF),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            status,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),
            const Divider(thickness: 1),
            const SizedBox(height: 20),

            // Tombol Reset & Terapkan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Reset Filter
                TextButton(
                  onPressed: () {
                    // Hanya terapkan filter 'Semua' tanpa mengubah state dialog
                    widget.onApplyFilter('Semua');
                    Navigator.of(context).pop();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: const BorderSide(color: Colors.grey),
                  ),
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),

                // Terapkan
                ElevatedButton(
                  onPressed: () {
                    if (_selectedStatus != null) {
                      widget.onApplyFilter(_selectedStatus!);
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Terapkan',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
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