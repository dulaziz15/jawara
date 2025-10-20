import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/core/models/channel_models.dart';

@RoutePage()
class ChannelEditPage extends StatefulWidget {
  final int channelId;
  const ChannelEditPage({super.key, required this.channelId});

  @override
  State<ChannelEditPage> createState() => _ChannelEditPageState();
}

class _ChannelEditPageState extends State<ChannelEditPage> {
  final _formKey = GlobalKey<FormState>();

  // Controller
  late TextEditingController namaController;
  late TextEditingController tipeController;
  late TextEditingController pemilikController;
  late TextEditingController catatanController;

  late Channel currentChannel;

  @override
  void initState() {
    super.initState();
    _loadChannelData(widget.channelId);
  }

  void _loadChannelData(int id) {
    // Ambil data dari model dummyChannels
    currentChannel = dummyChannels.firstWhere(
      (c) => c.id == id,
      orElse: () => throw Exception("Channel dengan ID $id tidak ditemukan"),
    );

    // Isi controller dengan data model
    namaController = TextEditingController(text: currentChannel.nama);
    tipeController = TextEditingController(text: currentChannel.tipe);
    pemilikController = TextEditingController(text: currentChannel.an);
    catatanController = TextEditingController(
      text: 'Gunakan ${currentChannel.nama} untuk transaksi warga.',
    );
  }

  void _simpanPerubahan() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Perubahan channel "${namaController.text}" berhasil disimpan!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul
                  const Text(
                    'Edit Transfer Channel',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Nama Channel
                  const Text('Nama Channel', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: namaController,
                    decoration: const InputDecoration(
                      hintText: 'Masukkan nama channel',
                      border: OutlineInputBorder(),
                    ),
                    validator: (val) => val!.isEmpty ? 'Nama channel wajib diisi' : null,
                  ),
                  const SizedBox(height: 16),

                  // Tipe
                  const Text('Tipe', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: tipeController,
                    decoration: const InputDecoration(
                      hintText: 'Masukkan tipe channel',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nama Pemilik
                  const Text('Nama Pemilik', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: pemilikController,
                    decoration: const InputDecoration(
                      hintText: 'Masukkan nama pemilik',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Catatan
                  const Text('Catatan (Opsional)', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: catatanController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Tambahkan catatan tambahan...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tombol Simpan & Reset
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => _formKey.currentState?.reset(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: const Text('Reset'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _simpanPerubahan,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: const Text('Simpan', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
