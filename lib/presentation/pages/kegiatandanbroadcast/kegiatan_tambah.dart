import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class KegiatanTambahPage extends StatelessWidget {
  const KegiatanTambahPage({super.key});

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
                        "Buat Kegiatan Baru",
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
                        "Isi form di bawah ini untuk mencatat kegiatan",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Nama Kegiatan
                    const Text("Nama Kegiatan"),
                    const SizedBox(height: 5),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Contoh: Musyawarah warga",
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 216, 216, 216),
                            width: 0,
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
                    ),
                    const SizedBox(height: 15),

                    // kategori dropdown
                    const Text("Kategori Kegiatan"),
                    const SizedBox(height: 5),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: const InputDecoration(
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
                      onChanged: (String? newValue) {},
                    ),
                    const SizedBox(height: 15),

                    // Tanggal 
                    const Text("Tanggal Kegiatan"),
                    const SizedBox(height: 5),
                    TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: "--/--/----",
                        suffixIcon: const Icon(Icons.calendar_today_outlined),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 216, 216, 216),
                            width: 0,
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
                      onTap: () async {
                        await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                      },
                    ),
                    const SizedBox(height: 15),

                    // Lokasi
                    const SizedBox(height: 5),
                    const Text("Isi Lokasi"),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Contoh: Balai RT 03",
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 216, 216, 216),
                            width: 0,
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
                    ),
                    const SizedBox(height: 15),

                    // Penanggung jawab
                    const SizedBox(height: 5),
                    const Text("Penanggung Jawab"),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Contoh : Pak RT atau Bu RW",
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 216, 216, 216),
                            width: 0,
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
                    ),
                    const SizedBox(height: 15),

                    //deskripsi
                    const SizedBox(height: 5),
                    const Text("Isi Deskripsi"),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Tulis detail event seperti agenda, keperluan, dll. ",
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 216, 216, 216),
                            width: 0,
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
                    ),
                    const SizedBox(height: 15),

                    // Tombol Submit dan Reset
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
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
