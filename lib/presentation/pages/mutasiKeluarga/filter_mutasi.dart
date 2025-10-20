import 'package:flutter/material.dart';

typedef ApplyFilterCallback = void Function(String newJenisMutasi);

class FilterMutasiKeluargaDialog extends StatefulWidget {
  final String initialJenisMutasi;
  final ApplyFilterCallback onApplyFilter;

  const FilterMutasiKeluargaDialog({
    super.key,
    required this.initialJenisMutasi,
    required this.onApplyFilter,
  });

  @override
  State<FilterMutasiKeluargaDialog> createState() => _FilterMutasiKeluargaDialogState();
}

class _FilterMutasiKeluargaDialogState extends State<FilterMutasiKeluargaDialog> {
  String? _selectedJenisMutasi;
  final List<String> jenisMutasiOptions = const [
    'Semua',
    'Pindah Domisili',
    'Pindah Kota',
    'Pindah Provinsi',
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
                    color: Color(0xFF4F6DF5),
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
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // Daftar Jenis Mutasi
            Column(
              children: jenisMutasiOptions.map((jenisMutasi) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedJenisMutasi = jenisMutasi;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Radio<String>(
                          value: jenisMutasi,
                          groupValue: _selectedJenisMutasi,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedJenisMutasi = value;
                            });
                          },
                          activeColor: const Color(0xFF4F6DF5),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            jenisMutasi,
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
                    setState(() {
                      _selectedJenisMutasi = 'Semua';
                    });
                    widget.onApplyFilter('Semua');
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'RESET',
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
                    backgroundColor: const Color(0xFF4F6DF5),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'TERAPKAN',
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