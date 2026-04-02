import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run/features/mahasiswa_aktif/presentation/providers/mahasiswa_aktif_provider.dart';
import 'package:run/features/mahasiswa_aktif/presentation/widgets/mahasiswa_aktif_widget.dart';

class MahasiswaAktifPage extends ConsumerWidget {
  const MahasiswaAktifPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Membaca state dari provider mahasiswa aktif
    final mahasiswaAktifState = ref.watch(mahasiswaAktifNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Mahasiswa Aktif'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              // Me-refresh data dengan memanggil ulang provider
              ref.invalidate(mahasiswaAktifNotifierProvider);
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: mahasiswaAktifState.when(
        // State: Loading
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        // State: Error
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, size: 48, color: Colors.redAccent),
              const SizedBox(height: 16),
              Text(
                'Gagal memuat data:\n${error.toString()}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.redAccent),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  ref.invalidate(mahasiswaAktifNotifierProvider);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),

        // State: Berhasil mendapatkan Data
        data: (mahasiswaAktifList) {
          return Column(
            children: [
              // Summary Bar (Menampilkan total data posts)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.08),
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                    ),
                  ),
                ),
                child: Text(
                  'Total: ${mahasiswaAktifList.length} aktivitas',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              
              // Menampilkan List View dari widget mahasiswa_aktif_widget.dart
              Expanded(
                child: MahasiswaAktifListView(
                  mahasiswaAktifList: mahasiswaAktifList,
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
}