class Channel {
  final int id;
  final int no;
  final String nama;
  final String tipe;
  final String an;
  final String thumbnail;
  final String qr;
  final String catatan;

  const Channel({
    required this.id,
    required this.no,
    required this.nama,
    required this.tipe,
    required this.an,
    required this.thumbnail,
    required this.qr,
    required this.catatan,
  });

  // ===============================================
  // 📥 Konversi dari Map (Firestore/JSON) ke Object
  // ===============================================
  factory Channel.fromMap(Map<String, dynamic> map) {
    return Channel(
      // ID bisa berupa String dari Firestore doc.id, jadi kita konversi ke int jika perlu
      id: map['id'] is String ? int.tryParse(map['id']!) ?? 0 : map['id'] as int,
      no: map['no'] as int,
      nama: map['nama'] as String,
      tipe: map['tipe'] as String,
      an: map['an'] as String,
      thumbnail: map['thumbnail'] as String,
      qr: map['qr'] as String,
      catatan: map['catatan'] as String,
    );
  }

  // ===============================================
  // 📤 Konversi dari Object ke Map (Untuk Firestore Write)
  // ===============================================
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'no': no,
      'nama': nama,
      'tipe': tipe,
      'an': an,
      'thumbnail': thumbnail,
      'qr': qr,
      'catatan': catatan,
    };
  }
}

const List<Channel> dummyChannels = [
  Channel(
    id: 1,
    no: 1,
    nama: 'Transfer via BCA',
    tipe: 'Bank',
    an: 'RT Jawara Karangploso',
    thumbnail: 'assets/channel/thumbnail/bri.png',
    qr: 'assets/channel/qr/default_qr.jpg',
    catatan: 'Gunakan transfer BCA untuk iuran warga.',
  ),
  Channel(
    id: 2,
    no: 2,
    nama: 'Copay Ketua RT',
    tipe: 'E-Wallet',
    an: 'Budi Santoso',
    thumbnail: 'assets/channel/thumbnail/ovo.png',
    qr: 'assets/channel/qr/default_qr.jpg',
    catatan: 'Bayar langsung ke Ketua RT.',
  ),
  Channel(
    id: 3,
    no: 3,
    nama: 'QRIS Resmi RT 08',
    tipe: 'QRIS',
    an: 'RW 08 Karangploso',
    thumbnail: 'assets/channel/thumbnail/qris.png',
    qr: 'assets/channel/qr/default_qr.jpg',
    catatan: 'Scan QR di bawah untuk membayar. Kirim bukti setelah pembayaran.',
  ),
];