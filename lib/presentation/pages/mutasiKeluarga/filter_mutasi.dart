// filter_mutasi.dart
import 'package:flutter/material.dart';
import '../../../core/models/mutasi_model.dart';

class FilterMutasiKeluargaDialog extends StatefulWidget {
  final String initialJenisMutasi;
  final Function(String) onApplyFilter;

  const FilterMutasiKeluargaDialog({
    super.key,
    required this.initialJenisMutasi,
    required this.onApplyFilter,
  });

  @override
  State<FilterMutasiKeluargaDialog> createState() =>
      _FilterMutasiKeluargaDialogState();
}

class _FilterMutasiKeluargaDialogState
    extends State<FilterMutasiKeluargaDialog> {
  String? _selectedJenisMutasi;
  final List<String> jenisMutasiOptions = const [
    'Pindah Domisili',
    'Pindah Kota',
    'Pindah Provinsi',
    'Pindah Negara',
  ];

  @override
  void initState() {
    super.initState();
    _selectedJenisMutasi = widget.initialJenisMutasi;
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
                  'Filter Data',
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

            // Pilih Jenis Mutasi
            const Text(
              'Pilih Jenis Mutasi',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            // Daftar Jenis Mutasi
            Column(
              children: jenisMutasiOptions.map((jenis) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedJenisMutasi = jenis;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Radio<String>(
                          value: jenis,
                          groupValue: _selectedJenisMutasi,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedJenisMutasi = value;
                            });
                          },
                          activeColor: const Color(0xFF6C63FF),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            jenis,
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
                    if (_selectedJenisMutasi != null) {
                      widget.onApplyFilter(_selectedJenisMutasi!);
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
