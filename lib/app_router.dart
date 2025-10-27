import 'package:fit_workout/screens/home_screen.dart';
import 'package:fit_workout/screens/plan_list_screen.dart';
import 'package:fit_workout/screens/workout_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// TODO: Impor halaman lain saat sudah dibuat
// import 'package:home_workout_tracker/screens/plan_list_screen.dart';
// import 'package:home_workout_tracker/screens/history_screen.dart';
// import 'package:home_workout_tracker/screens/start_session_screen.dart';

// Definisikan nama route agar mudah diakses dan menghindari typo
class AppRoutes {
  static const String homeRouteName = 'home';
  static const String workoutListRouteName = 'workouts';
  static const String planListRouteName = 'plans';
  static const String planDetailRouteName = 'plan-detail';
  static const String historyRouteName = 'history';
  static const String startSessionRouteName = 'start-session';
}

final appRouter = GoRouter(
  initialLocation: '/', // Rute awal saat aplikasi dibuka
  routes: [
    GoRoute(
      path: '/',
      name: AppRoutes.homeRouteName,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/workouts',
      name: AppRoutes.workoutListRouteName,
      builder: (context, state) => const WorkoutListScreen(),
    ),
    GoRoute(
      path: '/plans',
      name: AppRoutes.planListRouteName,
      builder: (context, state) => const PlanListScreen(), // Menggunakan halaman baru
    ),
    // Rute untuk detail plan, menerima ID sebagai parameter
    GoRoute(
      path: '/plan/:planId', // :planId adalah path parameter
      name: AppRoutes.planDetailRouteName,
      builder: (context, state) {
        // Ambil planId dari path parameter
        final planId = int.tryParse(state.pathParameters['planId'] ?? '');
        if (planId != null) {
          // TODO: Ganti dengan halaman PlanDetailScreen(planId: planId)
          return Scaffold(
            appBar: AppBar(title: Text('Detail Plan $planId')),
            body: Center(child: Text('TODO: Buat halaman detail untuk plan ID $planId')),
          );
        }
        // Jika ID tidak valid, kembali ke home
        // Sebaiknya tampilkan halaman error
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: const Center(child: Text('ID Plan tidak valid')),
        );
      },
    ),
    /*
    GoRoute(
      path: '/plans',
      name: AppRoutes.planListRouteName,
      builder: (context, state) => const PlanListScreen(), // Ganti dengan widget Anda
    ),
    GoRoute(
      path: '/history',
      name: AppRoutes.historyRouteName,
      builder: (context, state) => const HistoryScreen(), // Ganti dengan widget Anda
    ),
    GoRoute(
      path: '/start-session',
      name: AppRoutes.startSessionRouteName,
      builder: (context, state) => const StartSessionScreen(), // Ganti dengan widget Anda
    ),
    */
  ],
  // Opsional: Tambahkan error builder untuk menangani rute yang tidak ditemukan
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Halaman Tidak Ditemukan')),
    body: Center(
      child: Text('Error: Rute ${state.error} tidak ada.'),
    ),
  ),
);
