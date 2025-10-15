import 'package:flutter/material.dart';

class FilterPenerimaanWargaDialog extends StatelessWidget {
  const FilterPenerimaanWargaDialog({super.key});

  final List<String> statusRegistrasiOptions = const [
    '-- Pilih Status --', // Sesuai gambar
    'Diterima',
    'Pending',
    'Ditolak',
  ];

  final List<String> jenisKelaminOptions = const [
    '-- Pilih Jenis Kelamin --', // Sesuai gambar
    'Laki-laki', // Diubah dari 'Laki-laki (L)'
    'Perempuan', // Diubah dari 'Perempuan (P)'
  ];

  @override
  Widget build(BuildContext context) {
    // Variabel untuk warna utama (Deep Purple)
    const Color primaryColor = Colors.deepPurple;

    return Dialog(
      // Batasi lebar dialog agar tidak terlalu lebar pada layar desktop
      // Lebar maksimal dialog diatur agar konten tidak terlalu renggang
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400), 
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Header Dialog ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filter Penerimaan Warga',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20), // Jarak setelah header

                // --- Bagian Nama (Text Field) ---
                const Text('Nama', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Cari nama...', // Sesuai gambar
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                    ),
                    // Style focus border agar berwarna biru
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: primaryColor, width: 2), // Garis biru tebal saat fokus
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
                const SizedBox(height: 20),

                // --- Bagian Jenis Kelamin (Dropdown) ---
                const Text('Jenis Kelamin', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                    ),
                    // Style focus border agar berwarna biru
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: primaryColor, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  value: jenisKelaminOptions.first,
                  isExpanded: true,
                  items: jenisKelaminOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    // Logika ketika Jenis Kelamin dipilih
                  },
                ),
                const SizedBox(height: 20),

                // --- Bagian Status (Dropdown) ---
                const Text('Status', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                    ),
                    // Style focus border agar berwarna biru
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(color: primaryColor, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  value: statusRegistrasiOptions.first,
                  isExpanded: true,
                  items: statusRegistrasiOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    // Logika ketika status dipilih
                  },
                ),
                const SizedBox(height: 40),

                // --- Tombol Aksi (Reset Filter dan Terapkan) ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Jarakkan kedua tombol
                  children: [
                    // Tombol Reset Filter
                    OutlinedButton(
                      onPressed: () {
                        // Logika Reset Filter
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.grey.shade300),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        minimumSize: const Size(120, 48), // Menentukan ukuran minimum tombol
                      ),
                      child: const Text('Reset Filter', style: TextStyle(color: Colors.black54)),
                    ),

                    // Tombol Terapkan
                    ElevatedButton(
                      onPressed: () {
                        // Logika Terapkan Filter
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor, // Warna ungu
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        minimumSize: const Size(120, 48), // Menentukan ukuran minimum tombol
                      ),
                      child: const Text('Terapkan', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}