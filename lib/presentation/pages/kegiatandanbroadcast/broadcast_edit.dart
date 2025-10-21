import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/core/models/broadcast_models.dart';
// Import intl untuk format tanggal (opsional, tapi disarankan)
// import 'package:intl/intl.dart';

@RoutePage()
class BroadcastEditPage extends StatefulWidget {
  final int broadcastId;

  const BroadcastEditPage({
    super.key,
    @PathParam('id') required this.broadcastId,
  });

  @override
  State<BroadcastEditPage> createState() => _BroadcastEditPageState();
}

class _BroadcastEditPageState extends State<BroadcastEditPage> {
  // 2. Buat GlobalKey untuk Form dan Controllers
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _judulController;
  late TextEditingController _isiPesanController;
  late TextEditingController _dibuatOlehController;

  // Variabel untuk menyimpan data yang sedang diedit
  late BroadcastModels _broadcast;
  late DateTime _selectedDate;
  String _currentGambar = '';
  String _currentDokumen = '';

  @override
  void initState() {
    super.initState();
    // 3. Ambil data asli dan inisialisasi controller
    _broadcast = dummyBroadcast.firstWhere(
      (item) => item.id == widget.broadcastId,
    );

    _judulController = TextEditingController(text: _broadcast.judulBroadcast);
    _isiPesanController = TextEditingController(text: _broadcast.isiPesan);
    _dibuatOlehController = TextEditingController(text: _broadcast.dibuatOleh);
    _selectedDate = _broadcast.tanggalPublikasi;
    _currentGambar = _broadcast.lampiranGambar;
    _currentDokumen = _broadcast.lampiranDokumen;
  }

  @override
  void dispose() {
    // 4. Dispose controller untuk menghindari memory leaks
    _judulController.dispose();
    _isiPesanController.dispose();
    _dibuatOlehController.dispose();
    super.dispose();
  }

  // --- Helper format bulan (opsional, bisa diganti intl) ---
  String _formatTanggal(DateTime date) {
    // Gunakan 'intl' package untuk format yang lebih baik
    // return DateFormat('dd MMMM yyyy').format(date);
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  // --- Helper widget untuk TextFormField ---
  Widget _buildTextFormField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            maxLines: maxLines,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              filled: readOnly,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '$label tidak boleh kosong';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // --- Helper widget untuk Date Picker ---
  Widget _buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tanggal Publikasi',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (picked != null && picked != _selectedDate) {
                setState(() {
                  _selectedDate = picked;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatTanggal(_selectedDate)),
                  const Icon(
                    Icons.calendar_today,
                    size: 20,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper widget untuk File Picker (Stub) ---
  Widget _buildAttachmentPicker(
    String label,
    String currentFile,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(icon, color: Colors.deepPurple, size: 20),
                    const SizedBox(width: 8),
                    Text(currentFile.isEmpty ? "Tidak ada file" : currentFile),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Tambahkan logika file_picker di sini
                    // Contoh:
                    // FilePickerResult? result = await FilePicker.platform.pickFiles();
                    // if (result != null) {
                    //   setState(() {
                    //     if (label.contains("Gambar")) {
                    //       _currentGambar = result.files.single.name;
                    //     } else {
                    //       _currentDokumen = result.files.single.name;
                    //     }
                    //   });
                    // }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Logika ganti file belum diimplementasi.',
                        ),
                      ),
                    );
                  },
                  child: const Text("Ganti"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Logika untuk Simpan Perubahan ---
  void _saveChanges() {
    // 1. Validasi form
    if (_formKey.currentState!.validate()) {
      // 2. Ambil semua data dari controller
      final String updatedJudul = _judulController.text;
      final String updatedIsi = _isiPesanController.text;
      // ... ambil juga data file yang baru jika ada

      // 3. TODO: Implementasi logika penyimpanan data
      // Di aplikasi nyata, Anda akan panggil API atau update database di sini.
      // Untuk demo, kita print datanya:
      print('--- Data Disimpan ---');
      print('ID: ${widget.broadcastId}');
      print('Judul: $updatedJudul');
      print('Isi: $updatedIsi');
      print('Tanggal: $_selectedDate');
      print('Gambar: $_currentGambar');
      print('Dokumen: $_currentDokumen');
      print('--------------------');

      // 4. Tampilkan notifikasi sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Broadcast "$updatedJudul" berhasil diperbarui.'),
          backgroundColor: Colors.green,
        ),
      );

      // 5. Kembali ke halaman sebelumnya
      AutoRouter.of(context).pop();
    } else {
      // Jika validasi gagal, tampilkan pesan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap isi semua field yang wajib diisi.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.router.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Input Fields
                _buildTextFormField(
                  label: 'Judul Broadcast',
                  controller: _judulController,
                ),
                const SizedBox(height: 16),
                _buildTextFormField(
                  label: 'Isi Pesan',
                  controller: _isiPesanController,
                  maxLines: 5,
                ),
                const SizedBox(height: 16),
                _buildDatePicker(),
                const SizedBox(height: 16),
                _buildTextFormField(
                  label: 'Dibuat oleh',
                  controller: _dibuatOlehController,
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                const Divider(height: 24),

                // Lampiran
                _buildAttachmentPicker(
                  "Lampiran Gambar:",
                  _currentGambar,
                  Icons.image_outlined,
                ),
                const SizedBox(height: 16),
                _buildAttachmentPicker(
                  "Lampiran Dokumen:",
                  _currentDokumen,
                  Icons.description_outlined,
                ),

                const SizedBox(height: 24),

                // Tombol Simpan
                ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'Simpan Perubahan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
