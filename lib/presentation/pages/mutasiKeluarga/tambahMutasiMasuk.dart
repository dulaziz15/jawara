import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../core/repositories/family_repository.dart';
import '../../../core/repositories/rumah_repository.dart';
import '../../../core/repositories/warga_repository.dart';
import '../../../core/repositories/mutasi_repository.dart';
import '../../../core/models/family_models.dart';
import '../../../core/models/rumah_models.dart';
import '../../../core/models/warga_models.dart';
import '../../../core/models/mutasi_model.dart';

@RoutePage()
class TambahMutasiMasukPage extends StatefulWidget {
  const TambahMutasiMasukPage({super.key});

  @override
  State<TambahMutasiMasukPage> createState() => _TambahMutasiMasukPageState();
}

class _TambahMutasiMasukPageState extends State<TambahMutasiMasukPage> {
  final _formKey = GlobalKey<FormState>();
  final FamilyRepository _familyRepo = FamilyRepository();
  final RumahRepository _rumahRepo = RumahRepository();
  final CitizenRepository _wargaRepo = CitizenRepository();
  final MutasiRepository _mutasiRepo = MutasiRepository();

  // Controllers
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();

  // Family
  String? _selectedFamilyNoKk;
  String? _selectedFamilyName;
  final TextEditingController _manualNoKk = TextEditingController();
  final TextEditingController _manualNamaKeluarga = TextEditingController();
  final TextEditingController _manualAlamatKeluarga = TextEditingController();
  bool _manualFamilyTouched = false; // track if user edited manual family fields
  static const String _manualFamilyValue = '__manual__';

  // Rumah
  String? _selectedRumahId;
  String? _selectedRumahNo;
  final TextEditingController _manualRumahNo = TextEditingController();
  final TextEditingController _manualRumahAlamat = TextEditingController();
  bool _manualRumahTouched = false; // track if user edited manual rumah fields
  static const String _manualRumahValue = '__manual_rumah__';

  // Mutasi
  final TextEditingController _tanggalMutasiController = TextEditingController();
  final TextEditingController _asalController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();

  String _jenisKelamin = 'Laki-laki';

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    _tanggalLahirController.dispose();
    _manualNoKk.dispose();
    _manualNamaKeluarga.dispose();
    _manualAlamatKeluarga.dispose();
    _manualRumahNo.dispose();
    _manualRumahAlamat.dispose();
    _tanggalMutasiController.dispose();
    _asalController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    // Determine family to use (manual takes precedence if filled)
    String familyNoKk;
    String familyName;
    String familyAlamat = '';

    // Family selection logic
    if ((_manualNoKk.text.trim().isNotEmpty && _manualFamilyTouched) || _selectedFamilyNoKk == _manualFamilyValue) {
      // Manual family required
      if (_manualNoKk.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No. KK harus diisi untuk keluarga baru'), backgroundColor: Colors.red));
        return;
      }
      familyNoKk = _manualNoKk.text.trim();
      familyName = _manualNamaKeluarga.text.trim().isNotEmpty ? _manualNamaKeluarga.text.trim() : 'Keluarga $familyNoKk';
      familyAlamat = _manualAlamatKeluarga.text.trim();

      final newFamily = FamilyModel(
        docId: familyNoKk,
        noKk: familyNoKk,
        namaKeluarga: familyName,
        nikKepalaKeluarga: '',
        alamatRumah: familyAlamat,
        statusKepemilikanRumah: 'Milik Sendiri',
        statusDomisiliKeluarga: 'Aktif',
      );

      try {
        await _familyRepo.addFamily(newFamily);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal menyimpan keluarga'), backgroundColor: Colors.red));
        return;
      }
    } else if (_selectedFamilyNoKk != null && _selectedFamilyNoKk != _manualFamilyValue) {
      familyNoKk = _selectedFamilyNoKk!;
      familyName = _selectedFamilyName ?? '';
      // Try to fetch family alamat
      final family = await _familyRepo.getFamilyByNoKk(_selectedFamilyNoKk!);
      if (family != null) familyAlamat = family.alamatRumah;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Silakan pilih keluarga atau isi keluarga baru'), backgroundColor: Colors.red));
      return;
    }

