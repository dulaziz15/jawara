import 'package:flutter/material.dart';
import '../../../core/models/aspirasi_models.dart';

class EditAspirasiPage extends StatefulWidget {
  final AspirasiModels item;

  const EditAspirasiPage({super.key, required this.item});

  @override
  State<EditAspirasiPage> createState() => _EditAspirasiPageState();
}

class _EditAspirasiPageState extends State<EditAspirasiPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _judulController;
  late TextEditingController _deskripsiController;
  String _status = '';

  final List<String> _statusOptions = [
    'Diterima',
    'Pending',
    'Diproses',
    'Selesai',
  ];

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.item.judul);
    _deskripsiController = TextEditingController(text: widget.item.deskripsi);
    _status = _statusOptions.contains(widget.item.status)
        ? widget.item.status
        : 'Pending';
  }

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  void _cancelForm() {
    // Kembali ke halaman utama tanpa menyimpan perubahan
    Navigator.pop(context);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Proses update data
      print('Judul: ${_judulController.text}');
      print('Deskripsi: ${_deskripsiController.text}');
      print('Status: $_status');

      // Tampilkan snackbar sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data aspirasi berhasil diupdate'),
          backgroundColor: Colors.green,
        ),
      );

      // Kembali ke halaman sebelumnya
      Navigator.pop(context);
    }
  }

  InputDecoration _inputDecoration(String label, {bool enabled = true}) {
    return InputDecoration(
      labelText: label,
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(
          color: Color.fromARGB(255, 216, 216, 216),
          width: 1,
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Color(0xFF6C63FF), width: 1.5),
      ),
      disabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(
          color: Color.fromARGB(255, 216, 216, 216),
          width: 1,
        ),
      ),
      filled: !enabled,
      fillColor: !enabled ? Colors.grey.shade100 : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
    );
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
                          "Edit Aspirasi Warga",
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
                          "Perbarui data aspirasi warga sesuai dengan informasi terbaru",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Judul Aspirasi (Disabled)
                      // const Text(
                      //   "Judul Aspirasi",
                      //   style: TextStyle(
                      //     fontSize: 14,
                      //   ),
                      // ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _judulController,
                        enabled: false, // Field tidak bisa diedit
                        decoration: _inputDecoration(
                          "Judul Aspirasi",
                          enabled: false,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Deskripsi Aspirasi (Disabled)
                      // const Text(
                      //   "Deskripsi Aspirasi",
                      //   style: TextStyle(
                      //     fontSize: 14,
                      //   ),
                      // ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _deskripsiController,
                        enabled: false, // Field tidak bisa diedit
                        maxLines: 4,
                        minLines: 3,
                        decoration: _inputDecoration(
                          "Deskripsi Aspirasi",
                          enabled: false,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Status Aspirasi (Dropdown) - Hanya ini yang bisa diedit
                      // const Text(
                      //   "Status Aspirasi",
                      //   style: TextStyle(
                      //     fontSize: 14,
                      //   ),
                      // ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        decoration: _inputDecoration("Pilih status"),
                        value: _status,
                        items: _statusOptions.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _status = newValue!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Pilih status aspirasi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),

                      // Informasi Pengirim (Read-only)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Informasi Pengirim",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Dikirim oleh: ${widget.item.pengirim}",
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Tanggal: ${widget.item.tanggal}",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Tombol Update dan Cancel
                                            Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Submit kanan, Cancel kiri
                        children: [
                          // Cancel Button - Paling Kiri
                          SizedBox(
                            width: 120,
                            child: OutlinedButton(
                              onPressed: _cancelForm,
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
                                "Cancel",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          // Submit Button - Paling Kanan
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
                                "Update",
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
}
