import 'dart:io';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jawara/core/models/channel_models.dart';
import 'package:jawara/core/repositories/channel_repository.dart';

@RoutePage()
class ChannelEditPage extends StatefulWidget {
  final String channelId;

  const ChannelEditPage({
    super.key,
    required this.channelId,
  });

  @override
  State<ChannelEditPage> createState() => _ChannelEditPageState();
}

class _ChannelEditPageState extends State<ChannelEditPage> {
  final ChannelRepository _repository = ChannelRepository();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  // Controllers
  late TextEditingController _namaController;
  late TextEditingController _tipeController; // Tetap ada untuk menampung value saat Save
  late TextEditingController _anController;
  late TextEditingController _qrController;        
  late TextEditingController _thumbnailController; 

  // Variabel untuk Dropdown
  String? _selectedTipe;
  final List<String> _tipeOptions = ['Bank', 'Ewallet', 'Qris'];

  bool _isLoading = true; 
  bool _isSaving = false; 

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController();
    _tipeController = TextEditingController();
    _anController = TextEditingController();
    _qrController = TextEditingController();
    _thumbnailController = TextEditingController();

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

          // Sinkronisasi Dropdown dengan data yang ada
          // Jika nilai di DB ada di dalam list opsi, set sebagai selected
          if (_tipeOptions.contains(channel.tipe)) {
            _selectedTipe = channel.tipe;
          } else {
            // Jika data lama tidak sesuai opsi (misal "TV"), biarkan null atau set default
            _selectedTipe = null; 
          }
          
          _isLoading = false;
        });
      } else {
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

  // Helper pilih gambar lokal (Hanya UI Preview)
  Future<void> _pickImage(TextEditingController controller) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          controller.text = image.path; 
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final updatedData = {
        'nama': _namaController.text,
        'tipe': _tipeController.text, // Ini akan terisi otomatis dari Dropdown
        'an': _anController.text,
        'qr': _qrController.text,
        'thumbnail': _thumbnailController.text,
      };

      await _repository.updateChannel(widget.channelId, updatedData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data berhasil diperbarui")),
        );
        context.router.pop();
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
                  
                  // PERUBAHAN DI SINI: Menggunakan Dropdown
                  _buildDropdownField("Tipe Channel"),

                  _buildTextField("Atas Nama (Pemilik)", _anController),
                  
                  const SizedBox(height: 10),
                  _buildImageInput("Gambar QR Code", _qrController),
                  
                  const SizedBox(height: 10),
                  _buildImageInput("Gambar Thumbnail", _thumbnailController),

                  const SizedBox(height: 32),

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
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                              
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

  // Widget TextField Biasa
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
            validator: (value) => (value == null || value.isEmpty) ? '$label tidak boleh kosong' : null,
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

  // WIDGET BARU: Dropdown Field
  Widget _buildDropdownField(String label) {
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
          DropdownButtonFormField<String>(
            value: _selectedTipe,
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
            items: _tipeOptions.map((String val) {
              return DropdownMenuItem(
                value: val,
                child: Text(
                  val, // Menampilkan BANK, EWALLET, QRIS agar rapi
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedTipe = newValue;
                // PENTING: Update controller agar backend tetap berjalan normal
                _tipeController.text = newValue ?? ''; 
              });
            },
            validator: (value) => value == null ? 'Pilih $label' : null,
            hint: const Text("Pilih tipe"),
          ),
        ],
      ),
    );
  }

  // Widget Input Gambar dengan Preview
  Widget _buildImageInput(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => _pickImage(controller),
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (controller.text.isEmpty)
                      const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate_outlined, size: 40, color: Colors.grey),
                            SizedBox(height: 4),
                            Text("Pilih Gambar", style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      )
                    else if (controller.text.startsWith('http'))
                      Image.network(
                        controller.text,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => const Center(
                          child: Icon(Icons.broken_image, color: Colors.grey),
                        ),
                      )
                    else
                      Image.file(
                        File(controller.text),
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => const Center(
                          child: Icon(Icons.broken_image, color: Colors.grey),
                        ),
                      ),
                    
                    Container(
                      color: Colors.black.withOpacity(0.05),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit, color: Color(0xFF6C63FF)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            controller.text.isEmpty ? "Belum ada file dipilih" : 
            (controller.text.length > 30 ? "...${controller.text.substring(controller.text.length - 30)}" : controller.text),
            style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}