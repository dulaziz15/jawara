import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jawara/core/models/aspirasi_models.dart';
import 'package:jawara/core/repositories/aspirasi_repository.dart';

@RoutePage()
class AspirasiEditPage extends StatefulWidget {
  // Ubah parameter dari object 'item' menjadi String 'aspirasiId'
  final String aspirasiId; 

  const AspirasiEditPage({
    super.key,
    // @PathParam('id') // Uncomment jika menggunakan path param di router
    required this.aspirasiId,
  });

  @override
  State<AspirasiEditPage> createState() => _AspirasiEditPageState();
}

class _AspirasiEditPageState extends State<AspirasiEditPage> {
  final AspirasiRepository _repository = AspirasiRepository();
  final _formKey = GlobalKey<FormState>();

  // Controller
  late TextEditingController _judulController;
  late TextEditingController _deskripsiController;
  
  // State Data
  String _status = 'Pending'; // Default
  String _pengirimInfo = '-';
  String _tanggalInfo = '-';

  // State Loading
  bool _isLoading = true;
  bool _isSaving = false;

  final List<String> _statusOptions = [
    'Pending',
    'Diproses',
    'Selesai',
    'Ditolak',
    'Diterima'
  ];

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController();
    _deskripsiController = TextEditingController();
    
    // Panggil data by ID
    _loadData(); 
  }

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  // --- LOGIC LOAD DATA ---
  Future<void> _loadData() async {
    try {
      final data = await _repository.getAspirasiByDocId(widget.aspirasiId);
      
      if (data != null) {
        setState(() {
          _judulController.text = data.judul;
          _deskripsiController.text = data.deskripsi;
          _pengirimInfo = data.pengirim;
          _tanggalInfo = data.tanggal;
          
          // Pastikan status valid, jika tidak, default ke Pending
          _status = _statusOptions.contains(data.status) 
              ? data.status 
              : 'Pending';
          
          _isLoading = false;
        });
      } else {
        // Handle jika data tidak ditemukan (misal sudah dihapus orang lain)
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Data aspirasi tidak ditemukan")),
          );
          context.router.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memuat data: $e")),
        );
      }
    }
  }

  // --- LOGIC SAVE DATA ---
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      // Buat model baru untuk update
      // Kita perlu mengirim semua field agar sesuai dengan model toMap()
      // atau buat method update khusus di repo yang hanya terima map parsial.
      final updatedAspirasi = AspirasiModels(
        docId: widget.aspirasiId,
        judul: _judulController.text,
        deskripsi: _deskripsiController.text,
        pengirim: _pengirimInfo, // Tetap gunakan data lama
        tanggal: _tanggalInfo,   // Tetap gunakan data lama
        status: _status,
      );

      await _repository.updateAspirasi(updatedAspirasi);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil diperbarui'), backgroundColor: Colors.green),
        );
        context.router.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _cancelForm() => context.router.pop();

  InputDecoration _inputDecoration(String label, {bool enabled = true}) {
    return InputDecoration(
      labelText: label,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color.fromARGB(255, 216, 216, 216)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 1.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color.fromARGB(255, 230, 230, 230)),
      ),
      filled: !enabled,
      fillColor: !enabled ? Colors.grey.shade100 : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tampilan Loading
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      // Optional: Tambah AppBar jika mau back button standard
      // appBar: AppBar(...), 
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(20),
                width: 550, // Max width untuk tampilan desktop/tablet
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text("Edit Aspirasi Warga",
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 30),

                      // Judul (Read Only / Editable tergantung kebutuhan)
                      TextFormField(
                        controller: _judulController,
                        enabled: false, // Biasanya judul aspirasi warga tidak diedit admin
                        decoration: _inputDecoration("Judul Aspirasi", enabled: false),
                      ),
                      const SizedBox(height: 20),

                      // Deskripsi (Read Only)
                      TextFormField(
                        controller: _deskripsiController,
                        enabled: false,
                        maxLines: 4,
                        decoration: _inputDecoration("Deskripsi", enabled: false),
                      ),
                      const SizedBox(height: 20),

                      // STATUS (Editable)
                      const Text("Status Aspirasi", style: TextStyle(fontWeight: FontWeight.bold)),
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
                          setState(() => _status = newValue!);
                        },
                      ),
                      const SizedBox(height: 30),

                      // Info Pengirim
                      Container(
                        padding: const EdgeInsets.all(16),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Dikirim oleh: $_pengirimInfo", style: const TextStyle(fontSize: 14)),
                            const SizedBox(height: 4),
                            Text("Tanggal: $_tanggalInfo", style: const TextStyle(fontSize: 14, color: Colors.grey)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 120,
                            child: OutlinedButton(
                              onPressed: _isSaving ? null : _cancelForm,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                            ),
                          ),
                          SizedBox(
                            width: 120,
                            child: ElevatedButton(
                              onPressed: _isSaving ? null : _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6C63FF),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                              child: _isSaving
                                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : const Text("Update", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
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