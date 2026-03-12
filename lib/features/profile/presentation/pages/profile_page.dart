import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run/core/widgets/common_widgets.dart';
import 'package:run/features/profile/presentation/providers/profile_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileNotifierProvider);

    return Scaffold(
      body: profileState.when(
        loading: () => const LoadingWidget(),
        error: (error, stack) => CustomErrorWidget(
          message: 'Gagal memuat profil: ${error.toString()}',
          onRetry: () {
            ref.read(profileNotifierProvider.notifier).refresh();
          },
        ),
        data: (profile) {
          return CustomScrollView(
            slivers: [
              // App Bar with gradient
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          // Avatar
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.25),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.6),
                                width: 3,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                profile.nama.substring(0, 1).toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            profile.nama,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.3)),
                            ),
                            child: Text(
                              profile.jabatan,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.95),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded,
                        color: Colors.white),
                    onPressed: () =>
                        ref.read(profileNotifierProvider.notifier).refresh(),
                    tooltip: 'Refresh',
                  ),
                ],
              ),

              // Profile Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // Info Section
                      _buildSectionTitle('Informasi Akun'),
                      const SizedBox(height: 12),
                      _buildInfoCard(context, [
                        _InfoItem(
                          icon: Icons.badge_outlined,
                          label: 'NIP',
                          value: profile.nip,
                          color: const Color(0xFF667eea),
                        ),
                        _InfoItem(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: profile.email,
                          color: const Color(0xFF4facfe),
                        ),
                      ]),

                      const SizedBox(height: 20),
                      _buildSectionTitle('Informasi Pekerjaan'),
                      const SizedBox(height: 12),
                      _buildInfoCard(context, [
                        _InfoItem(
                          icon: Icons.work_outline_rounded,
                          label: 'Jabatan',
                          value: profile.jabatan,
                          color: const Color(0xFF43e97b),
                        ),
                        _InfoItem(
                          icon: Icons.account_balance_outlined,
                          label: 'Unit Kerja',
                          value: profile.unitKerja,
                          color: const Color(0xFF43e97b),
                        ),
                      ]),

                      const SizedBox(height: 20),
                      _buildSectionTitle('Kontak'),
                      const SizedBox(height: 12),
                      _buildInfoCard(context, [
                        _InfoItem(
                          icon: Icons.phone_outlined,
                          label: 'No. Telepon',
                          value: profile.noTelp,
                          color: const Color(0xFFf093fb),
                        ),
                        _InfoItem(
                          icon: Icons.location_on_outlined,
                          label: 'Alamat',
                          value: profile.alamat,
                          color: const Color(0xFFf093fb),
                        ),
                      ]),

                      const SizedBox(height: 24),

                      // Action Buttons
                      _buildActionButton(
                        context,
                        icon: Icons.edit_outlined,
                        label: 'Edit Profil',
                        color: const Color(0xFF667eea),
                        onTap: () {},
                      ),
                      const SizedBox(height: 10),
                      _buildActionButton(
                        context,
                        icon: Icons.lock_outline_rounded,
                        label: 'Ubah Password',
                        color: const Color(0xFF4facfe),
                        onTap: () {},
                      ),
                      const SizedBox(height: 10),
                      _buildActionButton(
                        context,
                        icon: Icons.logout_rounded,
                        label: 'Keluar',
                        color: const Color(0xFFf5576c),
                        onTap: () {},
                      ),

                      const SizedBox(height: 32),

                      // App version
                      Center(
                        child: Text(
                          'Dashboard Mahasiswa D4TI v1.0.0',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, List<_InfoItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: item.color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(item.icon, size: 18, color: item.color),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.value,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (i < items.length - 1)
                Divider(
                  height: 1,
                  indent: 54,
                  color: Colors.grey.withOpacity(0.15),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: color),
          ],
        ),
      ),
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}