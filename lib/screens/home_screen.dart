import 'package:fit_workout/app_router.dart';
import 'package:flutter/material.dart';
// Hapus impor workout_list_screen.dart
// import 'package:home_workout_tracker/screens/workout_list_screen.dart';
import 'package:go_router/go_router.dart'; // Impor go_router

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Tracker'),
      ),
      body: ListView(
        children: [
          _buildMenuCard(
            context,
            icon: Icons.fitness_center,
            title: 'Mulai Latihan',
            subtitle: 'Pilih plan dan catat sesi Anda',
            onTap: () {
              // Navigasi ke halaman pemilihan plan untuk memulai sesi
              context.pushNamed(AppRoutes.startSessionRouteName);
            },
          ),
          _buildMenuCard(
            context,
            icon: Icons.list_alt,
            title: 'Kelola Workout Plan',
            subtitle: 'Buat dan edit rencana latihan Anda',
            onTap: () {
              // Navigasi ke halaman CRUD Workout Plan (Fitur 2 & 3)
              context.pushNamed(AppRoutes.planListRouteName);
            },
          ),
          _buildMenuCard(
            context,
            icon: Icons.accessibility_new,
            title: 'Database Workout',
            subtitle: 'Kelola daftar latihan (push up, squat, dll)',
            onTap: () {
              context.pushNamed(AppRoutes.workoutListRouteName);
            },
          ),
          _buildMenuCard(
            context,
            icon: Icons.history,
            title: 'Riwayat Latihan',
            subtitle: 'Lihat sesi latihan yang telah selesai',
            onTap: () {
              // Navigasi ke halaman riwayat
              context.pushNamed(AppRoutes.historyRouteName);
            },
          ),
          _buildMenuCard(
            context,
            icon: Icons.history,
            title: 'Riwayat Latihan',
            subtitle: 'Lihat progres dan sesi sebelumnya',
            onTap: () {
              // TODO: Navigasi ke halaman riwayat (Fitur 4)
              // Ganti dengan: context.pushNamed(AppRoutes.historyRouteName);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'Halaman "Riwayat" belum dibuat. Tambahkan di app_router.dart')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 40, color: Theme.of(context).primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

