import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class TambahMutasiPage extends StatefulWidget {
  const TambahMutasiPage({super.key});

  @override
  State<TambahMutasiPage> createState() => _TambahMutasiPageState();
}

class _TambahMutasiPageState extends State<TambahMutasiPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Data untuk dropdown
  final List<String> _jenisMutasiOptions = [
    'Pindah Domisili',
    'Pindah Kota',
    'Pindah Provinsi',
    'Pindah Negara',
  ];
  
  final List<String> _keluargaOptions = [
    'Keluarga Rendha Putra Rahmadya',
    'Keluarga Anti Micin',
    'Keluarga varizky naldiba rimra',
    'Keluarga Ijat',
    'Keluarga Raudhli Firdaus Naufal',
  ];

  // Controller untuk form fields
  String? _selectedJenisMutasi;
  String? _selectedKeluarga;
  final TextEditingController _alasanController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  
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
        _tanggalController.text = "${picked.day}-${picked.month}-${picked.year}";
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
    });
  }

  // Fungsi submit form
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Proses submit data
      print('Jenis Mutasi: $_selectedJenisMutasi');
      print('Keluarga: $_selectedKeluarga');
      print('Alasan: ${_alasanController.text}');
      print('Tanggal: ${_tanggalController.text}');
      
      // Tampilkan snackbar sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data mutasi berhasil ditambahkan'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Reset form setelah submit
      _resetForm();
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
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedKeluarga = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Pilih keluarga';
                          }
                          return null;
                        },
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
                        decoration: InputDecoration(
                          hintText: "Masukkan alasan mutasi...",
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
                            return 'Masukkan alasan mutasi';
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
                      const SizedBox(height: 30),

                      // Tombol Submit dan Reset
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6C63FF),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
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
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _resetForm,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                side: const BorderSide(color: Colors.grey),
                              ),
                              child: const Text(
                                "Reset",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
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
    super.dispose();
  }
}