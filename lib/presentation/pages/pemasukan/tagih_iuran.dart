import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:jawara/core/models/kategori_iuran_models.dart';
// Import Repository
import 'package:jawara/core/repositories/kategori_iuran_repository.dart';
import 'package:jawara/core/repositories/iuran_repository.dart';
import 'package:jawara/core/utils/formatter_util.dart';

@RoutePage()
class TagihIuranPage extends StatefulWidget {
  const TagihIuranPage({super.key});

  @override
  State<TagihIuranPage> createState() => _TagihIuranPageState();
}

class _TagihIuranPageState extends State<TagihIuranPage> {
  // 1. Inisialisasi Repository
  // Source: Untuk mengambil list data dropdown
  final KategoriIuranRepository _kategoriRepo = KategoriIuranRepository(); 
  // Destination: Untuk menyimpan tagihan
  final IuranRepository _iuranRepo = IuranRepository(); 

  KategoriIuranModel? selectedIuran;
  bool isLoading = false;

  void _resetForm() {
    setState(() {
      selectedIuran = null;
    });
  }

  Future<void> _tagihIuran() async {
    if (selectedIuran == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih jenis iuran terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // 2. Simpan ke collection 'iuran'
      await _iuranRepo.addTagihanIuran(selectedIuran!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Berhasil membuat tagihan iuran!'),
            backgroundColor: Colors.green,
          ),
        );
        _resetForm();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menagih: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Form Tagih Iuran',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Pilih jenis iuran yang akan ditagihkan ke semua keluarga aktif',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'Jenis Iuran',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // 3. STREAMBUILDER (Mengambil Data Firebase)
                    StreamBuilder<List<KategoriIuranModel>>(
                      stream: _kategoriRepo.getKategoriIuranStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red));
                        }
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: LinearProgressIndicator());
                        }

                        final dataList = snapshot.data ?? [];

                        if (dataList.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Belum ada Master Iuran. Silakan buat di menu Master Data.',
                              style: TextStyle(color: Colors.orange),
                            ),
                          );
                        }

                        return DropdownButtonFormField<KategoriIuranModel>(
                          // KARENA ADA OPERATOR ==, KITA BISA PAKAI OBJECT LANGSUNG
                          value: selectedIuran, 
                          isExpanded: true,
                          decoration: InputDecoration(
                            hintText: 'Pilih jenis iuran',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: Color(0xFF6C63FF),
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          items: dataList.map((iuran) {
                            return DropdownMenuItem<KategoriIuranModel>(
                              value: iuran,
                              child: Text(
                                '${iuran.namaIuran} - Rp ${FormatterUtil.formatCurrency(iuran.jumlah)}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (KategoriIuranModel? newValue) {
                            setState(() {
                              selectedIuran = newValue;
                            });
                          },
                        );
                      },
                    ),

                    // Detail Preview
                    if (selectedIuran != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Detail Iuran Terpilih:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('Nama: ${selectedIuran!.namaIuran}'),
                            Text('Kategori: ${selectedIuran!.kategoriIuran}'),
                            Text(
                              'Nominal: Rp ${FormatterUtil.formatCurrency(selectedIuran!.jumlah)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),
                    
                    // Tombol Aksi
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _resetForm,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              side: BorderSide(color: Colors.grey.shade400),
                            ),
                            child: const Text('Reset', style: TextStyle(color: Colors.black87)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _tagihIuran,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C63FF),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : const Text('Tagih Iuran', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}