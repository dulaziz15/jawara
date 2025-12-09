import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

// Import Repository
import 'package:jawara/core/repositories/rumah_repository.dart';

@RoutePage()
class RumahTambahPage extends StatefulWidget {
  const RumahTambahPage({super.key});

  @override
  State<RumahTambahPage> createState() => _RumahTambahPageState();
}

class _RumahTambahPageState extends State<RumahTambahPage> {
  // Inisialisasi Repository
  final RumahRepository _repo = RumahRepository();

  final _formKey = GlobalKey<FormState>();
  
  // Controller Fields
  final _noController = TextEditingController(); // BARU: Controller No Rumah
  final _alamatController = TextEditingController();
  final _statusController = TextEditingController(text: 'Ditempati');

  // Loading State
  bool _isLoading = false;

  final List<String> _statusOptions = ['Ditempati', 'Tersedia'];

  @override
  void dispose() {
    _noController.dispose();
    _alamatController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  // LOGIKA SUBMIT KE DATABASE
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Mulai loading
      });

      try {
        // Panggil Repository untuk simpan ke Firestore
        await _repo.addRumah(
          _noController.text,
          _alamatController.text,
          _statusController.text,
        );

        if (!mounted) return;

        // Tampilkan snackbar sukses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Rumah No "${_noController.text}" berhasil ditambahkan'),
            backgroundColor: Colors.green,
          ),
        );

        // Reset form
        _resetForm();
        
        // Opsional: Kembali ke halaman daftar setelah simpan
        // context.router.pop(); 

      } catch (e) {
        // Tampilkan error jika gagal
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false; // Stop loading
          });
        }
      }
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    _noController.clear();
    _alamatController.clear();
    _statusController.text = 'Ditempati';
  }

  void _showStatusPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Pilih Status',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ..._statusOptions.map((status) => ListTile(
                    title: Text(status),
                    leading: Radio<String>(
                      value: status,
                      groupValue: _statusController.text,
                      onChanged: (String? value) {
                        setState(() {
                          _statusController.text = value!;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    onTap: () {
                      setState(() {
                        _statusController.text = status;
                      });
                      Navigator.pop(context);
                    },
                  )),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Tambah Rumah Baru',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2D3748)),
              ),
              const SizedBox(height: 8),
              const Text(
                'Isi form berikut untuk menambahkan data rumah baru',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // --- FIELD NO RUMAH (BARU) ---
              const Text(
                'Nomor Rumah',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2D3748)),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _noController,
                decoration: _inputDecoration('Masukkan nomor rumah (misal: 12A)...'),
                style: const TextStyle(fontSize: 16),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor rumah harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // --- FIELD ALAMAT ---
              const Text(
                'Alamat Jalan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2D3748)),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _alamatController,
                decoration: _inputDecoration('Masukkan nama jalan...'),
                style: const TextStyle(fontSize: 16),
                maxLines: 2,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat harus diisi';
                  }
                  if (value.length < 3) {
                    return 'Alamat minimal 3 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // --- FIELD STATUS ---
              const Text(
                'Status',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2D3748)),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _showStatusPicker,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade50,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _statusController.text,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Icon(Icons.arrow_drop_down, color: Colors.grey.shade600, size: 24),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // --- ACTION BUTTONS ---
              Row(
                children: [
                  // Reset Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : _resetForm, // Disable saat loading
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: const Text('Reset', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2D3748))),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Submit Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm, // Disable saat loading
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20, width: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text(
                              'Simpan',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),

              // Info Section
              const SizedBox(height: 40),
              _buildInfoBox(),
            ],
          ),
        ),
      ),
    );
  }

  // Helper untuk style input agar rapi
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2)),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade600, size: 20),
              const SizedBox(width: 8),
              const Text('Informasi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2D3748))),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Pastikan nomor rumah unik agar mudah dicari.',
            style: TextStyle(fontSize: 14, color: Color(0xFF4A5568)),
          ),
        ],
      ),
    );
  }
}