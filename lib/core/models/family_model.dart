class Family {
  final String nik; // Relasi ke UserModel.nik
  final String name;

  Family({
    required this.nik,
    required this.name,
  });

  // ===============================================
  // 📥 Konversi dari Map (Firestore/JSON) ke Object
  // ===============================================
  factory Family.fromMap(Map<String, dynamic> map) {
    return Family(
      nik: map['nik'] as String,
      name: map['name'] as String,
    );
  }

  // ===============================================
  // 📤 Konversi dari Object ke Map (Untuk Firestore Write)
  // ===============================================
  Map<String, dynamic> toMap() {
    // Hanya menyimpan field inti. 
    // Field 'nik' juga akan menjadi ID Dokumen di Firestore.
    return {
      'nik': nik,
      'name': name,
    };
  }

  // Contoh data dummy Family yang berelasi dengan UserModel
  static final List<Family> dummyFamilies = [
    Family(nik: '1111111111111111', name: 'Ahmad Surya'),
    Family(nik: '2222222222222222', name: 'Budi Santoso'),
    Family(nik: '3333333333333333', name: 'Citra Dewi'), 
    Family(nik: '4444444444444444', name: 'Dedi Rahman'), 
    Family(nik: '5555555555555555', name: 'Eka Putri'), 
    Family(nik: '1234567890123451', name: 'Admin Jawara'),
    Family(nik: '9000000000000001', name: 'Andi Wijaya'),
    Family(nik: '8000000000000001', name: 'John Doe'),
  ];

  @override
  String toString() {
    return 'Family{nik: $nik, name: $name}';
  }
}