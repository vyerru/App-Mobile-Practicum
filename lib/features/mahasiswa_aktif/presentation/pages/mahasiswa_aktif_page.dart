import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run/core/widgets/common_widgets.dart';
import 'package:run/features/mahasiswa_aktif/presentation/providers/mahasiswa_aktif_provider.dart';
import 'package:run/features/mahasiswa_aktif/presentation/widgets/mahasiswa_aktif_widget.dart';

class MahasiswaAktifPage extends ConsumerWidget {
  const MahasiswaAktifPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mahasiswaAktifState = ref.watch(mahasiswaAktifNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mahasiswa Aktif'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              ref.invalidate(mahasiswaAktifNotifierProvider);
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: mahasiswaAktifState.when(
        // State: Loading
        loading: () => const LoadingWidget(),

        // State: Error
        error: (error, stack) => CustomErrorWidget(
          message: 'Gagal memuat data: ${error.toString()}',
          onRetry: () {
            ref.read(mahasiswaAktifNotifierProvider.notifier).refresh();
          },
        ),

        // State: Data
        data: (mahasiswaList) {
          // Stats summary
          final totalAktif = mahasiswaList.length;
          final avgIpk = mahasiswaList.isEmpty
              ? 0.0
              : mahasiswaList
                      .map((m) => double.tryParse(m.ipk) ?? 0)
                      .reduce((a, b) => a + b) /
                  mahasiswaList.length;

          return Column(
            children: [
              // Stats header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF4facfe).withOpacity(0.15),
                      const Color(0xFF00f2fe).withOpacity(0.05),
                    ],
                  ),
                  border: Border(
                    bottom: BorderSide(
                        color: const Color(0xFF4facfe).withOpacity(0.15)),
                  ),
                ),
                child: Row(
                  children: [
                    _buildStatChip(
                      context,
                      Icons.person_outline_rounded,
                      '$totalAktif',
                      'Aktif',
                      const Color(0xFF4facfe),
                    ),
                    const SizedBox(width: 12),
                    _buildStatChip(
                      context,
                      Icons.star_outline_rounded,
                      avgIpk.toStringAsFixed(2),
                      'Rata IPK',
                      const Color(0xFF43e97b),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: MahasiswaAktifListView(
                  mahasiswaList: mahasiswaList,
                  onRefresh: () {
                    ref.invalidate(mahasiswaAktifNotifierProvider);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatChip(BuildContext context, IconData icon, String value,
      String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: color,
                ),
              ),
              Text(
                label,
                style: TextStyle(fontSize: 10, color: color.withOpacity(0.8)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}