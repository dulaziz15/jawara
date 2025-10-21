import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class ChannelForm {
  String nama = '';
  String tipe = '';
  String nomorRekening = '';
  String an = '';
  String qr = '';
  String thumbnail = '';
  String catatan = '';

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'tipe': tipe,
      'nomorRekening': nomorRekening,
      'an': an,
      'qr': qr,
      'thumbnail': thumbnail,
      'catatan': catatan,
    };
  }
}


class TransferChannelController with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final ChannelForm channel = ChannelForm();

  void setNama(String? value) {
    channel.nama = value ?? '';
    notifyListeners();
  }

  void setTipe(String? value) {
    channel.tipe = value ?? '';
    notifyListeners();
  }

  void setNomorRekening(String? value) {
    channel.nomorRekening = value ?? '';
    notifyListeners();
  }

  void setAn(String? value) {
    channel.an = value ?? '';
    notifyListeners();
  }

  void setCatatan(String? value) {
    channel.catatan = value ?? '';
    notifyListeners();
  }

  void setQR(String path) {
    channel.qr = path;
    notifyListeners();
  }

  void setThumbnail(String path) {
    channel.thumbnail = path;
    notifyListeners();
  }

  void simpan(BuildContext context) {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Data Transfer Channel berhasil disimpan"),
          behavior: SnackBarBehavior.floating,
        ),
      );

      debugPrint("=== Data Channel ===");
      debugPrint(channel.toJson().toString());
    }
  }

  void resetForm() {
    formKey.currentState?.reset();
    channel
      ..nama = ''
      ..tipe = ''
      ..nomorRekening = ''
      ..an = ''
      ..qr = ''
      ..thumbnail = ''
      ..catatan = '';
    notifyListeners();
  }
}

/// ============================
/// VIEW
/// ============================
class ChannelTambahPage extends StatelessWidget {
  const ChannelTambahPage({Key? key}) : super(key: key);

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TransferChannelController(),
      child: Consumer<TransferChannelController>(
        builder: (context, controller, _) {
          return Scaffold(
            backgroundColor: const Color(0xfff8f9fc),
            body: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Card(
                  elevation: 3,
                  margin: const EdgeInsets.all(24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: controller.formKey,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          const Text(
                            'Buat Transfer Channel',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Nama Channel
                          TextFormField(
                            decoration: _inputDecoration(
                                'Nama Channel', 'Contoh: BCA, Dana, QRIS RT'),
                            onSaved: controller.setNama,
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Nama channel wajib diisi'
                                : null,
                          ),
                          const SizedBox(height: 16),

                          // Dropdown tipe
                          DropdownButtonFormField<String>(
                            decoration: _inputDecoration('Tipe', '-- Pilih Tipe --'),
                            value: controller.channel.tipe.isNotEmpty
                                ? controller.channel.tipe
                                : null,
                            items: const [
                              DropdownMenuItem(
                                  value: 'Bank', child: Text('Bank')),
                              DropdownMenuItem(
                                  value: 'E-Wallet', child: Text('E-Wallet')),
                              DropdownMenuItem(
                                  value: 'QRIS', child: Text('QRIS')),
                            ],
                            onChanged: controller.setTipe,
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Pilih tipe' : null,
                          ),
                          const SizedBox(height: 16),

                          // Nomor rekening
                          TextFormField(
                            decoration: _inputDecoration(
                                'Nomor Rekening / Akun', 'Contoh: 1234567890'),
                            keyboardType: TextInputType.number,
                            onSaved: controller.setNomorRekening,
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Nomor rekening wajib diisi'
                                : null,
                          ),
                          const SizedBox(height: 16),

                          // Nama Pemilik
                          TextFormField(
                            decoration: _inputDecoration(
                                'Nama Pemilik', 'Contoh: John Doe'),
                            onSaved: controller.setAn,
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Nama pemilik wajib diisi'
                                : null,
                          ),
                          const SizedBox(height: 24),

                          // Upload QR
                          Container(
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xfff2f2f2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: TextButton.icon(
                              onPressed: () async {
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                                if (image != null) {
                                  controller.setQR(image.path);
                                }
                              },
                              icon: const Icon(Icons.qr_code),
                              label: Text(
                                  controller.channel.qr.isNotEmpty
                                      ? 'Foto QR: ${path.basename(controller.channel.qr)}'
                                      : 'Upload foto QR (jika ada) png/jpeg/jpg'),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Upload Thumbnail
                          Container(
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xfff2f2f2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: TextButton.icon(
                              onPressed: () async {
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                                if (image != null) {
                                  controller.setThumbnail(image.path);
                                }
                              },
                              icon: const Icon(Icons.image_outlined),
                              label: Text(
                                  controller.channel.thumbnail.isNotEmpty
                                      ? 'Thumbnail: ${path.basename(controller.channel.thumbnail)}'
                                      : 'Upload thumbnail (jika ada) png/jpeg/jpg'),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Catatan opsional
                          TextFormField(
                            decoration: _inputDecoration(
                                'Catatan (Opsional)',
                                'Contoh: Transfer hanya dari bank yang sama agar instan'),
                            onSaved: controller.setCatatan,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 30),

                          // Tombol Simpan dan Reset
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: controller.resetForm,
                                  child: const Text('Reset'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff5a5af0),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () =>
                                      controller.simpan(context),
                                  child: const Text('Simpan'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
