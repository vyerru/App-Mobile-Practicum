import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:run/features/profile/data/models/profile_model.dart';
import 'package:run/features/profile/data/repositories/profile_repository.dart';

// Repository Provider
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository();
}); // Provider

// StateNotifier untuk mengelola state profil
class ProfileNotifier extends StateNotifier<AsyncValue<ProfileModel>> {
  final ProfileRepository _repository;

  ProfileNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadProfile();
  }

  /// Load data profil
  Future<void> loadProfile() async {
    state = const AsyncValue.loading();
    try {
      final data = await _repository.getProfile();
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Refresh data profil
  Future<void> refresh() async {
    await loadProfile();
  }
}

// Profile Notifier Provider
final profileNotifierProvider =
    StateNotifierProvider.autoDispose<ProfileNotifier, AsyncValue<ProfileModel>>(
  (ref) {
    final repository = ref.watch(profileRepositoryProvider);
    return ProfileNotifier(repository);
  },
);