    // Rumah logic (manual takes precedence)
    String rumahNo = '';
    String rumahAlamat = '';
    // Rumah logic (manual takes precedence)
    if ((_manualRumahNo.text.trim().isNotEmpty && _manualRumahTouched) || _selectedRumahId == _manualRumahValue) {
      // manual rumah required
      if (_manualRumahNo.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No. Rumah harus diisi untuk rumah baru'), backgroundColor: Colors.red));
        return;
      }
      rumahNo = _manualRumahNo.text.trim();
      rumahAlamat = _manualRumahAlamat.text.trim();
      try {
        await _rumahRepo.addRumah(rumahNo, rumahAlamat, 'Tersedia');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal menyimpan rumah'), backgroundColor: Colors.red));
        return;
      }
      // If we created a new rumah and family was existing, update family alamat
      if (_selectedFamilyNoKk != null && _selectedFamilyNoKk != _manualFamilyValue && _manualRumahAlamat.text.trim().isNotEmpty) {
        final family = await _familyRepo.getFamilyByNoKk(_selectedFamilyNoKk!);
        if (family != null) {
          final updatedFamily = FamilyModel(
            docId: family.docId,
            noKk: family.noKk,
            namaKeluarga: family.namaKeluarga,
            nikKepalaKeluarga: family.nikKepalaKeluarga,
            alamatRumah: rumahAlamat,
            statusKepemilikanRumah: family.statusKepemilikanRumah,
            statusDomisiliKeluarga: family.statusDomisiliKeluarga,
          );
          await _familyRepo.updateFamily(updatedFamily);
        }
      }
      // assign to familyAlamat if none
      if (familyAlamat.isEmpty) familyAlamat = rumahAlamat;
    } else if (_selectedRumahId != null && _selectedRumahId != _manualRumahValue) {
      // fetch selected rumah details
      // Note: RumahRepository doesn't have getById, so rely on selectedRumahNo already set
      rumahNo = _selectedRumahNo ?? '';
    }

    // Create warga
    final warga = WargaModel(
      docId: '',
      nik: _nikController.text.trim(),
      nama: _namaController.text.trim(),
      keluarga: familyNoKk,
      tanggalLahir: null,
      jenisKelamin: _jenisKelamin,
      statusDomisili: 'Aktif',
      statusHidup: 'Hidup',
    );

    try {
      await _wargaRepo.addCitizen(warga);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal menyimpan warga'), backgroundColor: Colors.red));
      return;
    }

    // Create mutasi entry (jenis 'Mutasi Masuk')
    final mutasi = MutasiData(
      docId: '',
      keluarga: familyName,
      alamatLama: _asalController.text.trim(),
      alamatBaru: familyAlamat,
      tanggalMutasi: _tanggalMutasiController.text.trim(),
      jenisMutasi: 'Mutasi Masuk',
      alasan: _keteranganController.text.trim(),
    );

