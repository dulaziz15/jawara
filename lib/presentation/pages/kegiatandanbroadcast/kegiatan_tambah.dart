import 'dart:io'; // Import File
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:intl/intl.dart';
import 'package:jawara/core/models/kegiatan_models.dart';
import 'package:jawara/core/repositories/kegiatan_repository.dart';
import 'package:jawara/presentation/pages/kegiatandanbroadcast/widgets/image_picker.dart'; 

@RoutePage()
class KegiatanTambahPage extends StatefulWidget {
  const KegiatanTambahPage({super.key});

  @override
  State<KegiatanTambahPage> createState() => _KegiatanTambahPageState();
}

class _KegiatanTambahPageState extends State<KegiatanTambahPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController lokasiController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController penanggungJawabController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  String? selectedKategori;
  bool _isLoading = false; // Tambahan loading state

  final repo = KegiatanRepository();

  @override
  void dispose() {
    namaController.dispose();
    tanggalController.dispose();
    lokasiController.dispose();
    budgetController.dispose();
    penanggungJawabController.dispose();
    deskripsiController.dispose();
    ImagePickerPreview.clearAll(); // Bersihkan file saat keluar
    super.dispose();
  }

  Future<void> _submit() async {
    if (selectedKategori == null ||
        namaController.text.isEmpty ||
        tanggalController.text.isEmpty ||
        lokasiController.text.isEmpty ||
        penanggungJawabController.text.isEmpty ||
        deskripsiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi')),
      );
      return;
    }

    setState(() => _isLoading = true); // Mulai loading

    try {
      DateTime tanggalParsed = DateFormat("dd/MM/yyyy").parse(tanggalController.text);
      
      // 1. Cek & Upload Gambar
      String urlDokumentasi = "";
      File? fileGambar = ImagePickerPreview.selectedFiles['gambar']; // Ambil dari Static Var
      
      if (fileGambar != null) {
        urlDokumentasi = await repo.uploadFile(fileGambar);
      }

      // 2. Buat Model
      final kegiatan = KegiatanModel(
        docId: "", 
        namaKegiatan: namaController.text,
        kategoriKegiatan: selectedKategori!,
        penanggungJawabId: penanggungJawabController.text,
        deskripsi: deskripsiController.text,
        tanggalPelaksanaan: Timestamp.fromDate(tanggalParsed),
        lokasi: lokasiController.text,
        budget: budgetController.text.isNotEmpty ? double.tryParse(budgetController.text.replaceAll(',', '')) ?? 0.0 : null,
        dibuatOlehId: "ADMIN_001",
        dokumentasi: urlDokumentasi, // Simpan URL hasil upload
      );

      // 3. Simpan ke Firestore
      await repo.addKegiatan(kegiatan);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kegiatan berhasil ditambahkan')),
      );
      
      Navigator.pop(context); // Kembali ke halaman sebelumnya

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal simpan: $e")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _reset() {
    setState(() {
      namaController.clear();
      tanggalController.clear();
      lokasiController.clear();
      penanggungJawabController.clear();
      deskripsiController.clear();
      selectedKategori = null;
      ImagePickerPreview.clearAll(); // Reset picker juga
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(title: const Text("Tambah Kegiatan")),
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
                controller: namaController,
                decoration: InputDecoration(
                  labelText: "Nama Kegiatan",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: selectedKategori,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: "Kategori Kegiatan",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                ),
                hint: const Text("-- Pilih Kategori --"),
                items: const [
                  DropdownMenuItem(value: "Komunitas & Sosial", child: Text("Komunitas & Sosial")),
                  DropdownMenuItem(value: "Kebersihan & Keamanan", child: Text("Kebersihan & Keamanan")),
                  DropdownMenuItem(value: "Keagamaan", child: Text("Keagamaan")),
                  DropdownMenuItem(value: "Pendidikan", child: Text("Pendidikan")),
                  DropdownMenuItem(value: "Kesehatan & Olah Raga", child: Text("Kesehatan & Olah Raga")),
                  DropdownMenuItem(value: "Lainnya", child: Text("Lainnya")),
                ],
                onChanged: (String? newValue) {
                  setState(() => selectedKategori = newValue);
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: tanggalController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Tanggal Kegiatan",
                  suffixIcon: const Icon(Icons.calendar_today_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      tanggalController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: lokasiController,
                decoration: InputDecoration(
                  labelText: "Lokasi",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: budgetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Anggaran (Rp)",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: penanggungJawabController,
                decoration: InputDecoration(
                  labelText: "Penanggung Jawab",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: deskripsiController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Deskripsi",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              
              // --- BAGIAN DOKUMENTASI (FOTO) ---
              const Text("Dokumentasi / Foto Kegiatan", 
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              // Menggunakan Widget yang sama dengan Broadcast
              // Tambahkan Key agar bisa direfresh saat reset
              const ImagePickerPreview(key: ValueKey('kegiatanImg'), type: "gambar"), 
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: _isLoading 
                        ? const SizedBox(
                            width: 20, height: 20, 
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                          )
                        : const Text(
                            "Submit",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : _reset,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        "Reset",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
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