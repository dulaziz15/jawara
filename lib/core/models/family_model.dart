class Family {
  final String nik;
  final String name;

  Family({
    required this.nik,
    required this.name,
  });

  @override
  String toString() {
    return 'Family{nik: $nik, name: $name}';
  }
}