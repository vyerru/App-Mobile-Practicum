import 'package:run/features/mahasiswa/data/models/mahasiswa_model.dart';

class MahasiswaRepository {
  /// Mendapatkan daftar mahasiswa
  Future<List<MahasiswaModel>> getMahasiswaList() async {
    // Simulasi network delay
    await Future.delayed(const Duration(seconds: 1));

    // Data dummy mahasiswa
    return [
      MahasiswaModel(
        nama: 'Budi Santoso',
        nim: '2021010001',
        email: 'budi.santoso@student.example.com',
        jurusan: 'Teknik Informatika',
        semester: '6',
        status: 'Aktif',
      ),
      MahasiswaModel(
        nama: 'Siti Rahayu',
        nim: '2021010002',
        email: 'siti.rahayu@student.example.com',
        jurusan: 'Teknik Informatika',
        semester: '6',
        status: 'Aktif',
      ),
      MahasiswaModel(
        nama: 'Ahmad Fauzi',
        nim: '2021010003',
        email: 'ahmad.fauzi@student.example.com',
        jurusan: 'Teknik Informatika',
        semester: '4',
        status: 'Aktif',
      ),
      MahasiswaModel(
        nama: 'Dewi Lestari',
        nim: '2020010004',
        email: 'dewi.lestari@student.example.com',
        jurusan: 'Teknik Informatika',
        semester: '8',
        status: 'Lulus',
      ),
      MahasiswaModel(
        nama: 'Eko Prasetyo',
        nim: '2022010005',
        email: 'eko.prasetyo@student.example.com',
        jurusan: 'Teknik Informatika',
        semester: '2',
        status: 'Aktif',
      ),
      MahasiswaModel(
        nama: 'Fitria Ningsih',
        nim: '2021010006',
        email: 'fitria.ningsih@student.example.com',
        jurusan: 'Teknik Informatika',
        semester: '6',
        status: 'Aktif',
      ),
    ];
  }
}