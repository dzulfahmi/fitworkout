
import 'package:fit_workout/app_router.dart';
import 'package:fit_workout/core/database_helper.dart';
import 'package:fit_workout/core/model/workout_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StartSessionScreen extends StatefulWidget {
  const StartSessionScreen({super.key});

  @override
  State<StartSessionScreen> createState() => _StartSessionScreenState();
}

class _StartSessionScreenState extends State<StartSessionScreen> {
  late Future<List<WorkoutPlan>> _plansFuture;

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  void _loadPlans() {
    setState(() {
      _plansFuture = DatabaseHelper.instance.readAllWorkoutPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Plan Latihan'),
      ),
      body: FutureBuilder<List<WorkoutPlan>>(
        future: _plansFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Anda belum memiliki Workout Plan.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Arahkan ke halaman pembuatan plan
                      context.pushNamed(AppRoutes.planListRouteName).then((_) {
                        // Refresh daftar plan setelah kembali
                        _loadPlans();
                      });
                    },
                    child: const Text('Buat Plan Sekarang'),
                  )
                ],
              ),
            );
          }

          final plans = snapshot.data!;

          return ListView.builder(
            itemCount: plans.length,
            itemBuilder: (context, index) {
              final plan = plans[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColorLight,
                    child: Text(
                      plan.name.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColorDark),
                    ),
                  ),
                  title: Text(plan.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    plan.description ?? 'Ketuk untuk memulai',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.play_arrow_rounded),
                  onTap: () {
                    // Navigasi ke halaman pencatatan sesi (yang akan kita buat)
                    // Kita akan kirim ID plan agar halaman tsb tahu
                    // workout apa yang harus ditampilkan
                    context.pushNamed(
                      AppRoutes.sessionLogRouteName,
                      pathParameters: {'planId': plan.id.toString()},
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
