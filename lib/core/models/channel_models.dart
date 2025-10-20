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
}

const List<Channel> dummyChannels = [
  Channel(
    id: 1,
    no: 1,
    nama: 'Transfer via BCA',
    tipe: 'Bank',
    an: 'RT Jawara Karangploso',
    thumbnail: 'Channel/assets/thumbnail/bri.png',
    qr: '',
    catatan: 'Gunakan transfer BCA untuk iuran warga.',
  ),
  Channel(
    id: 2,
    no: 2,
    nama: 'Copay Ketua RT',
    tipe: 'E-Wallet',
    an: 'Budi Santoso',
    thumbnail: 'Channel/assets/thumbnail/ovo.png',
    qr: '',
    catatan: 'Bayar langsung ke Ketua RT.',
  ),
  Channel(
    id: 3,
    no: 3,
    nama: 'QRIS Resmi RT 08',
    tipe: 'QRIS',
    an: 'RW 08 Karangploso',
    thumbnail: 'Channel/assets/thumbnail/qris.png',
    qr: '',
    catatan: 'Scan QR di bawah untuk membayar. Kirim bukti setelah pembayaran.',
  ),
];
