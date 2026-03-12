import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:run/features/dashboard/presentation/providers/dashboard_provider.dart'; // Sesuaikan
import 'package:run/features/dashboard/presentation/widgets/dashboard_widget.dart'; // Sesuaikan
import 'package:run/features/dosen/presentation/pages/dosen_page.dart';
import 'package:run/features/mahasiswa/presentation/pages/mahasiswa_page.dart';
import 'package:run/features/mahasiswa_aktif/presentation/pages/mahasiswa_aktif_page.dart';
import 'package:run/features/profile/presentation/pages/profile_page.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  IconData _getIconForStat(String title) {
    switch (title) {
      case 'Total Mahasiswa': return Icons.school_rounded;
      case 'Mahasiswa Aktif': return Icons.person_outline_rounded;
      case 'Mahasiswa Lulus': return Icons.workspace_premium_rounded;
      case 'Dosen': return Icons.people_outline_rounded;
      default: return Icons.analytics_outlined;
    }
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${date.day} ${months[date.month - 1]} ${date.year}, ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardNotifierProvider);
    final selectedIndex = ref.watch(selectedStatIndexProvider);

    // Default Gradients jika AppConstants tidak ada
    final List<List<Color>> dashboardGradients = [
      [const Color(0xFF667eea), const Color(0xFF764ba2)],
      [const Color(0xFFf093fb), const Color(0xFFf5576c)],
      [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
      [const Color(0xFF43e97b), const Color(0xFF38f9d7)],
    ];

    return Scaffold(
      body: dashboardState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Gagal memuat data: ${error.toString()}'),
              ElevatedButton(
                onPressed: () => ref.read(dashboardNotifierProvider.notifier).refresh(),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
        data: (dashboardData) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(dashboardNotifierProvider);
            },
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.blue, Colors.blue.shade800],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Selamat Datang!',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        dashboardData.userName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.notifications_outlined),
                                  color: Colors.white,
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today_rounded, color: Colors.white.withOpacity(0.9), size: 18),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Update: ${_formatDate(dashboardData.lastUpdate)}',
                                    style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Statistik',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            TextButton.icon(
                              onPressed: () => ref.invalidate(dashboardNotifierProvider),
                              icon: const Icon(Icons.refresh_rounded, size: 18),
                              label: const Text('Refresh'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.1,
                          ),
                          itemCount: dashboardData.stats.length,
                          itemBuilder: (context, index) {
                            final stat = dashboardData.stats[index];
                            return ModernStatCard(
                              stats: stat,
                              icon: _getIconForStat(stat.title),
                              gradientColors: dashboardGradients[index % dashboardGradients.length],
                              isSelected: selectedIndex == index,
                              onTap: () {
                                ref.read(selectedStatIndexProvider.notifier).state = index;
                                Widget? targetPage;
                                switch (stat.title) {
                                  case 'Dosen':
                                    targetPage = const DosenPage();
                                    break;
                                  case 'Total Mahasiswa':
                                    targetPage = const MahasiswaPage();
                                    break;
                                  case 'Mahasiswa Aktif':
                                    targetPage = const MahasiswaAktifPage();
                                    break;
                                  case 'Profile':
                                    targetPage = const ProfilePage();
                                    break;
                                }
                                if (targetPage != null) {
                                  Navigator.push(context, _createRoute(targetPage));
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
