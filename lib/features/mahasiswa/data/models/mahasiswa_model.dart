class MahasiswaModel {
  final String nama;
  final String nim;
  final String email;
  final String jurusan;
  final String semester;
  final String status;

  MahasiswaModel({
    required this.nama,
    required this.nim,
    required this.email,
    required this.jurusan,
    required this.semester,
    required this.status,
  });

  factory MahasiswaModel.fromJson(Map<String, dynamic> json) {
    return MahasiswaModel(
      nama: json['nama'] ?? '',
      nim: json['nim'] ?? '',
      email: json['email'] ?? '',
      jurusan: json['jurusan'] ?? '',
      semester: json['semester'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'nim': nim,
      'email': email,
      'jurusan': jurusan,
      'semester': semester,
      'status': status,
    };
  }
}