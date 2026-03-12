import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:run/features/mahasiswa/data/models/mahasiswa_model.dart';
import 'package:run/features/mahasiswa/data/repositories/mahasiswa_repository.dart';

final mahasiswaRepositoryProvider = Provider<MahasiswaRepository>((ref) {
  return MahasiswaRepository();
});

class MahasiswaNotifier extends StateNotifier<AsyncValue<List<MahasiswaModel>>> {
  final MahasiswaRepository _repository;

  MahasiswaNotifier(this._repository) : super(const AsyncValue.loading()) {
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
}

final mahasiswaNotifierProvider =
    StateNotifierProvider.autoDispose<MahasiswaNotifier, AsyncValue<List<MahasiswaModel>>>((ref) {
  final repository = ref.watch(mahasiswaRepositoryProvider);
  return MahasiswaNotifier(repository);
});
