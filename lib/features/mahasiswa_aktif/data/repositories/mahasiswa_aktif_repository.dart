import 'package:run/features/mahasiswa_aktif/data/models/mahasiswa_aktif_model.dart';

class MahasiswaAktifRepository {
  /// Mendapatkan daftar mahasiswa aktif
  Future<List<MahasiswaAktifModel>> getMahasiswaAktifList() async {
    // Simulasi network delay
    await Future.delayed(const Duration(seconds: 1));

    // Data dummy mahasiswa aktif
    return [
      MahasiswaAktifModel(
        nama: 'Budi Santoso',
        nim: '2021010001',
        jurusan: 'Teknik Informatika',
        semester: '6',
        ipk: '3.75',
        angkatan: '2021',
        kelas: 'D4TI-A',
      ),
      MahasiswaAktifModel(
        nama: 'Siti Rahayu',
        nim: '2021010002',
        jurusan: 'Teknik Informatika',
        semester: '6',
        ipk: '3.90',
        angkatan: '2021',
        kelas: 'D4TI-A',
      ),
      MahasiswaAktifModel(
        nama: 'Ahmad Fauzi',
        nim: '2021010003',
        jurusan: 'Teknik Informatika',
        semester: '4',
        ipk: '3.50',
        angkatan: '2022',
        kelas: 'D4TI-B',
      ),
      MahasiswaAktifModel(
        nama: 'Eko Prasetyo',
        nim: '2022010005',
        jurusan: 'Teknik Informatika',
        semester: '2',
        ipk: '3.20',
        angkatan: '2023',
        kelas: 'D4TI-A',
      ),
      MahasiswaAktifModel(
        nama: 'Fitria Ningsih',
        nim: '2021010006',
        jurusan: 'Teknik Informatika',
        semester: '6',
        ipk: '3.85',
        angkatan: '2021',
        kelas: 'D4TI-B',
      ),
    ];
  }
}