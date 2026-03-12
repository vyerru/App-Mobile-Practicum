import 'package:flutter/material.dart';
import 'package:run/features/mahasiswa/data/models/mahasiswa_model.dart';

class MahasiswaCard extends StatefulWidget {
  final MahasiswaModel mahasiswa;
  final VoidCallback? onTap;
  final List<Color>? gradientColors;

  const MahasiswaCard({
    Key? key,
    required this.mahasiswa,
    this.onTap,
    this.gradientColors,
  }) : super(key: key);

  @override
  State<MahasiswaCard> createState() => _MahasiswaCardState();
}

class _MahasiswaCardState extends State<MahasiswaCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Aktif':
        return Colors.green;
      case 'Lulus':
        return Colors.blue;
      case 'Cuti':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = widget.gradientColors ??
        [
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor.withOpacity(0.7),
        ];

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: gradientColors[0].withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: gradientColors[0].withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Avatar with Gradient
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradientColors,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: gradientColors[0].withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      widget.mahasiswa.nama.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Mahasiswa Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.mahasiswa.nama,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color:
                                  _statusColor(widget.mahasiswa.status)
                                      .withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              widget.mahasiswa.status,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: _statusColor(widget.mahasiswa.status),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      _buildInfoRow(
                          Icons.badge_outlined, 'NIM: ${widget.mahasiswa.nim}'),
                      const SizedBox(height: 3),
                      _buildInfoRow(
                          Icons.email_outlined, widget.mahasiswa.email),
                      const SizedBox(height: 3),
                      _buildInfoRow(Icons.school_outlined,
                          '${widget.mahasiswa.jurusan} • Sem ${widget.mahasiswa.semester}'),
                    ],
                  ),
                ),
                // Arrow Icon
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: gradientColors[0].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: gradientColors[0],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 12, color: Colors.grey[600]),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// List view widget for mahasiswa
class MahasiswaListView extends StatelessWidget {
  final List<MahasiswaModel> mahasiswaList;
  final VoidCallback? onRefresh;

  const MahasiswaListView({
    Key? key,
    required this.mahasiswaList,
    this.onRefresh,
  }) : super(key: key);

  static const List<List<Color>> _gradients = [
    [Color(0xFF667eea), Color(0xFF764ba2)], // Purple
    [Color(0xFFf093fb), Color(0xFFf5576c)], // Pink
    [Color(0xFF4facfe), Color(0xFF00f2fe)], // Blue
    [Color(0xFF43e97b), Color(0xFF38f9d7)], // Green
    [Color(0xFFfa709a), Color(0xFFfee140)], // Coral
    [Color(0xFF30cfd0), Color(0xFF667eea)], // Cyan
  ];

  @override
  Widget build(BuildContext context) {
    if (mahasiswaList.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Tidak ada data mahasiswa',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => onRefresh?.call(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mahasiswaList.length,
        itemBuilder: (context, index) {
          return MahasiswaCard(
            mahasiswa: mahasiswaList[index],
            gradientColors: _gradients[index % _gradients.length],
          );
        },
      ),
    );
  }
}