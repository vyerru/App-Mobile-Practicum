import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run/core/services/local_storage_service.dart';
import 'package:run/features/dosen/data/models/dosen_model.dart';
import 'package:run/features/dosen/data/repositories/dosen_repository.dart';

// Repository Provider
final dosenRepositoryProvider = Provider<DosenRepository>((ref) {
  return DosenRepository();
});

// LocalStorageService Provider
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

// Provider semua data user yang disimpan — FutureProvider agar bisa async
final savedUsersProvider =
    FutureProvider<List<Map<String, String>>>((ref) async {
  final storage = ref.watch(localStorageServiceProvider);
  return storage.getSavedUsers();
});

// StateNotifier untuk mengelola state dosen
class DosenNotifier extends StateNotifier<AsyncValue<List<DosenModel>>> {
  final DosenRepository _repository;
  final LocalStorageService _storage;

  DosenNotifier(this._repository, this._storage)
      : super(const AsyncValue.loading()) {
    loadDosenList();
  }

  Future<void> loadDosenList() async {
    state = const AsyncValue.loading();
    try {
      final data = await _repository.getDosenList();
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    await loadDosenList();
  }

  /// Simpan dosen yang dipilih ke local storage
  Future<void> saveSelectedDosen(DosenModel dosen) async {
    await _storage.addUserToSavedList(
      userId: dosen.id.toString(),
      username: dosen.username,
    );
  }

  /// Hapus user tertentu dari list
  Future<void> removeSavedUser(String userId) async {
    await _storage.removeSavedUser(userId);
  }

  /// Hapus semua user dari list
  Future<void> clearSavedUsers() async {
    await _storage.clearSavedUsers();
  }
}

// Dosen Notifier Provider
final dosenNotifierProvider = StateNotifierProvider.autoDispose<DosenNotifier,
    AsyncValue<List<DosenModel>>>((ref) {
  final repository = ref.watch(dosenRepositoryProvider);
  final storage = ref.watch(localStorageServiceProvider);
  return DosenNotifier(repository, storage);
});