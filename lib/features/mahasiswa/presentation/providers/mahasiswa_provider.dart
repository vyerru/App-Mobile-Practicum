import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run/core/services/local_storage_service.dart';
import 'package:run/features/mahasiswa/data/models/mahasiswa_model.dart';
import 'package:run/features/mahasiswa/data/repositories/mahasiswa_repository.dart';

// Repository Provider
final mahasiswaRepositoryProvider = Provider<MahasiswaRepository>((ref) {
  return MahasiswaRepository();
});

// LocalStorage Provider
final mahasiswaLocalStorageProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

// Provider list mahasiswa yang tersimpan
final savedMahasiswaProvider =
    FutureProvider<List<Map<String, String>>>((ref) async {
  final storage = ref.watch(mahasiswaLocalStorageProvider);
  return storage.getSavedMahasiswa();
});

// StateNotifier
class MahasiswaNotifier
    extends StateNotifier<AsyncValue<List<MahasiswaModel>>> {
  final MahasiswaRepository _repository;
  final LocalStorageService _storage;

  MahasiswaNotifier(this._repository, this._storage)
      : super(const AsyncValue.loading()) {
    loadMahasiswaList();
  }

  Future<void> loadMahasiswaList() async {
    state = const AsyncValue.loading();
    try {
      final data = await _repository.getMahasiswaList();
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    await loadMahasiswaList();
  }

  Future<void> saveSelectedMahasiswa(MahasiswaModel mahasiswa) async {
    await _storage.addMahasiswaToSavedList(
      userId: mahasiswa.id.toString(),
      username: mahasiswa.name,
    );
  }

  Future<void> removeSavedMahasiswa(String userId) async {
    await _storage.removeSavedMahasiswa(userId);
  }

  Future<void> clearSavedMahasiswa() async {
    await _storage.clearSavedMahasiswa();
  }
}

// Provider
final mahasiswaNotifierProvider = StateNotifierProvider.autoDispose<
    MahasiswaNotifier, AsyncValue<List<MahasiswaModel>>>((ref) {
  final repository = ref.watch(mahasiswaRepositoryProvider);
  final storage = ref.watch(mahasiswaLocalStorageProvider);
  return MahasiswaNotifier(repository, storage);
});