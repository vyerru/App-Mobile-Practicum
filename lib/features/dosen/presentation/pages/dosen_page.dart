import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run/features/dosen/presentation/providers/dosen_provider.dart'; // Sesuaikan
import 'package:run/features/dosen/presentation/widgets/dosen_widget.dart'; // Sesuaikan

class DosenPage extends ConsumerWidget {
  const DosenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dosenState = ref.watch(dosenNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Dosen'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              ref.invalidate(dosenNotifierProvider);
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: dosenState.when(
        loading: () => const Center(child: CircularProgressIndicator()), 
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Gagal memuat data: ${error.toString()}'),
              ElevatedButton(
                onPressed: () => ref.read(dosenNotifierProvider.notifier).refresh(),
                child: const Text('Coba Lagi'),
              )
            ],
          ),
        ),
        data: (dosenList) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(dosenNotifierProvider);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: dosenList.length,
              itemBuilder: (context, index) {
                return ModernDosenCard(dosen: dosenList[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
