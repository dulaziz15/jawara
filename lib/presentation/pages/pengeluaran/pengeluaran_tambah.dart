import 'dart:io';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jawara/core/models/pengeluaran_model.dart';
import 'package:jawara/core/repositories/pengeluaran_repository.dart';
import 'package:path/path.dart' as path;

@RoutePage()
class PengeluaranTambahPage extends StatefulWidget {
  const PengeluaranTambahPage({super.key});

  @override
  State<PengeluaranTambahPage> createState() => _PengeluaranTambahPageState();
}

class _PengeluaranTambahPageState extends State<PengeluaranTambahPage> {
  // Repository & Auth
  final PengeluaranRepository _repository = PengeluaranRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Controllers
  final TextEditingController namaController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController nominalController = TextEditingController();
  
  // State
  String? selectedKategori;
  String _buktiPath = ''; // Path lokal gambar
  bool _isLoading = false;
  
  // Variabel bantu untuk menyimpan tanggal asli (DateTime)
  DateTime? _selectedDate;

  @override
  void dispose() {
    namaController.dispose();
    tanggalController.dispose();
    nominalController.dispose();
    super.dispose();
  }

  // Fungsi Reset
  void _resetForm() {
    namaController.clear();
    tanggalController.clear();
    nominalController.clear();
    setState(() {
      selectedKategori = null;
      _buktiPath = '';
      _selectedDate = null;
    });
  }

  // Fungsi Pilih Gambar
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _buktiPath = image.path;
      });
    }
  }

  // Fungsi Simpan Data
  Future<void> _submitData() async {
    // 1. Validasi Input
    if (namaController.text.isEmpty ||
        _selectedDate == null ||
        nominalController.text.isEmpty ||
        selectedKategori == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi!')),
      );
      return;
    }

    if (_buktiPath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap upload bukti pengeluaran!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 2. Upload Gambar ke Storage
      String buktiUrl = await _repository.uploadBukti(File(_buktiPath));

      // 3. Ambil UID User yang sedang Login (sebagai Verifikator)
      String currentUserId = _auth.currentUser?.uid ?? 'unknown_user';

      // 4. Konversi Nominal (String ke Double)
      // Hapus karakter non-digit jika ada (misal Rp atau titik)
      String cleanNominal = nominalController.text.replaceAll(RegExp(r'[^0-9]'), '');
      double nominal = double.tryParse(cleanNominal) ?? 0.0;

      // 5. Buat Model
      PengeluaranModel newPengeluaran = PengeluaranModel(
        docId: '', // Akan digenerate di repo
        namaPengeluaran: namaController.text,
        kategoriPengeluaran: selectedKategori!,
        verifikatorId: currentUserId, // Otomatis ID yang login
        buktiPengeluaran: buktiUrl,   // URL dari Firebase Storage
        jumlahPengeluaran: nominal,
        tanggalPengeluaran: _selectedDate!,
        tanggalTerverifikasi: DateTime.now(), // Default saat dibuat
      );

      // 6. Simpan ke Firestore
      await _repository.addPengeluaran(newPengeluaran);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Pengeluaran berhasil disimpan!'),
            backgroundColor: Colors.green,
          ),
        );
        _resetForm();
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Gagal menyimpan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 5),
              Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(15),
                width: 550,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "Buat Pengeluaran Baru",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        "Isi form di bawah ini untuk mencatat pengeluaran",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Nama Pengeluaran
                    TextFormField(
                      controller: namaController,
                      decoration: const InputDecoration(
                        labelText: "Nama Pengeluaran",
                        hintText: "Contoh: Beli ATK",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Tanggal Pengeluaran
                    TextFormField(
                      controller: tanggalController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: "Tanggal Pengeluaran",
                        suffixIcon: Icon(Icons.calendar_today_outlined),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
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
                            _selectedDate = pickedDate;
                            tanggalController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 15),

                    // Kategori Pengeluaran
                    DropdownButtonFormField<String>(
                      value: selectedKategori,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: "Kategori Pengeluaran",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      ),
                      hint: const Text("-- Pilih Kategori --"),
                      items: const [
                        DropdownMenuItem(value: "Operasional", child: Text("Operasional")),
                        DropdownMenuItem(value: "Logistik", child: Text("Logistik")),
                        DropdownMenuItem(value: "Lainnya", child: Text("Lainnya")),
                      ],
                      onChanged: (String? newValue) {
                        setState(() => selectedKategori = newValue);
                      },
                    ),
                    const SizedBox(height: 15),

                    // Nominal
                    TextFormField(
                      controller: nominalController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Nominal (Rp)",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // === AREA UPLOAD BUKTI (MENGGANTIKAN ImagePickerPreview) ===
                    const Text("Bukti Pengeluaran", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _pickImage,
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _buktiPath.isEmpty
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.cloud_upload_outlined, size: 40, color: Colors.grey),
                                  SizedBox(height: 8),
                                  Text("Ketuk untuk upload gambar", style: TextStyle(color: Colors.grey)),
                                ],
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(_buktiPath),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Tombol Submit dan Reset
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submitData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C63FF),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: _isLoading 
                                ? const SizedBox(
                                    width: 20, 
                                    height: 20, 
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
                            onPressed: _isLoading ? null : _resetForm,
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
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}