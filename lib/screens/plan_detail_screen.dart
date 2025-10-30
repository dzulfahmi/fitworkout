import 'package:fit_workout/core/database_helper.dart';
import 'package:fit_workout/core/model/workout_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart' as sqlite;

class PlanDetailScreen extends StatefulWidget {
  final int planId;
  const PlanDetailScreen({super.key, required this.planId});

  @override
  State<PlanDetailScreen> createState() => _PlanDetailScreenState();
}

class _PlanDetailScreenState extends State<PlanDetailScreen> {
  // Kita akan menampung 3 data: detail plan, daftar workout yg di-assign,
  // dan daftar semua workout (untuk dropdown 'Tambah')
  WorkoutPlan? _plan;
  late Future<List<PlanWorkoutViewModel>> _assignedWorkoutsFuture;
  List<PlanWorkoutViewModel> _assignedWorkoutsList = [];
  List<WorkoutModel> _allWorkouts = [];

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  // Mengambil semua data yang diperlukan untuk halaman ini
  void _loadAllData() async {
    final plan = await DatabaseHelper.instance.readWorkoutPlan(widget.planId);
    final allWorkouts = await DatabaseHelper.instance.readAllWorkouts();
    setState(() {
      _plan = plan;
      _allWorkouts = allWorkouts;
    });
    // Memuat daftar workout yang di-assign dipisah ke Future
    _refreshAssignedList();
  }

  // Fungsi untuk me-refresh daftar workout yang di-assign
  void _refreshAssignedList() {
    // 1. Ambil future-nya untuk FutureBuilder
    _assignedWorkoutsFuture =
        DatabaseHelper.instance.getWorkoutsForPlan(widget.planId);

    // 2. Saat future selesai, simpan hasilnya ke list lokal
    //    untuk digunakan oleh FAB
    _assignedWorkoutsFuture.then((list) {
      setState(() {
        _assignedWorkoutsList = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Tampilkan nama plan jika sudah dimuat
        title: Text(_plan?.name ?? 'Memuat...'),
      ),
      body: FutureBuilder<List<PlanWorkoutViewModel>>(
        future: _assignedWorkoutsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Plan ini kosong. Tekan + untuk menambah workout.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final assignedWorkouts = snapshot.data!;

          return ListView.builder(
            itemCount: assignedWorkouts.length,
            itemBuilder: (context, index) {
              final workout = assignedWorkouts[index];
              return Card(
                child: ListTile(
                  title: Text(workout.workoutName,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    'Set: ${workout.sets}  |  Reps: ${workout.repMin}-${workout.repMax}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tombol Edit
                      IconButton(
                        icon:
                            Icon(Icons.edit, color: Colors.blueGrey.shade700),
                        onPressed: () =>
                            _showAssignWorkoutDialog(existingWorkout: workout),
                      ),
                      // Tombol Hapus
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.redAccent),
                        onPressed: () =>
                            _removeWorkoutFromPlan(workout.planWorkoutId),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Panggil dialog, tapi tanpa data (mode 'Tambah')
          _showAssignWorkoutDialog();
        },
      ),
    );
  }

  // --- LOGIKA DIALOG DAN AKSI ---

  // Menghapus workout dari plan
  Future<void> _removeWorkoutFromPlan(int planWorkoutId) async {
    final bool? didConfirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Workout?'),
        content: const Text(
            'Anda yakin ingin menghapus workout ini dari plan? (Workout aslinya tidak akan terhapus)'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Batal')),
          TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Hapus')),
        ],
      ),
    );

    if (didConfirm == true) {
      await DatabaseHelper.instance.removeWorkoutFromPlan(planWorkoutId);
      _refreshAssignedList();
    }
  }

  // Menampilkan dialog untuk 'Tambah' atau 'Edit' workout ke plan
  void _showAssignWorkoutDialog({PlanWorkoutViewModel? existingWorkout}) {
    final formKey = GlobalKey<FormState>();
    int? selectedWorkoutId = existingWorkout?.workoutId;
    final setsController =
        TextEditingController(text: existingWorkout?.sets.toString());
    final repMinController =
        TextEditingController(text: existingWorkout?.repMin.toString());
    final repMaxController =
        TextEditingController(text: existingWorkout?.repMax.toString());

    final bool isEditing = existingWorkout != null;

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEditing ? 'Edit Workout' : 'Tambah Workout ke Plan',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  
                  // Tampilkan Dropdown jika 'Tambah',
                  // Tampilkan Teks jika 'Edit'
                  if (isEditing)
                    Text(
                      'Workout: ${existingWorkout.workoutName}',
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.blueGrey),
                    )
                  else
                    DropdownButtonFormField<int>(
                      value: selectedWorkoutId,
                      hint: const Text('Pilih Workout'),
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                      items: _allWorkouts.map((workout) {
                        return DropdownMenuItem(
                          value: workout.id,
                          child: Text(workout.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        selectedWorkoutId = value;
                      },
                      validator: (value) =>
                          value == null ? 'Pilih satu workout' : null,
                    ),
                  
                  const SizedBox(height: 12),
                  // Input untuk Set, Rep Min, Rep Max
                  Row(
                    children: [
                      Expanded(
                        child: _buildNumberTextField(
                            setsController, 'Set'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildNumberTextField(
                            repMinController, 'Rep Min'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildNumberTextField(
                            repMaxController, 'Rep Max'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final planWorkout = PlanWorkout(
                          // ID di-set null jika 'Tambah', atau pakai ID lama jika 'Edit'
                          id: existingWorkout?.planWorkoutId, 
                          planId: widget.planId,
                          workoutId: selectedWorkoutId!,
                          targetSets: int.parse(setsController.text),
                          targetRepMin: int.parse(repMinController.text),
                          targetRepMax: int.parse(repMaxController.text),
                        );

                        try {
                          if (isEditing) {
                            // Update
                            await DatabaseHelper.instance
                                .updatePlanWorkout(planWorkout);
                          } else {
                            // Create (Assign)
                            await DatabaseHelper.instance
                                .assignWorkoutToPlan(planWorkout);
                          }
                          Navigator.of(context).pop(); // Tutup bottom sheet
                          _refreshAssignedList(); // Segarkan list
                        } on sqlite.DatabaseException catch (e) {
                          // Tangkap error jika workout sudah ada di plan
                          if (e.toString().contains('UNIQUE constraint failed')) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Error: Workout ini sudah ada di plan.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                             ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error database: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }
                    },
                    child: Text(isEditing ? 'Update' : 'Simpan'),
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

  // Helper widget untuk number text field
  Widget _buildNumberTextField(
      TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Wajib diisi';
        }
        if (int.tryParse(value) == null) {
          return 'Angka saja';
        }
        return null;
      },
    );
  }
}
