import 'package:fit_workout/app_router.dart';
import 'package:fit_workout/core/database_helper.dart';
import 'package:fit_workout/core/model/workout_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PlanListScreen extends StatefulWidget {
  const PlanListScreen({super.key});

  @override
  State<PlanListScreen> createState() => _PlanListScreenState();
}

class _PlanListScreenState extends State<PlanListScreen> {
  late Future<List<WorkoutPlan>> _plansFuture;

  @override
  void initState() {
    super.initState();
    _refreshPlanList();
  }

  // Mengambil ulang data dari database
  void _refreshPlanList() {
    setState(() {
      _plansFuture = DatabaseHelper.instance.readAllWorkoutPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Workout Plan'),
      ),
      body: FutureBuilder<List<WorkoutPlan>>(
        future: _plansFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada plan. Tekan + untuk menambah.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
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
                  title: Text(plan.name),
                  subtitle: Text(
                    plan.description ?? 'Tidak ada deskripsi',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _deletePlan(plan.id!),
                  ),
                  onTap: () {
                    // Navigasi ke halaman detail plan menggunakan go_router
                    context.pushNamed(
                      AppRoutes.planDetailRouteName,
                      pathParameters: {'planId': plan.id.toString()},
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showPlanForm(),
      ),
    );
  }

  // Menghapus plan
  Future<void> _deletePlan(int id) async {
    // Tampilkan dialog konfirmasi
    final bool? didConfirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Plan?'),
        content: const Text('Apakah Anda yakin ingin menghapus plan ini? Ini akan menghapus semua data terkait.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (didConfirm == true) {
      await DatabaseHelper.instance.deleteWorkoutPlan(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Plan berhasil dihapus'),
          backgroundColor: Colors.green,
        ),
      );
      _refreshPlanList();
    }
  }

  // Menampilkan dialog form untuk menambah atau edit plan
  void _showPlanForm({WorkoutPlan? plan}) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: plan?.name);
    final descController = TextEditingController(text: plan?.description);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    plan == null ? 'Tambah Plan' : 'Edit Plan',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Plan',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Nama tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: descController,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi (Opsional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final newPlan = WorkoutPlan(
                          id: plan?.id, // ID tetap jika edit
                          name: nameController.text,
                          description: descController.text.isNotEmpty
                              ? descController.text
                              : null,
                        );

                        if (plan == null) {
                          // Create
                          await DatabaseHelper.instance.createWorkoutPlan(newPlan);
                        } else {
                          // Update
                          await DatabaseHelper.instance.updateWorkoutPlan(newPlan);
                        }
                        
                        Navigator.of(context).pop(); // Tutup bottom sheet
                        _refreshPlanList(); // Segarkan list
                      }
                    },
                    child: Text(plan == null ? 'Simpan' : 'Update'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
