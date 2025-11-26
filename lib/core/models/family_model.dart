class Family {
  final String noKk; // Nomor Kartu Keluarga
  final String namaKeluarga; // Nama Keluarga
  final String nikKepalaKeluarga; // NIK Kepala Keluarga (Nama Warga dapat diambil via relasi)
  final String alamatRumah; // Alamat Rumah
  final String statusKepemilikanRumah; // Status Kepemilikan Rumah
  final String statusDomisiliKeluarga; // Status Domisili Keluarga (Aktif/Nonaktif)

  Family({
    required this.noKk,
    required this.namaKeluarga,
    required this.nikKepalaKeluarga,
    required this.alamatRumah,
    required this.statusKepemilikanRumah,
    required this.statusDomisiliKeluarga,
  });

  // ===============================================
  // 📥 Konversi dari Map (Firestore/JSON) ke Object
  // ===============================================
  factory Family.fromMap(Map<String, dynamic> map) {
    return Family(
      noKk: map['noKk'] as String,
      namaKeluarga: map['namaKeluarga'] as String,
      nikKepalaKeluarga: map['nikKepalaKeluarga'] as String,
      alamatRumah: map['alamatRumah'] as String,
      statusKepemilikanRumah: map['statusKepemilikanRumah'] as String,
      statusDomisiliKeluarga: map['statusDomisiliKeluarga'] as String,
    );
  }

  // ===============================================
  // 📤 Konversi dari Object ke Map (Untuk Firestore Write)
  // ===============================================
  Map<String, dynamic> toMap() {
    return {
      'noKk': noKk,
      'namaKeluarga': namaKeluarga,
      'nikKepalaKeluarga': nikKepalaKeluarga,
      'alamatRumah': alamatRumah,
      'statusKepemilikanRumah': statusKepemilikanRumah,
      'statusDomisiliKeluarga': statusDomisiliKeluarga,
    };
  }

  // ===============================================
  // 📌 Dummy Families
  // ===============================================
  static final List<Family> dummyFamilies = [
    Family(
      noKk: '3501010101010001',
      namaKeluarga: 'Keluarga Surya',
      nikKepalaKeluarga: '1111111111111111',
      alamatRumah: 'Jl. Mawar No. 10, Malang',
      statusKepemilikanRumah: 'Milik Sendiri',
      statusDomisiliKeluarga: 'Aktif',
    ),
    Family(
      noKk: '3501010101010002',
      namaKeluarga: 'Keluarga Santoso',
      nikKepalaKeluarga: '2222222222222222',
      alamatRumah: 'Jl. Kenanga No. 21, Malang',
      statusKepemilikanRumah: 'Kontrak',
      statusDomisiliKeluarga: 'Aktif',
    ),
    Family(
      noKk: '3501010101010003',
      namaKeluarga: 'Keluarga Dewi',
      nikKepalaKeluarga: '3333333333333333',
      alamatRumah: 'Jl. Melati No. 33, Malang',
      statusKepemilikanRumah: 'Kontrak',
      statusDomisiliKeluarga: 'Nonaktif',
    ),
    Family(
      noKk: '3501010101010004',
      namaKeluarga: 'Keluarga Rahman',
      nikKepalaKeluarga: '4444444444444444',
      alamatRumah: 'Jl. Anggrek No. 18, Malang',
      statusKepemilikanRumah: 'Milik Sendiri',
      statusDomisiliKeluarga: 'Aktif',
    ),
  ];

  @override
  String toString() {
    return 'Family{noKk: $noKk, namaKeluarga: $namaKeluarga, nikKepalaKeluarga: $nikKepalaKeluarga, alamatRumah: $alamatRumah, statusKepemilikanRumah: $statusKepemilikanRumah, statusDomisiliKeluarga: $statusDomisiliKeluarga}';
  }
}
