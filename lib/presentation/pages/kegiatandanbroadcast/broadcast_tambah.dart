import 'dart:io'; // Import dart:io untuk tipe File
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/presentation/pages/kegiatandanbroadcast/widgets/image_picker.dart';
import 'package:jawara/core/repositories/broadcast_repository.dart';
import 'package:jawara/core/models/broadcast_models.dart';

@RoutePage()
class BroadcastTambahPage extends StatefulWidget {
  const BroadcastTambahPage({super.key});

  @override
  State<BroadcastTambahPage> createState() => _BroadcastTambahPageState();
}

class _BroadcastTambahPageState extends State<BroadcastTambahPage> {
  final TextEditingController judulController = TextEditingController();
  final TextEditingController isiController = TextEditingController();

  final BroadcastRepository _repo = BroadcastRepository();
  bool _isLoading = false;

  @override
  void dispose() {
    judulController.dispose();
    isiController.dispose();
    // Bersihkan file saat keluar halaman
    ImagePickerPreview.clearAll(); 
    super.dispose();
  }

  Future<void> _submit() async {
    if (judulController.text.isEmpty || isiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Judul & isi tidak boleh kosong")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      String gambarUrl = "";
      String dokumenUrl = "";

      // 1. UPLOAD GAMBAR (Panggil dari Repo)
      File? fileGambar = ImagePickerPreview.selectedFiles['gambar'];
      if (fileGambar != null) {
        gambarUrl = await _repo.uploadFile(fileGambar, 'broadcast_images');
      }

      // 2. UPLOAD DOKUMEN (Panggil dari Repo)
      File? fileDokumen = ImagePickerPreview.selectedFiles['dokumen'];
      if (fileDokumen != null) {
        dokumenUrl = await _repo.uploadFile(fileDokumen, 'broadcast_docs');
      }

      // 3. BUAT MODEL & SIMPAN KE FIRESTORE
      final broadcast = BroadcastModels(
        docId: "", // Biarkan kosong, repo yang urus
        judulBroadcast: judulController.text,
        isiPesan: isiController.text,
        kategoriBroadcast: "Umum", // Sesuaikan jika ada dropdown
        tanggalPublikasi: DateTime.now(),
        dibuatOlehId: "admin001", // Ganti dengan ID User Login
        lampiranGambar: gambarUrl,
        lampiranDokumen: dokumenUrl,
      );

      await _repo.addBroadcast(broadcast);

      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Broadcast berhasil ditambahkan")),
      );
      
      // Reset picker
      ImagePickerPreview.clearAll();
      Navigator.pop(context);

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _reset() {
    judulController.clear();
    isiController.clear();
    setState(() {
      ImagePickerPreview.clearAll(); // Reset static variable
    });
    // Kita perlu trigger rebuild agar UI ImagePickerPreview ikut kereset
    // Cara paling mudah adalah pushReplacement atau menggunakan Key, 
    // tapi setState sederhana di sini akan merefresh halaman ini.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: judulController,
                decoration: InputDecoration(
                  labelText: "Judul Broadcast",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: isiController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: "Isi Broadcast",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),

              const Text("Foto", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              // Tambahkan Key agar widget terrebuild saat di-reset
              const ImagePickerPreview(key: ValueKey('imgPicker'), type: "gambar"),
              
              const SizedBox(height: 16),

              const Text("Dokumen", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              // Tambahkan Key agar widget terrebuild saat di-reset
              const ImagePickerPreview(key: ValueKey('docPicker'), type: "dokumen"),
              
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20, width: 20, 
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                            )
                          : const Text("Submit", style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : _reset,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Reset", style: TextStyle(fontSize: 16, color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}