class KategoriIuranModel {
  final String docId;
  final String namaIuran;
  final double jumlah;
  final String kategoriIuran;

  const KategoriIuranModel({
    required this.docId,
    required this.namaIuran,
    required this.jumlah,
    required this.kategoriIuran,
  });

  // Konversi dari Map ke Object (untuk ambil dari Firebase)
  factory KategoriIuranModel.fromMap(Map<String, dynamic> map, String id) {
    return KategoriIuranModel(
      docId: id, // ID diambil dari dokumen ID Firestore
      namaIuran: map['nama_iuran'] ?? '',
      // Handle konversi int ke double agar aman
      jumlah: (map['jumlah'] is int) 
          ? (map['jumlah'] as int).toDouble() 
          : (map['jumlah'] ?? 0.0),
      kategoriIuran: map['kategori_iuran'] ?? 'Lainnya',
    );
  }

  // Konversi dari Object ke Map (untuk simpan ke Firebase)
  Map<String, dynamic> toMap() {
    return {
      'nama_iuran': namaIuran,
      'jumlah': jumlah,
      'kategori_iuran': kategoriIuran,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is KategoriIuranModel &&
      other.docId == docId; 
  }

  @override
  int get hashCode => docId.hashCode;
}

// ==========================================
// 5 DUMMY DATA (Jenis Iuran / Master Data)
// ==========================================
List<KategoriIuranModel> dummyKategoriIuran = [
  const KategoriIuranModel(
    docId: '1',
    namaIuran: 'Iuran Sampah & Kebersihan',
    jumlah: 25000.0,
    kategoriIuran: 'Kebersihan',
  ),
  const KategoriIuranModel(
    docId: '2',
    namaIuran: 'Iuran Keamanan (Satpam)',
    jumlah: 50000.0,
    kategoriIuran: 'Keamanan',
  ),
  const KategoriIuranModel(
    docId: '3',
    namaIuran: 'Iuran Kas RT/RW',
    jumlah: 10000.0,
    kategoriIuran: 'Operasional',
  ),
  const KategoriIuranModel(
    docId: '4',
    namaIuran: 'Dana Kematian',
    jumlah: 15000.0,
    kategoriIuran: 'Sosial',
  ),
  const KategoriIuranModel(
    docId: '5',
    namaIuran: 'Iuran Peringatan 17 Agustus',
    jumlah: 75000.0,
    kategoriIuran: 'Kegiatan',
  ),
];