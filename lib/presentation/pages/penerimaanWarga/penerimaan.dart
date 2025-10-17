import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

// --- DATA MODEL ---
class RegistrationData {
  final int no;
  final String nama;
  final String nik;
  final String email;
  final String jenisKelamin; // 'L' atau 'P'
  final String fotoIdentitasAsset;
  final String statusRegistrasi;

  const RegistrationData({
    required this.no,
    required this.nama,
    required this.nik,
    required this.email,
    required this.jenisKelamin,
    required this.fotoIdentitasAsset,
    required this.statusRegistrasi,
  });
}

@RoutePage()
class PenerimaanPage extends StatefulWidget {
  const PenerimaanPage({super.key});

  @override
  State<PenerimaanPage> createState() => _PenerimaanPageState();
}

class _PenerimaanPageState extends State<PenerimaanPage> {
  final ScrollController _scrollController = ScrollController();
  int? _expandedIndex;

  final List<RegistrationData> _data = const [
    RegistrationData(
      no: 1,
      nama: 'Indah Dwi Ratna',
      nik: '3505115120400002',
      email: 'indah20@gmail.com',
      jenisKelamin: 'P',
      fotoIdentitasAsset: 'assets/1.png',
      statusRegistrasi: 'Pending',
    ),
    RegistrationData(
      no: 2,
      nama: 'Sinta Sulistya',
      nik: '1234567890987654',
      email: 'Sisulis13@gmail.com',
      jenisKelamin: 'P',
      fotoIdentitasAsset: 'assets/2.png',
      statusRegistrasi: 'Pending',
    ),
    RegistrationData(
      no: 3,
      nama: 'Intan Sari',
      nik: '2025202520252025',
      email: 'sariIntan@gmail.com',
      jenisKelamin: 'P',
      fotoIdentitasAsset: 'assets/3.png',
      statusRegistrasi: 'Diterima',
    ),
    RegistrationData(
      no: 4,
      nama: 'Abdul Aziz',
      nik: '3201122501050002',
      email: 'dulaziz@gmail.com',
      jenisKelamin: 'L',
      fotoIdentitasAsset: 'assets/4.png',
      statusRegistrasi: 'Diterima',
    ),
  ];

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    switch (status.toLowerCase()) {
      case 'pending':
        bgColor = Colors.yellow.shade200;
        break;
      case 'diterima':
        bgColor = Colors.green.shade200;
        break;
      default:
        bgColor = Colors.grey.shade300;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    Widget valueWidget, {
    CrossAxisAlignment alignment = CrossAxisAlignment.center,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: alignment,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(child: valueWidget),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_left)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              '1',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_right)),
        ],
      ),
    );
  }

  Widget _buildRow(RegistrationData item, int index) {
    final isExpanded = _expandedIndex == index;

    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() => _expandedIndex = isExpanded ? null : index);
          },
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                SizedBox(width: 40, child: Text(item.no.toString())),
                Expanded(
                  child: Text(
                    item.nama,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: _buildStatusBadge(item.statusRegistrasi),
                ),
                Icon(
                  isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: Colors.deepPurple,
                ),
              ],
            ),
          ),
        ),

        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: isExpanded
              ? Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('NIK',
                          Text(item.nik, style: const TextStyle(color: Colors.black54))),
                      _buildDetailRow('Email',
                          Text(item.email, style: const TextStyle(color: Colors.black54))),
                      _buildDetailRow(
                        'Jenis Kelamin',
                        Text(
                          item.jenisKelamin == 'L' ? 'Laki-laki' : 'Perempuan',
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ),
                      _buildDetailRow(
                        'Foto Identitas',
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey.shade200,
                            child: Image.asset(
                              item.fotoIdentitasAsset,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        alignment: CrossAxisAlignment.start,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () =>
                                debugPrint('Tinjau Pendaftaran ${item.no}'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                            ),
                            child: const Text('Tinjau',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
        if (index < _data.length - 1)
          Divider(height: 1, color: Colors.grey.shade300),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Daftar Warga',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Icon(Icons.filter_list, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Kontainer Tabel
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Header tabel
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade50,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: const Row(
                          children: [
                            SizedBox(
                              width: 40,
                              child: Text(
                                'NO',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'NAMA',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple),
                              ),
                            ),
                            SizedBox(
                              width: 80,
                              child: Text(
                                'STATUS',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple),
                              ),
                            ),
                            SizedBox(width: 24),
                          ],
                        ),
                      ),

                      // Daftar data
                      ...List.generate(
                        _data.length,
                        (index) => _buildRow(_data[index], index),
                      ),

                      // Divider dan pagination langsung di bawah tabel
                      Divider(height: 1, color: Colors.grey.shade300),
                      _buildPagination(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
