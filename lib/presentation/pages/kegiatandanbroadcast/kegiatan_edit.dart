import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/core/models/kegiatan_models.dart';
import 'package:jawara/core/repositories/kegiatan_repository.dart';

@RoutePage()
class KegiatanEditPage extends StatefulWidget {
  final String kegiatanId;

  const KegiatanEditPage({
    super.key,
    @PathParam('id') required this.kegiatanId,
  });

  @override
  State<KegiatanEditPage> createState() => _KegiatanEditPageState();
}

class _KegiatanEditPageState extends State<KegiatanEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _repo = KegiatanRepository();

  late TextEditingController _namaKegiatanController;
  late TextEditingController _kategoriKegiatanController;
  late TextEditingController _penanggungJawabController;
  late TextEditingController _deskripsiController;
  late TextEditingController _lokasiController;
  late TextEditingController _dibuatOlehController;

  KegiatanModel? _kegiatan;
  bool _isLoading = true;
  late DateTime _selectedDate;
  String _currentDokumentasi = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  /// Ambil data kegiatan berdasarkan docId
  void _fetchData() async {
    final doc = await _repo.getKegiatan().first;
    _kegiatan = doc.firstWhere((e) => e.docId == widget.kegiatanId);

    _namaKegiatanController = TextEditingController(text: _kegiatan!.namaKegiatan);
    _kategoriKegiatanController = TextEditingController(text: _kegiatan!.kategoriKegiatan);
    _penanggungJawabController = TextEditingController(text: _kegiatan!.penanggungJawabId);
    _deskripsiController = TextEditingController(text: _kegiatan!.deskripsi);
    _lokasiController = TextEditingController(text: _kegiatan!.lokasi);
    _dibuatOlehController = TextEditingController(text: _kegiatan!.dibuatOlehId);
    _selectedDate = _kegiatan!.tanggalPelaksanaan.toDate();
    _currentDokumentasi = _kegiatan!.dokumentasi;

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _namaKegiatanController.dispose();
    _kategoriKegiatanController.dispose();
    _penanggungJawabController.dispose();
    _deskripsiController.dispose();
    _lokasiController.dispose();
    _dibuatOlehController.dispose();
    super.dispose();
  }

  String _formatTanggal(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

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
          Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade700)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            readOnly: readOnly,
            maxLines: maxLines,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              filled: readOnly,
              fillColor: Colors.grey.shade100,
            ),
            validator: (value) => value == null || value.isEmpty ? "$label tidak boleh kosong" : null,
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Tanggal Pelaksanaan", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade700)),
          const SizedBox(height: 8),
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) setState(() => _selectedDate = picked);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatTanggal(_selectedDate)),
                  const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentPicker(String label, String currentFile, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [Icon(icon, color: Color(0xFF6C63FF)), SizedBox(width: 8), Text(currentFile.isEmpty ? "Tidak ada file" : currentFile)]),
                TextButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Logika ganti file belum diimplementasi"))),
                  child: const Text("Ganti"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final updatedKegiatan = KegiatanModel(
      docId: widget.kegiatanId,
      namaKegiatan: _namaKegiatanController.text,
      kategoriKegiatan: _kategoriKegiatanController.text,
      penanggungJawabId: _penanggungJawabController.text,
      deskripsi: _deskripsiController.text,
      lokasi: _lokasiController.text,
      tanggalPelaksanaan: Timestamp.fromDate(_selectedDate),
      dibuatOlehId: _dibuatOlehController.text,
      dokumentasi: _currentDokumentasi,
    );

    await _repo.updateKegiatan(updatedKegiatan);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Kegiatan berhasil diperbarui"),
      backgroundColor: Colors.green,
    ));

    context.router.pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.router.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [
            BoxShadow(color: Colors.grey.shade300, blurRadius: 8, offset: Offset(0, 4))
          ]),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextFormField(label: 'Nama Kegiatan', controller: _namaKegiatanController),
                _buildTextFormField(label: 'Kategori Kegiatan', controller: _kategoriKegiatanController),
                _buildTextFormField(label: 'Penanggung Jawab', controller: _penanggungJawabController),
                _buildTextFormField(label: 'Deskripsi', controller: _deskripsiController, maxLines: 3),
                _buildTextFormField(label: 'Lokasi', controller: _lokasiController),
                _buildDatePicker(),
                _buildTextFormField(label: 'Dibuat oleh', controller: _dibuatOlehController, readOnly: true),
                const Divider(height: 24),
                _buildAttachmentPicker("Dokumentasi:", _currentDokumentasi, Icons.description_outlined),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6C63FF),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text("Simpan Perubahan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
