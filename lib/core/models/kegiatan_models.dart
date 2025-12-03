  class KegiatanModel {
    String docId;
    String namaKegiatan, kategoriKegiatan, deskripsi, lokasi, dokumentasi;
    String penanggungJawabId; 
    String dibuatOlehId; 
    DateTime tanggalPelaksanaan;

    KegiatanModel({
      required this.docId,
      required this.namaKegiatan,
      required this.kategoriKegiatan,
      required this.penanggungJawabId, 
      required this.deskripsi,
      required this.tanggalPelaksanaan,
      required this.lokasi,
      required this.dibuatOlehId, 
      required this.dokumentasi,
    });

    // konversi dari map ke object
    factory KegiatanModel.fromMap(Map<String, dynamic> map) {
      return KegiatanModel(
        docId: map['docId'],
        namaKegiatan: map['nama_kegiatan'], // Diperbaiki
        tanggalPelaksanaan: DateTime.parse(map['tanggal_pelaksanaan']), // Diperbaiki
        kategoriKegiatan: map['kategori_kegiatan'], // Diperbaiki
        penanggungJawabId: map['penanggung_jawab_id'], // Menggunakan ID
        deskripsi: map['deskripsi'],
        lokasi: map['lokasi'],
        dibuatOlehId: map['dibuat_oleh_id'], // Menggunakan ID
        dokumentasi: map['dokumentasi'],
      );
    }

    // konversi dari object ke map
    Map<String, dynamic> toMap() {
      return {
        'docId': docId,
        'nama_kegiatan': namaKegiatan, // Diperbaiki
        'kategori_kegiatan': kategoriKegiatan, // Diperbaiki
        'penanggung_jawab_id': penanggungJawabId, // Menggunakan ID
        'deskripsi': deskripsi,
        'tanggal_pelaksanaan': tanggalPelaksanaan.toIso8601String(), // Diperbaiki
        'lokasi': lokasi,
        'dibuat_oleh_id': dibuatOlehId, // Menggunakan ID
        'dokumentasi': dokumentasi,
      };
    }
  }

  List<KegiatanModel> dummyKegiatan = [
    KegiatanModel(
      docId: '1',
      namaKegiatan: 'Workshop Flutter',
      kategoriKegiatan: 'Pelatihan',
      penanggungJawabId: '301', // ID John Doe
      deskripsi: 'Pelatihan pengembangan aplikasi menggunakan Flutter.',
      tanggalPelaksanaan: DateTime(2025, 10, 20),
      lokasi: 'Jakarta',
      dibuatOlehId: '101', // ID Admin Jawara
      dokumentasi: 'workshop_flutter.jpg',
    ),
    KegiatanModel(
      docId: '2',
      namaKegiatan: 'Seminar AI',
      kategoriKegiatan: 'Seminar',
      penanggungJawabId: '302', // ID Jane Smith
      deskripsi: 'Seminar tentang perkembangan Artificial Intelligence.',
      tanggalPelaksanaan: DateTime(2025, 10, 22),
      lokasi: 'Bandung',
      dibuatOlehId: '101', // ID Admin Jawara
      dokumentasi: 'seminar_ai.jpg',
    ),
    KegiatanModel(
      docId: '3',
      namaKegiatan: 'Hackathon 2025',
      kategoriKegiatan: 'Kompetisi',
      penanggungJawabId: '303', // ID Alice Johnson
      deskripsi: 'Kompetisi pengembangan aplikasi dalam waktu 24 jam.',
      tanggalPelaksanaan: DateTime(2025, 10, 25),
      lokasi: 'Surabaya',
      dibuatOlehId: '101', // ID Admin Jawara
      dokumentasi: 'hackathon_2025.jpg',
    ),
    KegiatanModel(
      docId: '4',
      namaKegiatan: 'Pelatihan UI/UX',
      kategoriKegiatan: 'Pelatihan',
      penanggungJawabId: '304', // ID Bob Brown
      deskripsi: 'Pelatihan desain antarmuka pengguna dan pengalaman pengguna.',
      tanggalPelaksanaan: DateTime(2025, 10, 28),
      lokasi: 'Yogyakarta',
      dibuatOlehId: '101', // ID Admin Jawara
      dokumentasi: 'pelatihan_uiux.jpg',
    ),
  ];