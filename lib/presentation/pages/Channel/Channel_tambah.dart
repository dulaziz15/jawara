import 'dart:io';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:jawara/core/models/channel_models.dart';
import 'package:jawara/core/repositories/channel_repository.dart';

@RoutePage()
class ChannelTambahPage extends StatefulWidget {
  const ChannelTambahPage({super.key});

  @override
  State<ChannelTambahPage> createState() => _ChannelTambahPageState();
}

class _ChannelTambahPageState extends State<ChannelTambahPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ChannelRepository _repository = ChannelRepository();

  // Controllers
  late TextEditingController _namaController;
  late TextEditingController _rekeningController;
  late TextEditingController _anController;
  late TextEditingController _catatanController;

  // State Variables
  String? _selectedTipe;
  String _qrPath = '';
  String _thumbnailPath = '';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController();
    _rekeningController = TextEditingController();
    _anController = TextEditingController();
    _catatanController = TextEditingController();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _rekeningController.dispose();
    _anController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  // Helper Input Decoration
  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  // Fungsi Reset Form
  void _resetForm() {
    _formKey.currentState?.reset();
    _namaController.clear();
    _rekeningController.clear();
    _anController.clear();
    _catatanController.clear();
    setState(() {
      _selectedTipe = null;
      _qrPath = '';
      _thumbnailPath = '';
    });
  }

  // Fungsi Simpan ke Firebase
  Future<void> _simpan() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() => _isSaving = true);

      try {
        String qrDownloadUrl = '';
        String thumbnailDownloadUrl = '';

        // 1. Upload QR jika ada path lokalnya
        if (_qrPath.isNotEmpty) {
          qrDownloadUrl = await _repository.uploadImage(
            File(_qrPath), 
            'channel_qr' // Nama folder di Storage
          );
        }

        // 2. Upload Thumbnail jika ada path lokalnya
        if (_thumbnailPath.isNotEmpty) {
          thumbnailDownloadUrl = await _repository.uploadImage(
            File(_thumbnailPath), 
            'channel_thumbnails' // Nama folder di Storage
          );
        }

        // 3. Buat Object Model dengan URL HASIL UPLOAD (Bukan path lokal)
        final newChannel = ChannelModel(
          docId: '', // Nanti akan diisi otomatis oleh Repository logic baru
          nama: _namaController.text,
          tipe: _selectedTipe ?? '',
          catatan: _catatanController.text,
          an: _anController.text,
          qr: qrDownloadUrl,            // URL Firebase Storage
          thumbnail: thumbnailDownloadUrl, // URL Firebase Storage
        );

        // 4. Simpan ke Firestore
        await _repository.addChannel(newChannel);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("✅ Data berhasil disimpan & gambar terupload!"),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
            ),
          );
          context.router.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("❌ Gagal: $e"),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }

  // Fungsi Pick Image
  Future<void> _pickImage(bool isQr) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        if (isQr) {
          _qrPath = image.path;
        } else {
          _thumbnailPath = image.path;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9fc),
      appBar: AppBar(
        title: const Text("Buat Channel Baru", style: TextStyle(color: Colors.black)),
        backgroundColor: const Color(0xfff8f9fc),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.router.pop(),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Card(
            elevation: 3,
            margin: const EdgeInsets.all(24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const Text(
                      'Isi Data Channel',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6C63FF),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Nama Channel
                    TextFormField(
                      controller: _namaController,
                      decoration: _inputDecoration(
                          'Nama Channel', 'Contoh: BCA, Dana, QRIS RT'),
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Nama channel wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Dropdown tipe
                    DropdownButtonFormField<String>(
                      decoration: _inputDecoration('Tipe', '-- Pilih Tipe --'),
                      value: _selectedTipe,
                      items: const [
                        DropdownMenuItem(value: 'Bank', child: Text('Bank')),
                        DropdownMenuItem(value: 'E-Wallet', child: Text('E-Wallet')),
                        DropdownMenuItem(value: 'QRIS', child: Text('QRIS')),
                      ],
                      onChanged: (val) => setState(() => _selectedTipe = val),
                      validator: (v) => (v == null || v.isEmpty) ? 'Pilih tipe' : null,
                    ),
                    const SizedBox(height: 16),

                    // Nomor rekening
                    TextFormField(
                      controller: _rekeningController,
                      decoration: _inputDecoration(
                          'Nomor Rekening / Akun', 'Contoh: 1234567890'),
                      keyboardType: TextInputType.number,
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Nomor rekening wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Nama Pemilik
                    TextFormField(
                      controller: _anController,
                      decoration: _inputDecoration(
                          'Nama Pemilik', 'Contoh: John Doe'),
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Nama pemilik wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 24),

                    // Upload QR
                    Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xfff2f2f2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: TextButton.icon(
                        onPressed: () => _pickImage(true), // true for QR
                        icon: const Icon(Icons.qr_code, color: Color(0xFF6C63FF)),
                        label: Text(
                          _qrPath.isNotEmpty
                              ? 'Foto QR: ${path.basename(_qrPath)}'
                              : 'Upload foto QR (jika ada)',
                          style: TextStyle(
                              color: _qrPath.isNotEmpty ? Colors.black87 : Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Upload Thumbnail
                    Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xfff2f2f2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: TextButton.icon(
                        onPressed: () => _pickImage(false), // false for Thumbnail
                        icon: const Icon(Icons.image_outlined, color: Color(0xFF6C63FF)),
                        label: Text(
                          _thumbnailPath.isNotEmpty
                              ? 'Thumbnail: ${path.basename(_thumbnailPath)}'
                              : 'Upload thumbnail (jika ada)',
                           style: TextStyle(
                              color: _thumbnailPath.isNotEmpty ? Colors.black87 : Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Catatan
                    TextFormField(
                      controller: _catatanController,
                      decoration: _inputDecoration(
                          'Catatan (Opsional)',
                          'Contoh: Transfer sesama bank'),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 30),

                    // Tombol Action
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: _isSaving ? null : _resetForm,
                            child: const Text('Reset'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff5a5af0),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: _isSaving ? null : _simpan,
                            child: _isSaving 
                                ? const SizedBox(
                                    height: 20, 
                                    width: 20, 
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                  ) 
                                : const Text('Simpan'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}