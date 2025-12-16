import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

// IMPORT REPOSITORY & MODEL (Sesuaikan path folder Anda)
import 'package:jawara/core/repositories/family_repository.dart';
import 'package:jawara/core/repositories/warga_repository.dart';
import 'package:jawara/core/models/family_models.dart';
import 'package:jawara/core/models/warga_models.dart';

@RoutePage()
class WargaTambahPage extends StatefulWidget {
  const WargaTambahPage({super.key});

  @override
  State<WargaTambahPage> createState() => _WargaTambahPageState();
}

class _WargaTambahPageState extends State<WargaTambahPage> {
  // 1. Inisialisasi Repository
  final FamilyRepository _familyRepo = FamilyRepository();
  final CitizenRepository _wargaRepo = CitizenRepository();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // 2. Controllers (Disesuaikan dengan WargaModel)
  final _namaController = TextEditingController();
  final _nikController = TextEditingController();
  final _tanggalLahirController = TextEditingController();
  
  // 3. Value Notifiers
  final _keluargaValue = ValueNotifier<String?>(null); // Menyimpan NoKK
  final _jenisKelaminValue = ValueNotifier<String?>('Laki-laki');
  final _statusDomisiliValue = ValueNotifier<String?>('Aktif');
  final _statusHidupValue = ValueNotifier<String?>('Hidup');

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    _keluargaValue.dispose();
    _jenisKelaminValue.dispose();
    _statusDomisiliValue.dispose();
    _statusHidupValue.dispose();
    _tanggalLahirController.dispose();
    super.dispose();
  }

  DateTime? _parseDate(String input) {
    try {
      final parts = input.split('/');
      final d = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      final y = int.parse(parts[2]);
      return DateTime(y, m, d);
    } catch (e) {
      return null;
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _namaController.clear();
    _nikController.clear();
    _keluargaValue.value = null;
    _jenisKelaminValue.value = 'Laki-laki';
    _statusDomisiliValue.value = 'Aktif';
    _statusHidupValue.value = 'Hidup';
  }

  // 4. Submit Form ke WargaRepository
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Mapping data ke WargaModel
        final wargaBaru = WargaModel(
          docId: '', // Kosongkan, nanti diurus Firestore/Repo
          nik: _nikController.text,
          nama: _namaController.text,
          keluarga: _keluargaValue.value ?? '', // Mengambil ID/NoKK dari Dropdown
          tanggalLahir: _tanggalLahirController.text.isNotEmpty ? _parseDate(_tanggalLahirController.text) : null,
          jenisKelamin: _jenisKelaminValue.value ?? 'Laki-laki',
          statusDomisili: _statusDomisiliValue.value ?? 'Aktif',
          statusHidup: _statusHidupValue.value ?? 'Hidup',
        );

        // Kirim via Repo
        await _wargaRepo.addCitizen(wargaBaru);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil disimpan!'), backgroundColor: Colors.green),
        );
        _resetForm();

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e'), backgroundColor: Colors.red),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      width: 550,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
             _buildHeader(),
            const SizedBox(height: 24),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    // --- BAGIAN INI MENGAMBIL DATA DARI FAMILY REPO ---
                    const Text('Pilih Keluarga', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 5),
                    StreamBuilder<List<FamilyModel>>(
                      stream: _familyRepo.getAllFamilies(), // Stream dari Repo
                      builder: (context, snapshot) {
                        // Loading State
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const LinearProgressIndicator();
                        }
                        
                        // Error State
                        if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.red));
                        }

                        // Data
                        final List<FamilyModel> families = snapshot.data ?? [];
                        
                        if (families.isEmpty) {
                          return const Text("Data keluarga kosong. Tambahkan Keluarga dulu.");
                        }

                        // Render Dropdown
                        return ValueListenableBuilder<String?>(
                          valueListenable: _keluargaValue,
                          builder: (context, value, child) {
                            return DropdownButtonFormField<String>(
                              value: value,
                              isExpanded: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              ),
                              hint: const Text('-- Pilih Keluarga --'),
                              items: families.map((family) {
                                return DropdownMenuItem<String>(
                                  value: family.noKk, // Value yg disimpan adalah NoKK
                                  child: Text("${family.noKk} - ${family.namaKeluarga ?? 'Tanpa Nama'}"),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                _keluargaValue.value = newValue;
                              },
                              validator: (val) => val == null ? 'Keluarga wajib dipilih' : null,
                            );
                          },
                        );
                      },
                    ),
                    // --------------------------------------------------

                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Nama',
                      hint: 'Masukkan nama lengkap',
                      controller: _namaController,
                      validator: (value) => value!.isEmpty ? 'Nama harus diisi' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'NIK',
                      hint: 'Masukkan NIK',
                      controller: _nikController,
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.length != 16 ? 'NIK harus 16 digit' : null,
                    ),
                    const SizedBox(height: 16),

                    // Tanggal Lahir
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tanggal Lahir', style: TextStyle(fontSize: 14)),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: _tanggalLahirController,
                          readOnly: true,
                          decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Pilih tanggal lahir'),
                          onTap: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime(1990),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              _tanggalLahirController.text = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Dropdown Statis (Hardcode items)
                    _buildDropdownField(label: 'Jenis Kelamin', hint: '-- Pilih --', valueNotifier: _jenisKelaminValue, items: const ['Laki-laki', 'Perempuan']),
                    const SizedBox(height: 16),
                    _buildDropdownField(label: 'Status Domisili', hint: '-- Pilih --', valueNotifier: _statusDomisiliValue, items: const ['Aktif', 'Pindah', 'Sementara']),
                    const SizedBox(height: 16),
                    _buildDropdownField(label: 'Status Hidup', hint: '-- Pilih --', valueNotifier: _statusHidupValue, items: const ['Hidup', 'Meninggal']),
                    
                    const SizedBox(height: 24),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= HELPER WIDGETS =================

  Widget _buildHeader() {
    return const Column(
      children: [
        SizedBox(height: 15),
        Center(child: Text('Tambah Warga', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        SizedBox(height: 16),
        Center(child: Text('Form untuk menambahkan data warga', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
      ],
    );
  }

  Widget _buildTextField({required String label, required String hint, required TextEditingController controller, TextInputType? keyboardType, String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 5),
        TextFormField(controller: controller, decoration: InputDecoration(border: const OutlineInputBorder(), hintText: hint), keyboardType: keyboardType, validator: validator),
      ],
    );
  }

  Widget _buildDropdownField({required String label, required String hint, required ValueNotifier<String?> valueNotifier, required List<String> items}) {
    return ValueListenableBuilder<String?>(
      valueListenable: valueNotifier,
      builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 5),
            DropdownButtonFormField<String>(
              value: value,
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12)),
              hint: Text(hint),
              items: items.map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
              onChanged: (v) => valueNotifier.value = v,
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: _isLoading ? null : _resetForm,
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), side: const BorderSide(color: Colors.grey)),
          child: const Text('Reset', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14)),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submitForm,
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C63FF), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
          child: _isLoading 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text('Submit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        ),
      ],
    );
  }
}