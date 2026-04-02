import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run/core/widgets/common_widgets.dart';
import 'package:run/features/dosen/data/models/dosen_model.dart';
import 'package:run/features/dosen/presentation/providers/dosen_provider.dart';
import 'package:run/features/dosen/presentation/widgets/dosen_widget.dart';

class DosenPage extends ConsumerWidget {
  const DosenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dosenState = ref.watch(dosenNotifierProvider);
    final savedUsers = ref.watch(savedUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Dosen'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.invalidate(dosenNotifierProvider),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section: Data Tersimpan di SharedPreferences
          _SavedUserSection(savedUsers: savedUsers, ref: ref),

          // Section Title: Daftar Dosen
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Text(
              'Daftar Dosen',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),

          // Dosen List
          Expanded(
            child: dosenState.when(
              loading: () => const LoadingWidget(),
              error: (error, stack) => CustomErrorWidget(
                message: 'Gagal memuat data dosen: ${error.toString()}',
                onRetry: () {
                  ref.read(dosenNotifierProvider.notifier).refresh();
                },
              ),
              data: (dosenList) => _DosenListWithSave(
                dosenList: dosenList,
                onRefresh: () => ref.invalidate(dosenNotifierProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ——— Widget: Section data tersimpan ———————————————————————
class _SavedUserSection extends StatelessWidget {
  final AsyncValue<List<Map<String, String>>> savedUsers;
  final WidgetRef ref;

  const _SavedUserSection({required this.savedUsers, required this.ref});

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
          // Header dengan tombol hapus semua
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
                              .read(dosenNotifierProvider.notifier)
                              .clearSavedUsers();
                          ref.invalidate(savedUsersProvider);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Semua data tersimpan dihapus'),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.delete_sweep_outlined,
                            size: 14, color: Colors.red),
                        label: const Text(
                          'Hapus Semua',
                          style:
                              TextStyle(fontSize: 12, color: Colors.red),
                        ),
                      )
                    : const SizedBox.shrink(),
                orElse: () => const SizedBox.shrink(),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Content
          savedUsers.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const Text(
              'Gagal membaca data tersimpan',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
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
                            fontSize: 12,
                            color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                );
              }

              return Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: users.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: Colors.green.shade100,
                    indent: 12,
                    endIndent: 12,
                  ),
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.green.shade100,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                          ),
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
                              .read(dosenNotifierProvider.notifier)
                              .removeSavedUser(user['user_id'] ?? '');
                          ref.invalidate(savedUsersProvider);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    '${user['username']} dihapus'),
                              ),
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

// ——— Widget: List dosen dengan tombol save ————————————————
class _DosenListWithSave extends StatelessWidget {
  final List<DosenModel> dosenList;
  final VoidCallback onRefresh;

  const _DosenListWithSave(
      {required this.dosenList, required this.onRefresh});

  static const List<List<Color>> _gradients = [
    [Color(0xFF667eea), Color(0xFF764ba2)],
    [Color(0xFFf093fb), Color(0xFFf5576c)],
    [Color(0xFF4facfe), Color(0xFF00f2fe)],
    [Color(0xFF43e97b), Color(0xFF38f9d7)],
  ];

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        itemCount: dosenList.length,
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        itemBuilder: (context, index) {
          final dosen = dosenList[index];
          final gradientColors = _gradients[index % _gradients.length];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: gradientColors[0],
                child: Text(
                  '${dosen.id}',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(dosen.name,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                '${dosen.username} · ${dosen.email}\n${dosen.address.city}',
              ),
              isThreeLine: true,
              trailing: Consumer(
                builder: (context, ref, _) => IconButton(
                  icon: Icon(Icons.save, size: 20, color: gradientColors[0]),
                  tooltip: 'Simpan user ini',
                  onPressed: () async {
                    await ref
                        .read(dosenNotifierProvider.notifier)
                        .saveSelectedDosen(dosen);
                    ref.invalidate(savedUsersProvider);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              '${dosen.username} berhasil disimpan ke local storage'),
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