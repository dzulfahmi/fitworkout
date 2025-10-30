import 'package:fit_workout/core/database_helper.dart';
import 'package:fit_workout/core/model/workout_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Impor untuk format tanggal

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<SessionHistoryViewModel>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    setState(() {
      _historyFuture = DatabaseHelper.instance.readAllSessionsHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Latihan'),
      ),
      body: FutureBuilder<List<SessionHistoryViewModel>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada riwayat latihan.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final historyList = snapshot.data!;
          // Format tanggal agar lebih mudah dibaca
          final DateFormat dateFormat = DateFormat('EEEE, d MMM yyyy - HH:mm', 'id_ID');

          return ListView.builder(
            itemCount: historyList.length,
            itemBuilder: (context, index) {
              final history = historyList[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.check_circle_outline, color: Colors.green),
                  title: Text(
                    history.planName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    dateFormat.format(history.sessionDate.toLocal()),
                  ),
                  onTap: () {
                    // TODO: Navigasi ke halaman detail riwayat sesi
                    // (Menampilkan rincian set dan reps untuk sesi tsb)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('TODO: Tampilkan detail sesi ${history.sessionId}'),
                      ),
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
