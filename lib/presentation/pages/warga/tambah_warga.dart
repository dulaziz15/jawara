import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class WargaTambahPage extends StatefulWidget {
  const WargaTambahPage({super.key});

  @override
  State<WargaTambahPage> createState() => _WargaTambahPageState();
}

class _WargaTambahPageState extends State<WargaTambahPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers untuk text fields
  final _namaController = TextEditingController();
  final _nikController = TextEditingController();
  final _teleponController = TextEditingController();
  final _tempatLahirController = TextEditingController();
  final _tanggalLahirController = TextEditingController();
  
  // Value notifiers untuk dropdowns
  final _keluargaValue = ValueNotifier<String?>(null);
  final _jenisKelaminValue = ValueNotifier<String?>(null);
  final _agamaValue = ValueNotifier<String?>(null);
  final _golonganDarahValue = ValueNotifier<String?>(null);
  final _peranKeluargaValue = ValueNotifier<String?>(null);
  final _pendidikanValue = ValueNotifier<String?>(null);
  final _pekerjaanValue = ValueNotifier<String?>(null);
  final _statusValue = ValueNotifier<String?>(null);

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    _teleponController.dispose();
    _tempatLahirController.dispose();
    _tanggalLahirController.dispose();
    _keluargaValue.dispose();
    _jenisKelaminValue.dispose();
    _agamaValue.dispose();
    _golonganDarahValue.dispose();
    _peranKeluargaValue.dispose();
    _pendidikanValue.dispose();
    _pekerjaanValue.dispose();
    _statusValue.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _namaController.clear();
    _nikController.clear();
    _teleponController.clear();
    _tempatLahirController.clear();
    _tanggalLahirController.clear();
    _keluargaValue.value = null;
    _jenisKelaminValue.value = null;
    _agamaValue.value = null;
    _golonganDarahValue.value = null;
    _peranKeluargaValue.value = null;
    _pendidikanValue.value = null;
    _pekerjaanValue.value = null;
    _statusValue.value = null;
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _tanggalLahirController.text = 
          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement save functionality
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil disimpan')),
      );
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
            // Header
            _buildHeader(),
            const SizedBox(height: 24),
            
            // Form Fields
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDropdownField(
                      label: 'Pilih Keluarga',
                      hint: '-- Pilih Keluarga --',
                      valueNotifier: _keluargaValue,
                      items: const ['Keluarga 1', 'Keluarga 2', 'Keluarga 3'],
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      label: 'Nama',
                      hint: 'Masukkan nama lengkap',
                      controller: _namaController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama harus diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      label: 'NIK',
                      hint: 'Masukkan NIK sesuai KTP',
                      controller: _nikController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'NIK harus diisi';
                        }
                        if (value.length != 16) {
                          return 'NIK harus 16 digit';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      label: 'Nomor Telepon',
                      hint: '08xxxxxx',
                      controller: _teleponController,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nomor telepon harus diisi';
                        }
                        if (!value.startsWith('08')) {
                          return 'Nomor telepon harus dimulai dengan 08';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      label: 'Tempat Lahir',
                      hint: 'Masukkan tempat lahir',
                      controller: _tempatLahirController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tempat lahir harus diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Tanggal Lahir
                    const Text('Tanggal Lahir', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _tanggalLahirController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: 'DD/MM/YYYY',
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red, size: 20),
                              onPressed: () => _tanggalLahirController.clear(),
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              icon: const Icon(Icons.check, color: Colors.green, size: 20),
                              onPressed: _selectDate,
                            ),
                          ],
                        ),
                      ),
                      readOnly: true,
                      onTap: _selectDate,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tanggal lahir harus diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildDropdownField(
                      label: 'Jenis Kelamin',
                      hint: '-- Pilih Jenis Kelamin --',
                      valueNotifier: _jenisKelaminValue,
                      items: const ['Laki-laki', 'Perempuan'],
                      validator: (value) {
                        if (value == null) {
                          return 'Jenis kelamin harus dipilih';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    _buildDropdownField(
                      label: 'Agama',
                      hint: '-- Pilih Agama --',
                      valueNotifier: _agamaValue,
                      items: const ['Islam', 'Kristen', 'Katolik', 'Hindu', 'Buddha', 'Konghucu'],
                    ),
                    const SizedBox(height: 16),

                    _buildDropdownField(
                      label: 'Golongan Darah',
                      hint: '-- Pilih Golongan Darah --',
                      valueNotifier: _golonganDarahValue,
                      items: const ['A', 'B', 'AB', 'O'],
                    ),
                    const SizedBox(height: 16),

                    _buildDropdownField(
                      label: 'Peran Keluarga',
                      hint: '-- Pilih Peran Keluarga --',
                      valueNotifier: _peranKeluargaValue,
                      items: const ['Kepala Keluarga', 'Istri', 'Anak', 'Lainnya'],
                    ),
                    const SizedBox(height: 16),

                    _buildDropdownField(
                      label: 'Pendidikan Terakhir',
                      hint: '-- Pilih Pendidikan Terakhir --',
                      valueNotifier: _pendidikanValue,
                      items: const ['SD', 'SMP', 'SMA', 'D3', 'S1', 'S2', 'S3'],
                    ),
                    const SizedBox(height: 16),

                    _buildDropdownField(
                      label: 'Pekerjaan',
                      hint: '-- Pilih Jenis Pekerjaan --',
                      valueNotifier: _pekerjaanValue,
                      items: const ['PNS', 'Swasta', 'Wiraswasta', 'Pelajar/Mahasiswa', 'Lainnya'],
                    ),
                    const SizedBox(height: 16),

                    _buildDropdownField(
                      label: 'Status',
                      hint: '-- Pilih Status --',
                      valueNotifier: _statusValue,
                      items: const ['Belum Kawin', 'Kawin', 'Cerai Hidup', 'Cerai Mati'],
                    ),
                    const SizedBox(height: 24),

                    // Action Buttons
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

  Widget _buildHeader() {
    return const Column(
      children: [
        SizedBox(height: 15),
        Center(
          child: Text(
            'Tambah Warga',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 16),
        Center(
          child: Text(
            'Form untuk menambahkan data warga',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: hint,
          ),
          keyboardType: keyboardType,
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required ValueNotifier<String?> valueNotifier,
    required List<String> items,
    String? Function(String?)? validator,
  }) {
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
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              hint: Text(hint),
              items: items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                valueNotifier.value = newValue;
              },
              validator: validator,
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
      // Reset Button
      TextButton(
        onPressed: _resetForm,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: const BorderSide(color: Colors.grey),
        ),
        child: const Text(
          'Reset',
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),

      // Submit Button
      ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6C63FF),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          'Submit',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    ],
  );
}
}