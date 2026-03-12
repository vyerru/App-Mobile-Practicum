import 'package:run/features/profile/data/models/profile_model.dart';

class ProfileRepository {
  /// Mendapatkan data profil admin
  Future<ProfileModel> getProfile() async {
    // Simulasi network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Data dummy profil
    return ProfileModel(
      nama: 'Admin D4TI',
      nip: '198501012010011001',
      email: 'admin.d4ti@example.ac.id',
      jabatan: 'Kepala Program Studi',
      unitKerja: 'D4 Teknik Informatika Vokasi',
      noTelp: '+62 812 3456 7890',
      alamat: 'Jl. Raya Kampus No. 1, Kota Universitas',
    );
  }
}