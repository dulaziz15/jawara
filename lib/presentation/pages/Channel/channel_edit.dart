import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/core/models/channel_models.dart';
import 'package:jawara/core/repositories/channel_repository.dart';

@RoutePage()
class ChannelEditPage extends StatefulWidget {
  final String channelId;

  const ChannelEditPage({
    super.key,
    // @PathParam('id') required this.channelId, // Gunakan jika perlu path param
    required this.channelId,
  });

  @override
  State<ChannelEditPage> createState() => _ChannelEditPageState();
}

class _ChannelEditPageState extends State<ChannelEditPage> {
  final ChannelRepository _repository = ChannelRepository();
  final _formKey = GlobalKey<FormState>();

  // Controllers untuk input text
  late TextEditingController _namaController;
  late TextEditingController _tipeController;
  late TextEditingController _anController;
  late TextEditingController _qrController;        // Input URL/Path QR
  late TextEditingController _thumbnailController; // Input URL/Path Thumbnail

  bool _isLoading = true; // Untuk loading saat ambil data awal
  bool _isSaving = false; // Untuk loading saat tombol simpan ditekan

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller
    _namaController = TextEditingController();
    _tipeController = TextEditingController();
    _anController = TextEditingController();
    _qrController = TextEditingController();
    _thumbnailController = TextEditingController();

    // Panggil data dari Firebase
    _loadData();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _tipeController.dispose();
    _anController.dispose();
    _qrController.dispose();
    _thumbnailController.dispose();
    super.dispose();
  }

  // Fungsi mengambil data lama untuk diisi ke form
  Future<void> _loadData() async {
    try {
      final channel = await _repository.getChannelByDocId(widget.channelId);
      if (channel != null) {
        setState(() {
          _namaController.text = channel.nama;
          _tipeController.text = channel.tipe;
          _anController.text = channel.an;
          _qrController.text = channel.qr;
          _thumbnailController.text = channel.thumbnail;
          _isLoading = false;
        });
      } else {
        // Handle jika data tidak ketemu
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Data tidak ditemukan")),
          );
          context.router.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memuat data: $e")),
        );
      }
    }
  }

  // Fungsi Simpan Perubahan
  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      // Data yang akan diupdate
      final updatedData = {
        'nama': _namaController.text,
        'tipe': _tipeController.text,
        'an': _anController.text,
        'qr': _qrController.text,
        'thumbnail': _thumbnailController.text,
      };

      await _repository.updateChannel(widget.channelId, updatedData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data berhasil diperbarui")),
        );
        context.router.pop(); // Kembali ke halaman sebelumnya
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menyimpan: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tampilan Loading saat awal
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Edit Channel", style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => context.router.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Form Edit Channel',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6C63FF),
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildTextField("Nama Channel", _namaController),
                  _buildTextField("Tipe Channel (TV/Radio)", _tipeController),
                  _buildTextField("Atas Nama (Pemilik)", _anController),
                  
                  // Catatan: Ini hanya input text URL. Jika ingin upload gambar, 
                  // butuh logic ImagePicker + FirebaseStorage tambahan.
                  _buildTextField("Link Gambar QR", _qrController),
                  _buildTextField("Link Gambar Thumbnail", _thumbnailController),

                  const SizedBox(height: 32),

                  // Tombol Simpan
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isSaving
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Simpan Perubahan",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '$label tidak boleh kosong';
              }
              return null;
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF6C63FF)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}