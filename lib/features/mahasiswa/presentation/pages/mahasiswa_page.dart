import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run/core/widgets/common_widgets.dart';
import 'package:run/features/mahasiswa/data/models/mahasiswa_model.dart';
import 'package:run/features/mahasiswa/presentation/providers/mahasiswa_provider.dart';

class MahasiswaPage extends ConsumerWidget {
  const MahasiswaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mahasiswaState = ref.watch(mahasiswaNotifierProvider);
    final savedMahasiswa = ref.watch(savedMahasiswaProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Mahasiswa'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(mahasiswaNotifierProvider),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section: Data Tersimpan
          _SavedMahasiswaSection(savedUsers: savedMahasiswa, ref: ref),

          // Section Title
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              'Daftar Mahasiswa',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),

          // Summary bar
          mahasiswaState.maybeWhen(
            data: (list) => Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.08),
              ),
              child: Text(
                'Total: ${list.length} mahasiswa',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            orElse: () => const SizedBox.shrink(),
          ),

          // List
          Expanded(
            child: mahasiswaState.when(
              loading: () => const LoadingWidget(),
              error: (error, stack) => CustomErrorWidget(
                message: 'Gagal memuat data: ${error.toString()}',
                onRetry: () =>
                    ref.read(mahasiswaNotifierProvider.notifier).refresh(),
              ),
              data: (mahasiswaList) => _MahasiswaListWithSave(
                mahasiswaList: mahasiswaList,
                onRefresh: () => ref.invalidate(mahasiswaNotifierProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ——— Widget: Section data tersimpan ——————————————————————
class _SavedMahasiswaSection extends StatelessWidget {
  final AsyncValue<List<Map<String, String>>> savedUsers;
  final WidgetRef ref;

  const _SavedMahasiswaSection(
      {required this.savedUsers, required this.ref});

  String _formatDate(String isoString) {
    if (isoString.isEmpty) return '-';
    try {
      final date = DateTime.parse(isoString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return isoString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.storage_rounded, size: 16),
              const SizedBox(width: 6),
              const Text(
                'Data Tersimpan di Local Storage',
                style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              savedUsers.maybeWhen(
                data: (users) => users.isNotEmpty
                    ? TextButton.icon(
                        onPressed: () async {
                          await ref
                              .read(mahasiswaNotifierProvider.notifier)
                              .clearSavedMahasiswa();
                          ref.invalidate(savedMahasiswaProvider);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Semua data tersimpan dihapus')),
                            );
                          }
                        },
                        icon: const Icon(Icons.delete_sweep_outlined,
                            size: 14, color: Colors.red),
                        label: const Text('Hapus Semua',
                            style: TextStyle(
                                fontSize: 12, color: Colors.red)),
                      )
                    : const SizedBox.shrink(),
                orElse: () => const SizedBox.shrink(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          savedUsers.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const Text('Gagal membaca data tersimpan',
                style: TextStyle(color: Colors.red, fontSize: 12)),
            data: (users) {
              if (users.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          size: 16, color: Colors.grey.shade400),
                      const SizedBox(width: 8),
                      Text(
                        'Belum ada data. Tap ikon 💾 untuk menyimpan.',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                );
              }

              return Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: users.length,
                  separatorBuilder: (_, __) => Divider(
                      height: 1, color: Colors.blue.shade100),
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.blue.shade100,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(user['username'] ?? '-'),
                      subtitle: Text(
                        'ID: ${user['user_id']} • ${_formatDate(user['saved_at'] ?? '')}',
                        style: const TextStyle(fontSize: 11),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.close,
                            size: 16, color: Colors.red),
                        onPressed: () async {
                          await ref
                              .read(mahasiswaNotifierProvider.notifier)
                              .removeSavedMahasiswa(
                                  user['user_id'] ?? '');
                          ref.invalidate(savedMahasiswaProvider);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      '${user['username']} dihapus')),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ——— Widget: List mahasiswa dengan tombol save ————————————
class _MahasiswaListWithSave extends StatelessWidget {
  final List<MahasiswaModel> mahasiswaList;
  final VoidCallback onRefresh;

  const _MahasiswaListWithSave(
      {required this.mahasiswaList, required this.onRefresh});

  static const List<List<Color>> _gradients = [
    [Color(0xFF667eea), Color(0xFF764ba2)],
    [Color(0xFF4facfe), Color(0xFF00f2fe)],
    [Color(0xFF43e97b), Color(0xFF38f9d7)],
    [Color(0xFFfa709a), Color(0xFFfee140)],
  ];

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        itemCount: mahasiswaList.length,
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        itemBuilder: (context, index) {
          final mahasiswa = mahasiswaList[index];
          final gradientColors = _gradients[index % _gradients.length];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: gradientColors[0],
                child: Text(
                  '${mahasiswa.id}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              ),
              title: Text(mahasiswa.name,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                mahasiswa.email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Consumer(
                builder: (context, ref, _) => IconButton(
                  icon: Icon(Icons.save,
                      size: 20, color: gradientColors[0]),
                  tooltip: 'Simpan mahasiswa ini',
                  onPressed: () async {
                    await ref
                        .read(mahasiswaNotifierProvider.notifier)
                        .saveSelectedMahasiswa(mahasiswa);
                    ref.invalidate(savedMahasiswaProvider);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              '${mahasiswa.name} berhasil disimpan'),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}