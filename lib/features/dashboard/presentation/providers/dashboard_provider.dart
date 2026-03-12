import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/models/dashboard_model.dart'; 
import '../../data/repositories/dashboard_repository.dart'; 

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository();
});

class DashboardNotifier extends StateNotifier<AsyncValue<DashboardData>> {
  final DashboardRepository _repository;

  DashboardNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    state = const AsyncValue.loading();
    try {
      final data = await _repository.getDashboardData();
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final data = await _repository.refreshDashboard();
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void updateUserName(String newName) {
    state.whenData((data) {
      state = AsyncValue.data(data.copyWith(userName: newName));
    });
  }
}

final dashboardNotifierProvider =
    StateNotifierProvider.autoDispose<DashboardNotifier, AsyncValue<DashboardData>>((ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return DashboardNotifier(repository);
});

final selectedStatIndexProvider = StateProvider<int>((ref) => 0);
final themeModeProvider = StateProvider<bool>((ref) => false); 
