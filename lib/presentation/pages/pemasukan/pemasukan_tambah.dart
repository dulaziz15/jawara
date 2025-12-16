import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:intl/intl.dart';
import 'package:jawara/presentation/pages/pemasukan/widgets/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jawara/core/models/pemasukan_model.dart';
import 'package:jawara/core/repositories/pemasukan_repository.dart';

@RoutePage()
class PemasukanLainTambahPage extends StatefulWidget {
  const PemasukanLainTambahPage({super.key});

  @override
  State<PemasukanLainTambahPage> createState() => _PemasukanLainTambahPageState();
}

class _PemasukanLainTambahPageState extends State<PemasukanLainTambahPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController nominalController = TextEditingController();
  String? selectedKategori;
  DateTime? _selectedDate;
  bool _isSaving = false;
  final PemasukanRepository _repo = PemasukanRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    namaController.dispose();
    tanggalController.dispose();
    nominalController.dispose();
    super.dispose();
  }

  void _resetForm() {
    namaController.clear();
    tanggalController.clear();
    nominalController.clear();
    setState(() {
      selectedKategori = null;
      _selectedDate = null;
    });
  }

  Future<void> _submitData() async {
    if (namaController.text.isEmpty || _selectedDate == null || nominalController.text.isEmpty || selectedKategori == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi!')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Bersihkan nomor dan konversi ke double
      String cleanNominal = nominalController.text.replaceAll(RegExp(r'[^0-9]'), '');
      double nominal = double.tryParse(cleanNominal) ?? 0.0;

      String currentUserId = _auth.currentUser?.displayName ?? 'unknown_user';

      final pemasukan = PemasukanModel(
        docId: '',
        namaPemasukan: namaController.text,
        kategoriPemasukan: selectedKategori!,
        verifikatorId: currentUserId,
        buktiPemasukan: '',
        jumlahPemasukan: nominal,
        tanggalPemasukan: _selectedDate!,
        tanggalTerverifikasi: DateTime.now(),
      );

      final createdId = await _repo.addPemasukan(pemasukan);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Pemasukan berhasil disimpan!'), backgroundColor: Colors.green),
        );
        _resetForm();
        // Navigate to detail page for the created pemasukan
        try {
          context.router.pushNamed('/pemasukan/pemasukan_detail/$createdId');
        } catch (_) {
          // Fallback: do nothing if routing fails
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Gagal menyimpan: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
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
                        "Buat Pemasukan Baru",
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
                        "Isi form di bawah ini untuk mencatat pemasukan",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Nama Pemasukan
                    TextFormField(
                      controller: namaController,
                      decoration: const InputDecoration(
                        labelText: "Nama Pemasukan",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 216, 216, 216),
                            width: 0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Color(0xFF6C63FF),
                            width: 1.5,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Tanggal Pemasukan
                    TextFormField(
                      controller: tanggalController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: "Tanggal Pemasukan",
                        suffixIcon: Icon(Icons.calendar_today_outlined),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 216, 216, 216),
                            width: 0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Color(0xFF6C63FF),
                            width: 1.5,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
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

                    // Kategori Pemasukan
                    DropdownButtonFormField<String>(
                      value: selectedKategori,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: "Kategori Pemasukan",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 216, 216, 216),
                            width: 0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Color(0xFF6C63FF),
                            width: 1.5,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                      ),
                      hint: const Text("-- Pilih Kategori --"),
                      items: const [
                        DropdownMenuItem(
                          value: "Operasional",
                          child: Text("Operasional"),
                        ),
                        DropdownMenuItem(
                          value: "Logistik",
                          child: Text("Logistik"),
                        ),
                        DropdownMenuItem(
                          value: "Lainnya",
                          child: Text("Lainnya"),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedKategori = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 15),

                    // Nominal
                    TextFormField(
                      controller: nominalController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Nominal",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 216, 216, 216),
                            width: 0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Color(0xFF6C63FF),
                            width: 1.5,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Bukti Pemasukan
                    ImagePickerPreview(),

                    const SizedBox(height: 20),

                      // Helper functions
                    

                    // Tombol Submit dan Reset
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _resetForm,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text(
                              "Reset",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isSaving ? null : _submitData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C63FF),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: _isSaving
                                ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Text(
                                    "Simpan",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
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
