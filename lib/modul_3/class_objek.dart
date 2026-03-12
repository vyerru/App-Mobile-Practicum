import 'dart:io';

// class 
// class Mahasiswa {
//   String nama = 'Javier';

//   void tampilkanData() {
//     print(nama);
//   }
// }

// void main() {
//   var mahasiswa1 = Mahasiswa();
//   mahasiswa1.tampilkanData();

//   stdout.writeln('Masukkan nama baru:');
//   String? namaBaru = stdin.readLineSync();
//   if (namaBaru != null && namaBaru.isNotEmpty) {
//     mahasiswa1.nama = namaBaru;
//     print('Nama berhasil diubah!');
//     mahasiswa1.tampilkanData();
//   } else {
//     print('Nama tidak boleh kosong.');
//   }
// }

// Object
// class Mahasiswa {
//   String? nama;
//   int? nim;
//   String? jurusan;

//   void tampilkanData() {
//     print('Nama: ${nama ?? "Belum diisi"}');
//     print('NIM: ${nim ?? "Belum diisi"}');
//     print('Jurusan: ${jurusan ?? "Belum diisi"}');
//   }
// }

// void main() {
//   Mahasiswa mahasiswa = Mahasiswa();
//   print("Masukkan Nama Mahasiswa:");
//   mahasiswa.nama = stdin.readLineSync() ?? '';
//   print("Masukkan NIM Mahasiswa:");
//   mahasiswa.nim = int.tryParse(stdin.readLineSync() ?? '');
//   print("Masukkan Jurusan Mahasiswa:");
//   mahasiswa.jurusan = stdin.readLineSync() ?? '';
//   mahasiswa.tampilkanData();
// }

// Mixin
mixin Penelitian {
  void ikutPenelitian() => print("Sedang melakukan penelitian AI.");
}

mixin Kepanitiaan {
  void ikutKepanitiaan() => print("Menjadi panitia acara BEM.");
}

mixin Pengajaran {
  void mengajarKelas() => print("Sedang mengajar di kelas.");
}

// Class Dasar
class SivitasAkademika {
  String? nama;
  String? id;
  
  SivitasAkademika(this.nama, this.id);
  
  void tampilkanInfoDasar() {
    print("Nama: $nama, ID: $id");
  }
}

// 3. Extends dan Implementasi Mixin
class Mahasiswa extends SivitasAkademika {
  String? jurusan;
  Mahasiswa(String nama, String id, this.jurusan) : super(nama, id);
}

// // Extends MahasiswaAktif & MahasiswaAlumni
class MahasiswaAktif extends Mahasiswa with Kepanitiaan, Penelitian {
  int semester;
  MahasiswaAktif(String nama, String id, String jurusan, this.semester) : super(nama, id, jurusan);
  
  void status() => print("Status: Mahasiswa Aktif Semester $semester");
}

class MahasiswaAlumni extends Mahasiswa {
  int tahunLulus;
  MahasiswaAlumni(String nama, String id, String jurusan, this.tahunLulus) : super(nama, id, jurusan);
  
  void status() => print("Status: Alumni Lulusan $tahunLulus");
}

// Implementasi Dosen dan Fakultas
class Dosen extends SivitasAkademika with Pengajaran, Penelitian {
  String fakultas;
  Dosen(String nama, String id, this.fakultas) : super(nama, id);
}
