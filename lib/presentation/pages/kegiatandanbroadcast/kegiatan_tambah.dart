import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:intl/intl.dart';

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
  final TextEditingController penanggungJawabController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  String? selectedKategori;

  @override
  void dispose() {
    namaController.dispose();
    tanggalController.dispose();
    lokasiController.dispose();
    penanggungJawabController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4F6DF5),
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
              // Nama Kegiatan
              TextFormField(
                controller: namaController,
                decoration: InputDecoration(
                  labelText: "Nama Kegiatan",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // kategori dropdown
              DropdownButtonFormField<String>(
                value: selectedKategori,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: "Kategori Kegiatan",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                ),
                hint: const Text("-- Pilih Kategori --"),
                items: const [
                  DropdownMenuItem(
                    value: "Komunitas & Sosial",
                    child: Text("Komunitas & Sosial"),
                  ),
                  DropdownMenuItem(
                    value: "Kebersihan & Keamanan",
                    child: Text("Kebersihan & Keamanan"),
                  ),
                  DropdownMenuItem(
                    value: "Keagamaan",
                    child: Text("Keagamaan"),
                  ),
                  DropdownMenuItem(
                    value: "Pendidikan",
                    child: Text("Pendidikan"),
                  ),
                  DropdownMenuItem(
                    value: "Kesehatan & Olah Raga",
                    child: Text("Kesehatan & Olah Raga"),
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
              const SizedBox(height: 16),

              // Tanggal
              TextFormField(
                controller: tanggalController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Tanggal Kegiatan",
                  suffixIcon: const Icon(Icons.calendar_today_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
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
                      tanggalController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              // Lokasi
              TextFormField(
                controller: lokasiController,
                decoration: InputDecoration(
                  labelText: "Lokasi",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Penanggung jawab
              TextFormField(
                controller: penanggungJawabController,
                decoration: InputDecoration(
                  labelText: "Penanggung Jawab",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              //deskripsi
              TextFormField(
                controller: deskripsiController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Deskripsi",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Tombol Submit dan Reset
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F6DF5),
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
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