    try {
      await _mutasiRepo.addMutasi(mutasi);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mutasi masuk berhasil disimpan'), backgroundColor: Colors.green));
      Future.delayed(const Duration(milliseconds: 1000), () => context.router.pop());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal menyimpan mutasi'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(20),
            width: 600,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0,4))],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(child: Text('Tambah Mutasi Masuk', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
                  const SizedBox(height: 10),
                  const Center(child: Text('Form untuk mencatat warga yang masuk dan sekaligus membuat data keluarga/rumah/warga'),),
                  const SizedBox(height: 20),

                  // FAMILY: dropdown + manual inputs
                  const Text('Pilih Keluarga (boleh kosong jika menambah baru)', style: TextStyle(fontSize: 14)),
                  const SizedBox(height: 8),
                  StreamBuilder<List<FamilyModel>>(
                    stream: _familyRepo.getAllFamilies(),
                    builder: (context, snap) {
                      if (!snap.hasData) return const LinearProgressIndicator();
                      final families = snap.data!;
                      return DropdownButtonFormField<String>(
                        value: _selectedFamilyNoKk,
                        items: [
                          const DropdownMenuItem<String>(value: _manualFamilyValue, child: Text('Belum ada (Tambah baru)')),
                          ...families.map((f) => DropdownMenuItem<String>(value: f.noKk, child: Text('${f.noKk} - ${f.namaKeluarga}'))).toList(),
                        ],
                        onChanged: (v) {
                          setState(() {
                            _selectedFamilyNoKk = v;
                            if (v == _manualFamilyValue) {
                              // manual mode - clear manual fields so user can type
                              _selectedFamilyName = null;
                              _manualNoKk.clear();
                              _manualNamaKeluarga.clear();
                              _manualAlamatKeluarga.clear();
                              _manualFamilyTouched = false;
                            } else {
                              // existing family selected - autofill manual fields for convenience
                              final f = families.firstWhere((e) => e.noKk == v);
                              _selectedFamilyName = f.namaKeluarga;
                              _manualNoKk.text = f.noKk;
                              _manualNamaKeluarga.text = f.namaKeluarga;
                              _manualAlamatKeluarga.text = f.alamatRumah;
                              _manualFamilyTouched = false; // not user-edited yet
                            }
                          });
                        },
                        decoration: const InputDecoration(border: OutlineInputBorder(), hintText: '-- Pilih Keluarga --'),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text('Atau tambahkan keluarga baru (manual)', style: TextStyle(fontSize: 13, color: Colors.grey)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _manualNoKk,
                    decoration: const InputDecoration(labelText: 'No. KK (manual)', border: OutlineInputBorder()),
                    onChanged: (v) => setState(() {
                      _manualFamilyTouched = true;
                      _selectedFamilyNoKk = _manualFamilyValue; // switch to manual mode visually
                    }),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _manualNamaKeluarga,
                    decoration: const InputDecoration(labelText: 'Nama Keluarga (manual)', border: OutlineInputBorder()),
                    onChanged: (v) => setState(() => _manualFamilyTouched = true),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _manualAlamatKeluarga,
                    decoration: const InputDecoration(labelText: 'Alamat Keluarga (manual)', border: OutlineInputBorder()),
                    onChanged: (v) => setState(() => _manualFamilyTouched = true),
                  ),

                  const SizedBox(height: 16),

                  // RUMAH: dropdown + manual
                  const Text('Pilih Rumah (opsional)', style: TextStyle(fontSize: 14)),
                  const SizedBox(height: 8),
                  StreamBuilder<List<RumahModel>>(
                    stream: _rumahRepo.getAllRumah(),
                    builder: (context, snap) {
                      if (!snap.hasData) return const LinearProgressIndicator();
                      final rlist = snap.data!;
                      return DropdownButtonFormField<String>(
                        value: _selectedRumahId,
                        items: [
                          const DropdownMenuItem<String>(value: _manualRumahValue, child: Text('Belum ada (Tambah baru)')),
                          ...rlist.map((r) => DropdownMenuItem<String>(value: r.id, child: Text('${r.no} - ${r.alamat}'))).toList(),
                        ],
                        onChanged: (v) {
                          setState(() {
                            _selectedRumahId = v;
                            if (v == _manualRumahValue) {
                              _selectedRumahNo = null;
                              _manualRumahNo.clear();
                              _manualRumahAlamat.clear();
                              _manualRumahTouched = false;
                            } else {
                              final r = rlist.firstWhere((e) => e.id == v);
                              _selectedRumahNo = r.no;
                              // autofill manual rumah fields for convenience
                              _manualRumahNo.text = r.no;
                              _manualRumahAlamat.text = r.alamat;
                              _manualRumahTouched = false;
                            }
                          });
                        },
                        decoration: const InputDecoration(border: OutlineInputBorder(), hintText: '-- Pilih Rumah --'),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text('Atau tambahkan rumah baru (manual)', style: TextStyle(fontSize: 13, color: Colors.grey)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _manualRumahNo,
                    decoration: const InputDecoration(labelText: 'No. Rumah (manual)', border: OutlineInputBorder()),
                    onChanged: (v) => setState(() {
                      _manualRumahTouched = true;
                      _selectedRumahId = _manualRumahValue; // switch to manual mode visually
                    }),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _manualRumahAlamat,
                    decoration: const InputDecoration(labelText: 'Alamat Rumah (manual)', border: OutlineInputBorder()),
                    onChanged: (v) => setState(() => _manualRumahTouched = true),
                  ),

                  const SizedBox(height: 16),

                  // WARGA fields
                  const Text('Informasi Warga', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(controller: _namaController, decoration: const InputDecoration(labelText: 'Nama', border: OutlineInputBorder()), validator: (v) => v == null || v.isEmpty ? 'Nama wajib diisi' : null),
                  const SizedBox(height: 8),
                  TextFormField(controller: _nikController, decoration: const InputDecoration(labelText: 'NIK', border: OutlineInputBorder()), validator: (v) => v == null || v.isEmpty ? 'NIK wajib diisi' : null),
                  const SizedBox(height: 8),
                  Row(children: [Expanded(child: TextFormField(controller: _tanggalLahirController, readOnly: true, decoration: const InputDecoration(labelText: 'Tanggal Lahir', border: OutlineInputBorder()), onTap: () => _selectDate(context, _tanggalLahirController))), const SizedBox(width: 8), DropdownButton<String>(value: _jenisKelamin, items: const [DropdownMenuItem(value: 'Laki-laki', child: Text('Laki-laki')), DropdownMenuItem(value: 'Perempuan', child: Text('Perempuan'))], onChanged: (v) => setState(() => _jenisKelamin = v ?? 'Laki-laki'))]),

                  const SizedBox(height: 16),

                  // MUTASI fields
                  const Text('Informasi Mutasi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(controller: _tanggalMutasiController, readOnly: true, decoration: InputDecoration(labelText: 'Tanggal Mutasi', border: const OutlineInputBorder(), suffixIcon: IconButton(icon: const Icon(Icons.calendar_today), onPressed: () => _selectDate(context, _tanggalMutasiController))), validator: (v) => v == null || v.isEmpty ? 'Tanggal mutasi wajib diisi' : null),
                  const SizedBox(height: 8),
                  TextFormField(controller: _asalController, decoration: const InputDecoration(labelText: 'Asal (Alamat asal)', border: OutlineInputBorder())),
                  const SizedBox(height: 8),
                  TextFormField(controller: _keteranganController, decoration: const InputDecoration(labelText: 'Keterangan / Alasan', border: OutlineInputBorder())),

                  const SizedBox(height: 20),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [OutlinedButton(onPressed: () { _formKey.currentState?.reset(); _manualNoKk.clear(); _manualNamaKeluarga.clear(); _manualAlamatKeluarga.clear(); _manualRumahNo.clear(); _manualRumahAlamat.clear(); }, style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), side: const BorderSide(color: Colors.grey)), child: const Text('Reset', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))), ElevatedButton(onPressed: _submitForm, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C63FF), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))), child: const Text('Submit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))]),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
