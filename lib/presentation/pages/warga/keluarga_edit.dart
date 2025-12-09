import 'package:flutter/material.dart';
import 'package:jawara/core/models/family_models.dart'; // Sesuaikan path import

class KeluargaEditDialog extends StatefulWidget {
  final FamilyModel item;
  final Function(FamilyModel updatedFamily) onSave;

  const KeluargaEditDialog({
    super.key,
    required this.item,
    required this.onSave,
  });

  @override
  State<KeluargaEditDialog> createState() => _KeluargaEditDialogState();
}

class _KeluargaEditDialogState extends State<KeluargaEditDialog> {
  late TextEditingController _namaKeluargaController;
  late TextEditingController _nikKepalaController;
  late TextEditingController _alamatRumahController;
  late TextEditingController _noKkController; // Biasanya NoKK Primary Key, tapi ditampilkan saja

  String? _selectedStatusKepemilikan;
  String? _selectedStatusDomisili;

  @override
  void initState() {
    super.initState();
    _noKkController = TextEditingController(text: widget.item.noKk);
    _namaKeluargaController = TextEditingController(text: widget.item.namaKeluarga);
    _nikKepalaController = TextEditingController(text: widget.item.nikKepalaKeluarga);
    _alamatRumahController = TextEditingController(text: widget.item.alamatRumah);
    
    // Validasi value dropdown agar sesuai opsi
    _selectedStatusKepemilikan = widget.item.statusKepemilikanRumah;
    _selectedStatusDomisili = widget.item.statusDomisiliKeluarga;
  }

  @override
  void dispose() {
    _namaKeluargaController.dispose();
    _nikKepalaController.dispose();
    _alamatRumahController.dispose();
    _noKkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Edit Data Keluarga',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6C63FF)),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(thickness: 1.2),
            const SizedBox(height: 16),

            // Form Fields
            _buildEditField('No KK (Tidak bisa diubah)', _noKkController, enabled: false), // KK biasanya key
            const SizedBox(height: 12),
            _buildEditField('Nama Keluarga', _namaKeluargaController),
            const SizedBox(height: 12),
            _buildEditField('NIK Kepala Keluarga', _nikKepalaController),
            const SizedBox(height: 12),
            _buildEditField('Alamat Rumah', _alamatRumahController),
            const SizedBox(height: 12),

            // Dropdown Status Kepemilikan
            _buildDropdown(
              'Status Kepemilikan',
              _selectedStatusKepemilikan,
              ['Milik Sendiri', 'Kontrak'],
              (val) => setState(() => _selectedStatusKepemilikan = val),
            ),
            const SizedBox(height: 12),

            // Dropdown Status Domisili
            _buildDropdown(
              'Status Domisili',
              _selectedStatusDomisili,
              ['Aktif', 'Nonaktif'],
              (val) => setState(() => _selectedStatusDomisili = val),
            ),
            const SizedBox(height: 20),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Batal'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // Buat object baru
                    final updated = FamilyModel(
                      docId: widget.item.docId,
                      noKk: _noKkController.text,
                      namaKeluarga: _namaKeluargaController.text,
                      nikKepalaKeluarga: _nikKepalaController.text,
                      alamatRumah: _alamatRumahController.text,
                      statusKepemilikanRumah: _selectedStatusKepemilikan ?? 'Milik Sendiri',
                      statusDomisiliKeluarga: _selectedStatusDomisili ?? 'Aktif',
                    );
                    
                    widget.onSave(updated);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C63FF)),
                  child: const Text('Simpan', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditField(String label, TextEditingController controller, {bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            filled: !enabled,
            fillColor: !enabled ? Colors.grey.shade100 : null,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: items.contains(value) ? value : items.first, // Fallback jika value null/tidak cocok
          items: items.map((status) => DropdownMenuItem(value: status, child: Text(status))).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }
}