import 'package:flutter/material.dart';
import 'package:jawara/core/models/warga_models.dart';

class WargaEditDialog extends StatefulWidget {
  final WargaModel item;
  final Function(WargaModel updatedItem) onSave;

  const WargaEditDialog({
    super.key,
    required this.item,
    required this.onSave,
  });

  @override
  State<WargaEditDialog> createState() => _WargaEditDialogState();
}

class _WargaEditDialogState extends State<WargaEditDialog> {
  late TextEditingController _nameController;
  late TextEditingController _nikController;
  late TextEditingController _keluargaController;
  
  String? _selectedGender;
  String? _selectedDomisili;
  String? _selectedHidup;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.nama);
    _nikController = TextEditingController(text: widget.item.nik);
    _keluargaController = TextEditingController(text: widget.item.keluarga);
    
    _selectedGender = widget.item.jenisKelamin;
    _selectedDomisili = widget.item.statusDomisili;
    _selectedHidup = widget.item.statusHidup;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nikController.dispose();
    _keluargaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      child: SingleChildScrollView(
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
                  const Text('Edit Data Warga', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6C63FF))),
                  IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close, color: Colors.grey)),
                ],
              ),
              const Divider(thickness: 1.2),
              const SizedBox(height: 16),
        
              // Forms
              _buildTextField('Nama', _nameController),
              const SizedBox(height: 12),
              _buildTextField('NIK', _nikController),
              const SizedBox(height: 12),
              _buildTextField('Keluarga', _keluargaController),
              const SizedBox(height: 12),
              
              _buildDropdown('Jenis Kelamin', _selectedGender, ['Laki-laki', 'Perempuan'], (val) => setState(() => _selectedGender = val)),
              const SizedBox(height: 12),
              _buildDropdown('Status Domisili', _selectedDomisili, ['Aktif', 'Non-Aktif'], (val) => setState(() => _selectedDomisili = val)),
              const SizedBox(height: 12),
              _buildDropdown('Status Hidup', _selectedHidup, ['Hidup', 'Meninggal', 'Wafat'], (val) => setState(() => _selectedHidup = val)),
              
              const SizedBox(height: 20),
        
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal')),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final updated = WargaModel(
                        docId: widget.item.docId,
                        nik: _nikController.text,
                        nama: _nameController.text,
                        keluarga: _keluargaController.text,
                        jenisKelamin: _selectedGender ?? 'Laki-laki',
                        statusDomisili: _selectedDomisili ?? 'Aktif',
                        statusHidup: _selectedHidup ?? 'Hidup',
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
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          value: items.contains(value) ? value : items.first,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
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