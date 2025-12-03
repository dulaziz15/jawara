import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/core/models/broadcast_models.dart';
import 'package:jawara/core/repositories/broadcast_repository.dart'; // Import Repository

@RoutePage()
class BroadcastEditPage extends StatefulWidget {
  final String broadcastId;

  const BroadcastEditPage({
    super.key,
    @PathParam('id') required this.broadcastId,
  });

  @override
  State<BroadcastEditPage> createState() => _BroadcastEditPageState();
}

class _BroadcastEditPageState extends State<BroadcastEditPage> {
  // 1. Inisialisasi Repository
  final BroadcastRepository _repository = BroadcastRepository();
  final _formKey = GlobalKey<FormState>();

  // State
  bool _isLoading = true; // Loading awal
  bool _isSaving = false; // Loading saat simpan

  // Controllers & Data
  late TextEditingController _judulController;
  late TextEditingController _isiPesanController;
  late TextEditingController _dibuatOlehController;
  
  // Model data
  BroadcastModels? _broadcast;
  late DateTime _selectedDate;
  String _currentGambar = '';
  String _currentDokumen = '';
  // Field Kategori (jika perlu diedit)
  String _currentKategori = ''; 

  @override
  void initState() {
    super.initState();
    // Init Controller
    _judulController = TextEditingController();
    _isiPesanController = TextEditingController();
    _dibuatOlehController = TextEditingController();
    
    // 2. Load Data dari Firebase
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await _repository.getBroadcastByDocId(widget.broadcastId);
    
    if (data != null) {
      setState(() {
        _broadcast = data;
        _judulController.text = data.judulBroadcast;
        _isiPesanController.text = data.isiPesan;
        _dibuatOlehController.text = data.dibuatOlehId;
        _selectedDate = data.tanggalPublikasi;
        _currentGambar = data.lampiranGambar;
        _currentDokumen = data.lampiranDokumen;
        _currentKategori = data.kategoriBroadcast;
        _isLoading = false;
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data broadcast tidak ditemukan')),
        );
        context.router.pop();
      }
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _isiPesanController.dispose();
    _dibuatOlehController.dispose();
    super.dispose();
  }

  String _formatTanggal(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  // --- Helper Widget TextFormField ---
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
              fillColor: readOnly ? Colors.grey.shade100 : Colors.white,
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

  // --- Helper Widget Date Picker ---
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

  // --- Helper Widget Attachment (Updated) ---
  Widget _buildAttachmentInfo(String label, String url, IconData icon) {
    bool hasFile = url.isNotEmpty;
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
              color: Colors.grey.shade50,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(icon, color: const Color(0xFF6C63FF), size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          hasFile ? url : "Tidak ada file",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: hasFile ? Colors.black87 : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Tombol Ganti (Opsional: Butuh implementasi Upload seperti di Tambah Page)
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fitur ganti file belum tersedia')),
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

  // --- Fungsi Simpan Perubahan ke Firebase ---
  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);

      try {
        // Buat model dengan data baru
        BroadcastModels updatedBroadcast = BroadcastModels(
          docId: widget.broadcastId,
          judulBroadcast: _judulController.text,
          isiPesan: _isiPesanController.text,
          tanggalPublikasi: _selectedDate,
          dibuatOlehId: _dibuatOlehController.text, // Tetap sama
          lampiranGambar: _currentGambar,   // Tetap sama (kecuali fitur upload edit dibuat)
          lampiranDokumen: _currentDokumen, // Tetap sama
          kategoriBroadcast: _currentKategori, // Tetap sama
        );

        // Update di Firestore
        await _repository.updateBroadcast(updatedBroadcast);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Broadcast berhasil diperbarui'),
              backgroundColor: Colors.green,
            ),
          );
          context.router.pop(); // Kembali
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Gagal update: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tampilan Loading
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(backgroundColor: Colors.grey.shade100),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.router.pop(),
        ),
        title: const Text('Edit Broadcast', style: TextStyle(color: Colors.black87)),
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
                _buildTextFormField(
                  label: 'Judul Broadcast',
                  controller: _judulController,
                ),
                _buildTextFormField(
                  label: 'Isi Pesan',
                  controller: _isiPesanController,
                  maxLines: 5,
                ),
                _buildDatePicker(),
                _buildTextFormField(
                  label: 'Dibuat oleh (ID)',
                  controller: _dibuatOlehController,
                  readOnly: true,
                ),
                const Divider(height: 24),

                // Info Lampiran (Read Only untuk saat ini)
                _buildAttachmentInfo(
                  "Lampiran Gambar:",
                  _currentGambar,
                  Icons.image_outlined,
                ),
                _buildAttachmentInfo(
                  "Lampiran Dokumen:",
                  _currentDokumen,
                  Icons.description_outlined,
                ),

                const SizedBox(height: 24),

                // Tombol Simpan
                ElevatedButton(
                  onPressed: _isSaving ? null : _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
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