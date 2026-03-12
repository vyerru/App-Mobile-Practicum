import 'package:flutter/material.dart';
import 'package:run/features/mahasiswa_aktif/data/models/mahasiswa_aktif_model.dart';

class MahasiswaAktifCard extends StatefulWidget {
  final MahasiswaAktifModel mahasiswa;
  final VoidCallback? onTap;
  final List<Color>? gradientColors;

  const MahasiswaAktifCard({
    Key? key,
    required this.mahasiswa,
    this.onTap,
    this.gradientColors,
  }) : super(key: key);

  @override
  State<MahasiswaAktifCard> createState() => _MahasiswaAktifCardState();
}

class _MahasiswaAktifCardState extends State<MahasiswaAktifCard>
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

  Color _ipkColor(String ipk) {
    final value = double.tryParse(ipk) ?? 0;
    if (value >= 3.5) return Colors.green;
    if (value >= 3.0) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = widget.gradientColors ??
        [
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor.withOpacity(0.7),
        ];
    final ipkValue = double.tryParse(widget.mahasiswa.ipk) ?? 0;

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
                // Mahasiswa Aktif Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.mahasiswa.nama,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      _buildInfoRow(Icons.badge_outlined,
                          'NIM: ${widget.mahasiswa.nim}'),
                      const SizedBox(height: 3),
                      _buildInfoRow(Icons.class_outlined,
                          'Kelas: ${widget.mahasiswa.kelas} • Angkatan ${widget.mahasiswa.angkatan}'),
                      const SizedBox(height: 3),
                      _buildInfoRow(Icons.school_outlined,
                          '${widget.mahasiswa.jurusan} • Sem ${widget.mahasiswa.semester}'),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // IPK Badge
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: _ipkColor(widget.mahasiswa.ipk).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              _ipkColor(widget.mahasiswa.ipk).withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            widget.mahasiswa.ipk,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _ipkColor(widget.mahasiswa.ipk),
                            ),
                          ),
                          Text(
                            'IPK',
                            style: TextStyle(
                              fontSize: 10,
                              color: _ipkColor(widget.mahasiswa.ipk),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    // IPK progress bar
                    SizedBox(
                      width: 44,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: ipkValue / 4.0,
                          backgroundColor:
                              _ipkColor(widget.mahasiswa.ipk).withOpacity(0.15),
                          color: _ipkColor(widget.mahasiswa.ipk),
                          minHeight: 5,
                        ),
                      ),
                    ),
                  ],
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

// List view widget for mahasiswa aktif
class MahasiswaAktifListView extends StatelessWidget {
  final List<MahasiswaAktifModel> mahasiswaList;
  final VoidCallback? onRefresh;

  const MahasiswaAktifListView({
    Key? key,
    required this.mahasiswaList,
    this.onRefresh,
  }) : super(key: key);

  static const List<List<Color>> _gradients = [
    [Color(0xFF4facfe), Color(0xFF00f2fe)], // Blue
    [Color(0xFF43e97b), Color(0xFF38f9d7)], // Green
    [Color(0xFF667eea), Color(0xFF764ba2)], // Purple
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
            Icon(Icons.person_outline_rounded, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Tidak ada mahasiswa aktif',
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
          return MahasiswaAktifCard(
            mahasiswa: mahasiswaList[index],
            gradientColors: _gradients[index % _gradients.length],
          );
        },
      ),
    );
  }
}