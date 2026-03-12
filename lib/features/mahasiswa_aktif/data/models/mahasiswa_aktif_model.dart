class MahasiswaAktifModel {
  final String nama;
  final String nim;
  final String jurusan;
  final String semester;
  final String ipk;
  final String angkatan;
  final String kelas;

  MahasiswaAktifModel({
    required this.nama,
    required this.nim,
    required this.jurusan,
    required this.semester,
    required this.ipk,
    required this.angkatan,
    required this.kelas,
  });

  factory MahasiswaAktifModel.fromJson(Map<String, dynamic> json) {
    return MahasiswaAktifModel(
      nama: json['nama'] ?? '',
      nim: json['nim'] ?? '',
      jurusan: json['jurusan'] ?? '',
      semester: json['semester'] ?? '',
      ipk: json['ipk'] ?? '0.00',
      angkatan: json['angkatan'] ?? '',
      kelas: json['kelas'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'nim': nim,
      'jurusan': jurusan,
      'semester': semester,
      'ipk': ipk,
      'angkatan': angkatan,
      'kelas': kelas,
    };
  }
}