import 'package:flutter/material.dart';
import 'model_aspirasi.dart';

class EditAspirasiPage extends StatefulWidget {
  final AspirationData item;

  const EditAspirasiPage({super.key, required this.item});

  @override
  State<EditAspirasiPage> createState() => _EditAspirasiPageState();
}

class _EditAspirasiPageState extends State<EditAspirasiPage> {
  late TextEditingController _judulController;
  late TextEditingController _deskripsiController;
  String _status = '';

  final List<String> _statusOptions = ['Diterima', 'Pending', 'Diproses', 'Selesai'];

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.item.judul);
    _deskripsiController = TextEditingController(text: widget.item.deskripsi);
    _status = _statusOptions.contains(widget.item.status) ? widget.item.status : 'Pending';
  }

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    Navigator.pop(context);
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C63FF),
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
              // Judul Pesan
              TextField(
                controller: _judulController,
                decoration: _inputDecoration('Judul Pesan'),
              ),
              const SizedBox(height: 16),

              // Deskripsi Pesan
              TextField(
                controller: _deskripsiController,
                maxLines: 4,
                minLines: 2,
                decoration: _inputDecoration('Deskripsi Pesan'),
              ),
              const SizedBox(height: 16),

              // Status Dropdown
              DropdownButtonFormField<String>(
                value: _status,
                decoration: _inputDecoration('Status'),
                items: _statusOptions
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) => setState(() => _status = val ?? _status),
              ),
              const SizedBox(height: 24),

              // Tombol Update
              ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 4,
                ),
                child: const Text(
                  'Update',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}