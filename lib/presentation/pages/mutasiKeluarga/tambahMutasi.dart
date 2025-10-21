import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'model_mutasi.dart'; // Import model baru

@RoutePage()
class TambahMutasiPage extends StatefulWidget {
  const TambahMutasiPage({super.key});

  @override
  State<TambahMutasiPage> createState() => _TambahMutasiPageState();
}

class _TambahMutasiPageState extends State<TambahMutasiPage> {
  final _formKey = GlobalKey<FormState>();

  // Data untuk dropdown - sekarang menggunakan data dari model
  final List<String> _jenisMutasiOptions = [
    'Pindah Domisili',
    'Pindah Kota',
    'Pindah Provinsi',
    'Pindah Negara',
  ];

  // Ambil daftar keluarga dari data dummy
  List<String> get _keluargaOptions {
    final keluargaSet = <String>{};
    for (var data in MutasiDataProvider.dummyData) {
      keluargaSet.add(data.keluarga);
    }
    return keluargaSet.toList();
  }

  // Controller untuk form fields
  String? _selectedJenisMutasi;
  String? _selectedKeluarga;
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
      _selectedKeluarga = null;
      _alasanController.clear();
      _tanggalController.clear();
      _alamatLamaController.clear();
      _alamatBaruController.clear();
    });
  }

  // Fungsi submit form
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Validasi tambahan
      if (_selectedKeluarga == null || _selectedJenisMutasi == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Harap pilih keluarga dan jenis mutasi'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Cari data keluarga yang dipilih untuk mendapatkan alamat lama
      final keluargaData = MutasiDataProvider.dummyData.firstWhere(
        (data) => data.keluarga == _selectedKeluarga,
        orElse: () => MutasiDataProvider.dummyData.first,
      );

      // Buat objek MutasiData baru
      final newMutasi = MutasiData(
        no: MutasiDataProvider.dummyData.length + 1, // Generate nomor baru
        keluarga: _selectedKeluarga!,
        alamatLama: _alamatLamaController.text.isNotEmpty
            ? _alamatLamaController.text
            : keluargaData.alamatLama,
        alamatBaru: _alamatBaruController.text,
        tanggalMutasi: _tanggalController.text,
        jenisMutasi: _selectedJenisMutasi!,
        alasan: _alasanController.text,
      );

      // Proses submit data (simulasi)
      print('Data mutasi baru:');
      print('No: ${newMutasi.no}');
      print('Keluarga: ${newMutasi.keluarga}');
      print('Alamat Lama: ${newMutasi.alamatLama}');
      print('Alamat Baru: ${newMutasi.alamatBaru}');
      print('Tanggal: ${newMutasi.tanggalMutasi}');
      print('Jenis Mutasi: ${newMutasi.jenisMutasi}');
      print('Alasan: ${newMutasi.alasan}');

      // Tampilkan snackbar sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data mutasi berhasil ditambahkan'),
          backgroundColor: Colors.green,
        ),
      );

      // Reset form setelah submit
      _resetForm();

      // Optional: Navigasi kembali setelah delay
      Future.delayed(const Duration(milliseconds: 1500), () {
        context.router.pop();
      });
    }
  }

  // Fungsi untuk mendapatkan alamat lama berdasarkan keluarga yang dipilih
  void _onKeluargaChanged(String? selectedKeluarga) {
    setState(() {
      _selectedKeluarga = selectedKeluarga;
    });

    if (selectedKeluarga != null) {
      // Cari data keluarga yang dipilih
      final keluargaData = MutasiDataProvider.dummyData.firstWhere(
        (data) => data.keluarga == selectedKeluarga,
        orElse: () => MutasiDataProvider.dummyData.first,
      );

      // Isi otomatis alamat lama
      _alamatLamaController.text = keluargaData.alamatLama;
    } else {
      _alamatLamaController.clear();
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
                      DropdownButtonFormField<String>(
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
                        value: _selectedKeluarga,
                        items: _keluargaOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: _onKeluargaChanged,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Pilih keluarga';
                          }
                          return null;
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