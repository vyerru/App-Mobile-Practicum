import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:run/features/mahasiswa_aktif/data/models/mahasiswa_aktif_model.dart';
import 'package:run/features/mahasiswa_aktif/data/repositories/mahasiswa_aktif_repository.dart';

// Repository Provider
final mahasiswaAktifRepositoryProvider =
    Provider<MahasiswaAktifRepository>((ref) {
  return MahasiswaAktifRepository();
}); // Provider

// StateNotifier untuk mengelola state mahasiswa aktif
class MahasiswaAktifNotifier
    extends StateNotifier<AsyncValue<List<MahasiswaAktifModel>>> {
  final MahasiswaAktifRepository _repository;

  MahasiswaAktifNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadMahasiswaAktifList();
  }

  /// Load data mahasiswa aktif
  Future<void> loadMahasiswaAktifList() async {
    state = const AsyncValue.loading();
    try {
      final data = await _repository.getMahasiswaAktifList();
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Refresh data mahasiswa aktif
  Future<void> refresh() async {
    await loadMahasiswaAktifList();
  }
}

// Mahasiswa Aktif Notifier Provider
final mahasiswaAktifNotifierProvider = StateNotifierProvider.autoDispose<
    MahasiswaAktifNotifier, AsyncValue<List<MahasiswaAktifModel>>>(
  (ref) {
    final repository = ref.watch(mahasiswaAktifRepositoryProvider);
    return MahasiswaAktifNotifier(repository);
  },
);