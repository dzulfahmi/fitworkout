import 'package:fit_workout/core/database_helper.dart';
import 'package:fit_workout/core/model/workout_model.dart';
import 'package:flutter/material.dart';

class WorkoutListScreen extends StatefulWidget {
  const WorkoutListScreen({super.key});

  @override
  State<WorkoutListScreen> createState() => _WorkoutListScreenState();
}

class _WorkoutListScreenState extends State<WorkoutListScreen> {
  late Future<List<WorkoutModel>> _workoutsFuture;

  @override
  void initState() {
    super.initState();
    _refreshWorkoutList();
  }

  // Mengambil ulang data dari database
  void _refreshWorkoutList() {
    setState(() {
      _workoutsFuture = DatabaseHelper.instance.readAllWorkouts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Workout'),
      ),
      body: FutureBuilder<List<WorkoutModel>>(
        future: _workoutsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada workout. Tekan + untuk menambah.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final workouts = snapshot.data!;

          return ListView.builder(
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final workout = workouts[index];
              return Card(
                child: ListTile(
                  title: Text(workout.name),
                  subtitle: Text(
                    workout.description ?? 'Tidak ada deskripsi',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _deleteWorkout(workout.id!),
                  ),
                  onTap: () => _showWorkoutForm(workout: workout),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showWorkoutForm(),
      ),
    );
  }

  // Menghapus workout
  Future<void> _deleteWorkout(int id) async {
    // Tampilkan dialog konfirmasi
    final bool? didConfirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Workout?'),
        content: const Text('Apakah Anda yakin ingin menghapus workout ini?'),
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
      await DatabaseHelper.instance.deleteWorkout(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Workout berhasil dihapus'),
          backgroundColor: Colors.green,
        ),
      );
      _refreshWorkoutList();
    }
  }

  // Menampilkan dialog form untuk menambah atau edit workout
  void _showWorkoutForm({WorkoutModel? workout}) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: workout?.name);
    final descController = TextEditingController(text: workout?.description);
    final youtubeController = TextEditingController(text: workout?.youtubeLink);
    final notesController = TextEditingController(text: workout?.notes);

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
                    workout == null ? 'Tambah Workout' : 'Edit Workout',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Workout',
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
                      labelText: 'Deskripsi',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: youtubeController,
                    decoration: const InputDecoration(
                      labelText: 'Link YouTube (Opsional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: notesController,
                    decoration: const InputDecoration(
                      labelText: 'Keterangan/Catatan (Opsional)',
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
                        final newWorkout = WorkoutModel(
                          id: workout?.id, // ID tetap jika edit
                          name: nameController.text,
                          description: descController.text.isNotEmpty
                              ? descController.text
                              : null,
                          youtubeLink: youtubeController.text.isNotEmpty
                              ? youtubeController.text
                              : null,
                          notes: notesController.text.isNotEmpty
                              ? notesController.text
                              : null,
                        );

                        if (workout == null) {
                          // Create
                          await DatabaseHelper.instance.createWorkout(newWorkout);
                        } else {
                          // Update
                          await DatabaseHelper.instance.updateWorkout(newWorkout);
                        }
                        
                        Navigator.of(context).pop(); // Tutup bottom sheet
                        _refreshWorkoutList(); // Segarkan list
                      }
                    },
                    child: Text(workout == null ? 'Simpan' : 'Update'),
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
