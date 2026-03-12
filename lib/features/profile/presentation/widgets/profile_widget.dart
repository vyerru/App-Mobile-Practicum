import 'package:flutter/material.dart';
import 'package:run/features/profile/data/models/profile_model.dart'; // Sesuaikan

class ProfileHeaderWidget extends StatelessWidget {
  final ProfileModel profile;

  const ProfileHeaderWidget({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Center(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                child: Text(
                  profile.nama.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                  onPressed: () {
                    // Logika edit foto profil
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          profile.nama,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          profile.jabatan,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProfileInfoTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Theme.of(context).primaryColor),
        ),
        title: Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        subtitle: Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
      ),
    );
  }
}