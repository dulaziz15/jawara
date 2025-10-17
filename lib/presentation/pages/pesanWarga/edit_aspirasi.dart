import 'package:flutter/material.dart';
// Sesuaikan import ini
import 'aspirasi.dart'; 

class EditAspirasiPage extends StatefulWidget {
  final AspirationData item;

  const EditAspirasiPage({super.key, required this.item});

  @override
  State<EditAspirasiPage> createState() => _EditAspirasiPageState();
}

class _EditAspirasiPageState extends State<EditAspirasiPage> {
  late TextEditingController _judulController;
  late TextEditingController _pengirimController;
  late TextEditingController _tanggalController;
  late TextEditingController _deskripsiController; 
  String _status = '';

  // Menggunakan opsi status dari screenshot (Diterima, Pending, Diproses, Selesai)
  final List<String> _statusOptions = ['Diterima', 'Pending', 'Diproses', 'Selesai']; 

  @override
  void initState() {
    super.initState();
    // Inisialisasi Controller
    _judulController = TextEditingController(text: widget.item.judul);
    _pengirimController = TextEditingController(text: widget.item.pengirim);
    _tanggalController = TextEditingController(text: widget.item.tanggal);
    _deskripsiController = TextEditingController(text: widget.item.deskripsi); 
    
    // Inisialisasi Status. Jika status item tidak ada di _statusOptions, pakai Pending.
    _status = _statusOptions.contains(widget.item.status) ? widget.item.status : 'Pending'; 
  }

  @override
  void dispose() {
    _judulController.dispose();
    _pengirimController.dispose();
    _tanggalController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  // FUNGSI INI HANYA MELAKUKAN NAVIGASI KEMBALI
  void _saveChanges() {
    Navigator.pop(context); 
  }

  // Gaya Input yang sangat sederhana
  InputDecoration _simpleInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(), // Border standar
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Informasi Aspirasi Warga'), // Sesuai screenshot
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white), 
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul Pesan
            const Text('Judul Pesan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _judulController,
              decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
            ),
            
            const SizedBox(height: 20),
            
            // Deskripsi Pesan
            const Text('Deskripsi Pesan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _deskripsiController,
              maxLines: 4,
              minLines: 2,
              decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
            ),

            const SizedBox(height: 20),
            
            // Status
            const Text('Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _status,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 5), // Sesuaikan padding
                isDense: true,
              ),
              items: _statusOptions
                  .map(
                    (s) => DropdownMenuItem(
                      value: s,
                      child: Text(s),
                    ),
                  )
                  .toList(),
              onChanged: (val) => setState(() => _status = val ?? _status),
            ),
            
            const SizedBox(height: 30),
            
            // Tombol Update
            ElevatedButton(
              onPressed: _saveChanges, // Hanya navigasi kembali
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 4,
              ),
              child: const Text(
                'Update',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}