import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../core/models/mutasi_model.dart'; // Import model baru
import '../../../core/repositories/mutasi_repository.dart'; // Repository Firebase
import '../../../core/repositories/family_repository.dart';
import '../../../core/models/family_models.dart';

@RoutePage()
class TambahMutasiPage extends StatefulWidget {
  const TambahMutasiPage({super.key});

  @override
  State<TambahMutasiPage> createState() => _TambahMutasiPageState();
}

class _TambahMutasiPageState extends State<TambahMutasiPage> {
  final _formKey = GlobalKey<FormState>();
  final MutasiRepository _repo = MutasiRepository(); // repo untuk Firebase

  // Data untuk dropdown - sekarang menggunakan data dari model
  final List<String> _jenisMutasiOptions = [
    'Pindah Domisili',
    'Pindah Kota',
    'Pindah Provinsi',
    'Pindah Negara',
  ];

  // Repository untuk mengambil data keluarga dari Firestore
  final FamilyRepository _familyRepo = FamilyRepository();

  // Controller untuk form fields
  String? _selectedJenisMutasi;
  String? _selectedKeluargaNoKk; // menyimpan noKK keluarga yang dipilih
  final TextEditingController _alasanController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _alamatLamaController = TextEditingController();
  final TextEditingController _alamatBaruController = TextEditingController();

  // Fungsi untuk memilih tanggal
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _tanggalController.text =
            "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  // Fungsi reset form
  void _resetForm() {
    setState(() {
      _selectedJenisMutasi = null;
      _selectedKeluargaNoKk = null;
      _alasanController.clear();
      _tanggalController.clear();
      _alamatLamaController.clear();
      _alamatBaruController.clear();
    });
  }

  // Fungsi submit form — sekarang menyimpan ke Firebase (Firestore)
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Validasi tambahan
      if (_selectedKeluargaNoKk == null || _selectedJenisMutasi == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Harap pilih keluarga dan jenis mutasi'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Ambil data keluarga dari Firestore untuk alamat lama dan nama keluarga
      String keluargaDisplay = _selectedKeluargaNoKk ?? '';
      String defaultAlamatLama = '';
      if (_selectedKeluargaNoKk != null) {
        final family = await _familyRepo.getFamilyByNoKk(_selectedKeluargaNoKk!);
        if (family != null) {
          keluargaDisplay = family.namaKeluarga;
          defaultAlamatLama = family.alamatRumah;
        }
      }

      // Buat objek MutasiData baru
      // docId dikosongkan karena Firestore akan buatkan ID saat add
      final newMutasi = MutasiData(
        docId: '', // Firestore akan assign ID
        keluarga: keluargaDisplay,
        alamatLama: _alamatLamaController.text.isNotEmpty
            ? _alamatLamaController.text
            : defaultAlamatLama,
        alamatBaru: _alamatBaruController.text,
        tanggalMutasi: _tanggalController.text,
        jenisMutasi: _selectedJenisMutasi!,
        alasan: _alasanController.text,
      );

      try {
        // Simpan ke Firebase melalui repository
        await _repo.addMutasi(newMutasi);

        // Tampilkan snackbar sukses
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data mutasi berhasil ditambahkan'),
            backgroundColor: Colors.green,
          ),
        );

        // Reset form setelah submit
        _resetForm();

        // Navigasi kembali setelah delay singkat
        Future.delayed(const Duration(milliseconds: 1500), () {
          context.router.pop();
        });
      } catch (e) {
        // Jika gagal menyimpan ke Firebase — tampilkan pesan error.
        // (Jika ingin fallback ke dummy, perlu membuat dummy list menjadi mutable.)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan ke Firebase: $e'),
            backgroundColor: Colors.red,
          ),
        );
        // debug print
        debugPrint('Error addMutasi: $e');
      }
    }
  }

  // Fungsi untuk mendapatkan alamat lama berdasarkan keluarga yang dipilih (dari Firestore)
  Future<void> _onKeluargaChanged(String? selectedKeluargaNoKk) async {
    setState(() {
      _selectedKeluargaNoKk = selectedKeluargaNoKk;
    });

    if (selectedKeluargaNoKk != null) {
      final family = await _familyRepo.getFamilyByNoKk(selectedKeluargaNoKk);
      if (family != null) {
        setState(() {
          _alamatLamaController.text = family.alamatRumah;
        });
      } else {
        setState(() {
          _alamatLamaController.clear();
        });
      }
    } else {
      setState(() {
        _alamatLamaController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(20),
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          "Tambah Mutasi Keluarga",
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
                          "Isi form di bawah ini untuk mencatat mutasi keluarga",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Pilih Keluarga (Dropdown)
                      const Text(
                        "Pilih Keluarga",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      StreamBuilder<List<FamilyModel>>(
                        stream: _familyRepo.getAllFamilies(),
                        builder: (context, snapshot) {
                          final families = snapshot.data ?? [];
                          return DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              hintText: "Pilih Keluarga",
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 216, 216, 216),
                                  width: 1,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide(
                                  color: Color(0xFF6C63FF),
                                  width: 1.5,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 12,
                              ),
                            ),
                            value: _selectedKeluargaNoKk,
                            items: families.map((FamilyModel f) {
                              return DropdownMenuItem<String>(
                                value: f.noKk,
                                child: Text('${f.noKk} - ${f.namaKeluarga}'),
                              );
                            }).toList(),
                            onChanged: (val) => _onKeluargaChanged(val),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Pilih keluarga';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      // Alamat Lama (Auto-filled berdasarkan keluarga)
                      const Text(
                        "Alamat Lama",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _alamatLamaController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          hintText: "Alamat lama akan terisi otomatis...",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 216, 216, 216),
                              width: 1,
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
                          filled: true,
                          fillColor: Color(0xFFF8F9FA),
                        ),
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Alamat lama wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Alamat Baru (Text Field)
                      const Text(
                        "Alamat Baru",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _alamatBaruController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          hintText: "Masukkan alamat baru...",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 216, 216, 216),
                              width: 1,
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukkan alamat baru';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Pilih Jenis Mutasi (Dropdown)
                      const Text(
                        "Pilih Jenis Mutasi",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          hintText: "Pilih Jenis Mutasi",
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 216, 216, 216),
                              width: 1,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: Color(0xFF6C63FF),
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 12,
                          ),
                        ),
                        value: _selectedJenisMutasi,
                        items: _jenisMutasiOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedJenisMutasi = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Pilih jenis mutasi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Tanggal Mutasi (Date Picker)
                      const Text(
                        "Tanggal Mutasi",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _tanggalController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: "Pilih tanggal mutasi",
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () => _selectDate(context),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 216, 216, 216),
                              width: 1,
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: Color(0xFF6C63FF),
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 12,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Pilih tanggal mutasi';
                          }
                          return null;
                        },
                        onTap: () => _selectDate(context),
                      ),
                      const SizedBox(height: 20),

                      // Alasan Mutasi (Text Field)
                      const Text(
                        "Alasan Mutasi",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _alasanController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: "Masukkan alasan mutasi...",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 216, 216, 216),
                              width: 1,
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukkan alasan mutasi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),

                      // Tombol Submit dan Reset
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 120,
                            child: OutlinedButton(
                              onPressed: _resetForm,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                side: const BorderSide(color: Colors.grey),
                              ),
                              child: const Text(
                                "Reset",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 120,
                            child: ElevatedButton(
                              onPressed: _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6C63FF),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              child: const Text(
                                "Submit",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
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
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _alasanController.dispose();
    _tanggalController.dispose();
    _alamatLamaController.dispose();
    _alamatBaruController.dispose();
    super.dispose();
  }
}
