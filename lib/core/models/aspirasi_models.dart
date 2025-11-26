class AspirasiModels {
  final String docId;
  final String judul;
  final String deskripsi;
  final String status;
  final String pengirim;
  final String tanggal;

  const AspirasiModels({
    required this.docId,
    required this.judul,
    required this.deskripsi,
    required this.status,
    required this.pengirim,
    required this.tanggal,
  });

  // konversi dari map ke object
  factory AspirasiModels.fromMap(Map<String, dynamic> map) {
    return AspirasiModels(
      docId: map['docId'],
      judul: map['judulBroadcast'],
      deskripsi: map['isiPesan'],
      status: map['kategoriBroadcast'],
      pengirim: map['dibuatOlehId'], // Menggunakan ID
      tanggal: DateTime.parse(map['tanggalPublikasi']).toIso8601String(),
    );
  }

  // konversi dari object ke map
  Map<String, dynamic> toMap() {
    return {
      'docId': docId,
      'judulBroadcast': judul,
      'isiPesan': deskripsi,
      'kategoriBroadcast': status,
      'tanggalPublikasi': DateTime.parse(tanggal).toIso8601String(),
      'dibuatOlehId': pengirim, 
     };
  }
}

final List<AspirasiModels> allAspirasi = [
  AspirasiModels(
    docId: '1',
    judul: 'Lampu jalan di persimpangan padam',
    deskripsi:
        'Pada hari minggu malam saya cek lampu nya berkedip kemudian keesokan hari nya lampu sudah mati total',
    status: 'Pending',
    pengirim: 'Tono',
    tanggal: '10-10-2025',
  ),
  AspirasiModels(
    docId: '2',
    judul: 'Tempat sampah kurang',
    deskripsi: 'aku hanya ingin pergi ke wisata kota yang ada di malang',
    status: 'Diproses',
    pengirim: 'Budi Doremi',
    tanggal: '12-10-2025',
  ),
  AspirasiModels(
    docId: '3',
    judul: 'Pipa bocor',
    deskripsi: 'pipa bocor karena tidak sengaja saat penggalian tanah',
    status: 'Diproses',
    pengirim: 'Ehsan',
    tanggal: '13-10-2025',
  ),
  AspirasiModels(
    docId: '4',
    judul: 'Jalan rusak',
    deskripsi: 'Jalan rusak akibat ada truk tronton lewat dini hari',
    status: 'Selesai',
    pengirim: 'Darmini',
    tanggal: '01-09-2025',
  ),
  AspirasiModels(
    docId: '5',
    judul: 'Jalan rusak 2',
    deskripsi: 'Jalan rusak akibat ada truk tronton lewat dini hari',
    status: 'Selesai',
    pengirim: 'Darmini',
    tanggal: '01-09-2025',
  ),
];
