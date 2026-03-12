import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run/core/widgets/common_widgets.dart';
import 'package:run/features/mahasiswa/presentation/providers/mahasiswa_provider.dart';
import 'package:run/features/mahasiswa/presentation/widgets/mahasiswa_widget.dart';

class MahasiswaPage extends ConsumerWidget {
  const MahasiswaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mahasiswaState = ref.watch(mahasiswaNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Mahasiswa'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              ref.invalidate(mahasiswaNotifierProvider);
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: mahasiswaState.when(
        // State: Loading
        loading: () => const LoadingWidget(),

        // State: Error
        error: (error, stack) => CustomErrorWidget(
          message: 'Gagal memuat data mahasiswa: ${error.toString()}',
          onRetry: () {
            ref.read(mahasiswaNotifierProvider.notifier).refresh();
          },
        ),

        // State: Data
        data: (mahasiswaList) {
          return Column(
            children: [
              // Summary bar
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.08),
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                    ),
                  ),
                ),
                child: Text(
                  'Total: ${mahasiswaList.length} mahasiswa',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Expanded(
                child: MahasiswaListView(
                  mahasiswaList: mahasiswaList,
                  onRefresh: () {
                    ref.invalidate(mahasiswaNotifierProvider);
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