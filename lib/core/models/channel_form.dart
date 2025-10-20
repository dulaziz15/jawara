class ChannelForm {
  String nama = '';
  String tipe = '';
  String nomorRekening = '';
  String an = '';
  String qr = '';
  String thumbnail = '';
  String catatan = '';

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'tipe': tipe,
      'nomorRekening': nomorRekening,
      'an': an,
      'qr': qr,
      'thumbnail': thumbnail,
      'catatan': catatan,
    };
  }

  void reset() {
    nama = '';
    tipe = '';
    nomorRekening = '';
    an = '';
    qr = '';
    thumbnail = '';
    catatan = '';
  }
}
