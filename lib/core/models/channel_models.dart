class ChannelModel {
  final String docId;
  final String nama;
  final String tipe;
  final String an;
  final String thumbnail;
  final String qr;
  final String catatan;

  const ChannelModel({
    required this.docId,
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
  factory ChannelModel.fromMap(Map<String, dynamic> map) {
    return ChannelModel(
      docId: map['docId'] as String,
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
      'docId': docId,
      'nama': nama,
      'tipe': tipe,
      'an': an,
      'thumbnail': thumbnail,
      'qr': qr,
      'catatan': catatan,
    };
  }
}

const List<ChannelModel> dummyChannels = [
  ChannelModel(
    docId: "1",
    nama: 'Transfer via BCA',
    tipe: 'Bank',
    an: 'RT Jawara Karangploso',
    thumbnail: 'assets/channel/thumbnail/bri.png',
    qr: 'assets/channel/qr/default_qr.jpg',
    catatan: 'Gunakan transfer BCA untuk iuran warga.',
  ),
  ChannelModel(
    docId: "2",
    nama: 'Copay Ketua RT',
    tipe: 'E-Wallet',
    an: 'Budi Santoso',
    thumbnail: 'assets/channel/thumbnail/ovo.png',
    qr: 'assets/channel/qr/default_qr.jpg',
    catatan: 'Bayar langsung ke Ketua RT.',
  ),
  ChannelModel(
    docId: "3",
    nama: 'QRIS Resmi RT 08',
    tipe: 'QRIS',
    an: 'RW 08 Karangploso',
    thumbnail: 'assets/channel/thumbnail/qris.png',
    qr: 'assets/channel/qr/default_qr.jpg',
    catatan: 'Scan QR di bawah untuk membayar. Kirim bukti setelah pembayaran.',
  ),
];