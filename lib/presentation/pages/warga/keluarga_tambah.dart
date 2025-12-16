import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jawara/core/models/family_models.dart';
import 'package:jawara/core/repositories/family_repository.dart';

@RoutePage()
class KeluargaTambahPage extends StatefulWidget {
  const KeluargaTambahPage({super.key});

  @override
  State<KeluargaTambahPage> createState() => _KeluargaTambahPageState();
}

class _KeluargaTambahPageState extends State<KeluargaTambahPage> {
  final _formKey = GlobalKey<FormState>();
  final _noKkController = TextEditingController();
  final _namaKeluargaController = TextEditingController();
  final _nikKepalaController = TextEditingController();
  final _alamatController = TextEditingController();
  String _statusKepemilikan = 'Milik Sendiri';
  String _statusDomisili = 'Aktif';

  final FamilyRepository _repo = FamilyRepository();

  @override
  void dispose() {
    _noKkController.dispose();
    _namaKeluargaController.dispose();
    _nikKepalaController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final family = FamilyModel(
        docId: _noKkController.text,
        noKk: _noKkController.text,
        namaKeluarga: _namaKeluargaController.text,
        nikKepalaKeluarga: _nikKepalaController.text,
        alamatRumah: _alamatController.text,
        statusKepemilikanRumah: _statusKepemilikan,
        statusDomisiliKeluarga: _statusDomisili,
      );

      try {
        await _repo.addFamily(family);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Keluarga berhasil ditambahkan'), backgroundColor: Colors.green));
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Keluarga')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(controller: _noKkController, decoration: const InputDecoration(labelText: 'No KK', border: OutlineInputBorder()), validator: (v) => (v == null || v.isEmpty) ? 'No KK wajib diisi' : null),
              const SizedBox(height: 12),
              TextFormField(controller: _namaKeluargaController, decoration: const InputDecoration(labelText: 'Nama Keluarga', border: OutlineInputBorder()), validator: (v) => (v == null || v.isEmpty) ? 'Nama keluarga wajib diisi' : null),
              const SizedBox(height: 12),
              TextFormField(controller: _nikKepalaController, decoration: const InputDecoration(labelText: 'NIK Kepala Keluarga', border: OutlineInputBorder()), validator: (v) => (v == null || v.isEmpty) ? 'NIK kepala keluarga wajib diisi' : null),
              const SizedBox(height: 12),
              TextFormField(controller: _alamatController, decoration: const InputDecoration(labelText: 'Alamat Rumah', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(value: _statusKepemilikan, items: const [DropdownMenuItem(value: 'Milik Sendiri', child: Text('Milik Sendiri')), DropdownMenuItem(value: 'Kontrak', child: Text('Kontrak')), DropdownMenuItem(value: 'Sewa', child: Text('Sewa'))], onChanged: (v) => setState(() => _statusKepemilikan = v ?? _statusKepemilikan), decoration: const InputDecoration(labelText: 'Status Kepemilikan', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(value: _statusDomisili, items: const [DropdownMenuItem(value: 'Aktif', child: Text('Aktif')), DropdownMenuItem(value: 'Nonaktif', child: Text('Nonaktif'))], onChanged: (v) => setState(() => _statusDomisili = v ?? _statusDomisili), decoration: const InputDecoration(labelText: 'Status Domisili', border: OutlineInputBorder())),
              const SizedBox(height: 20),
              Row(children: [Expanded(child: OutlinedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal'))), const SizedBox(width: 12), Expanded(child: ElevatedButton(onPressed: _submit, child: const Text('Simpan')))]),
            ],
          ),
        ),
      ),
    );
  }
}
