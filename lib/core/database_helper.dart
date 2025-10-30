import 'package:fit_workout/core/model/workout_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('workouts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Membuat semua tabel saat database pertama kali dibuat
  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textTypeNullable = 'TEXT';
    const intType = 'INTEGER NOT NULL';
    const intTypeNullable = 'INTEGER';
    const realTypeNullable = 'REAL';

    // Tabel 1: Workouts (Fitur 1)
    await db.execute('''
CREATE TABLE $tableWorkouts ( 
  ${WorkoutFields.id} $idType, 
  ${WorkoutFields.name} $textType,
  ${WorkoutFields.description} $textTypeNullable,
  ${WorkoutFields.youtubeLink} $textTypeNullable,
  ${WorkoutFields.notes} $textTypeNullable
  )
''');

    // Tabel 2: Workout Plans (Fitur 2)
    await db.execute('''
CREATE TABLE $tableWorkoutPlans (
  ${WorkoutPlanFields.id} $idType,
  ${WorkoutPlanFields.name} $textType,
  ${WorkoutPlanFields.description} $textTypeNullable
  )
''');

    // Tabel 3: Plan Workouts (Junction Table untuk Fitur 3)
    // Menyimpan workout mana saja yang ada di dalam plan apa
    await db.execute('''
CREATE TABLE $tablePlanWorkouts (
  ${PlanWorkoutFields.id} $idType,
  ${PlanWorkoutFields.planId} $intType,
  ${PlanWorkoutFields.workoutId} $intType,
  ${PlanWorkoutFields.targetSets} $intType,
  ${PlanWorkoutFields.targetRepMin} $intType,
  ${PlanWorkoutFields.targetRepMax} $intType,
  FOREIGN KEY (${PlanWorkoutFields.planId}) REFERENCES $tableWorkoutPlans (${WorkoutPlanFields.id}) ON DELETE CASCADE,
  FOREIGN KEY (${PlanWorkoutFields.workoutId}) REFERENCES $tableWorkouts (${WorkoutFields.id}) ON DELETE CASCADE
  )
''');

    // Tabel 4: Workout Sessions (Fitur 4, Header Sesi)
    // Mencatat sesi latihan (plan apa, kapan)
    await db.execute('''
CREATE TABLE $tableWorkoutSessions (
  ${WorkoutSessionFields.id} $idType,
  ${WorkoutSessionFields.planId} $intType,
  ${WorkoutSessionFields.date} $textType,
  ${WorkoutSessionFields.notes} $textTypeNullable,
  FOREIGN KEY (${WorkoutSessionFields.planId}) REFERENCES $tableWorkoutPlans (${WorkoutPlanFields.id}) ON DELETE SET NULL
  )
''');

    // Tabel 5: Session Logs (Fitur 4, Detail Sesi)
    // Mencatat detail setiap set yang dilakukan dalam sebuah sesi
    await db.execute('''
CREATE TABLE $tableSessionLogs (
  ${SessionLogFields.id} $idType,
  ${SessionLogFields.sessionId} $intType,
  ${SessionLogFields.workoutId} $intType,
  ${SessionLogFields.setNumber} $intType,
  ${SessionLogFields.repsDone} $intType,
  ${SessionLogFields.weight} $realTypeNullable,
  ${SessionLogFields.notes} $textTypeNullable,
  FOREIGN KEY (${SessionLogFields.sessionId}) REFERENCES $tableWorkoutSessions (${WorkoutSessionFields.id}) ON DELETE CASCADE,
  FOREIGN KEY (${SessionLogFields.workoutId}) REFERENCES $tableWorkouts (${WorkoutFields.id}) ON DELETE SET NULL
  )
''');
  }

  // --- CRUD WORKOUT (Fitur 1) ---

  Future<WorkoutModel> createWorkout(WorkoutModel workout) async {
    final db = await instance.database;
    final id = await db.insert(tableWorkouts, workout.toMap());
    return workout.copy(id: id);
  }

  Future<WorkoutModel> readWorkout(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableWorkouts,
      columns: WorkoutFields.values,
      where: '${WorkoutFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return WorkoutModel.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<WorkoutModel>> readAllWorkouts() async {
    final db = await instance.database;
    final result = await db.query(tableWorkouts);
    return result.map((json) => WorkoutModel.fromMap(json)).toList();
  }

  Future<int> updateWorkout(WorkoutModel workout) async {
    final db = await instance.database;
    return db.update(
      tableWorkouts,
      workout.toMap(),
      where: '${WorkoutFields.id} = ?',
      whereArgs: [workout.id],
    );
  }

  Future<int> deleteWorkout(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableWorkouts,
      where: '${WorkoutFields.id} = ?',
      whereArgs: [id],
    );
  }

  // --- CRUD WORKOUT PLAN (Fitur 2) ---

  Future<WorkoutPlan> createWorkoutPlan(WorkoutPlan plan) async {
    final db = await instance.database;
    final id = await db.insert(tableWorkoutPlans, plan.toMap());
    return plan.copy(id: id);
  }

  Future<List<WorkoutPlan>> readAllWorkoutPlans() async {
    final db = await instance.database;
    final result = await db.query(tableWorkoutPlans);
    return result.map((json) => WorkoutPlan.fromMap(json)).toList();
  }

  // FUNGSI BARU: Membaca satu WorkoutPlan
  Future<WorkoutPlan> readWorkoutPlan(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableWorkoutPlans,
      columns: WorkoutPlanFields.values,
      where: '${WorkoutPlanFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return WorkoutPlan.fromMap(maps.first);
    } else {
      throw Exception('Plan ID $id not found');
    }
  }

  Future<int> updateWorkoutPlan(WorkoutPlan plan) async {
    final db = await instance.database;
    return db.update(
      tableWorkoutPlans,
      plan.toMap(),
      where: '${WorkoutPlanFields.id} = ?',
      whereArgs: [plan.id],
    );
  }

  Future<int> deleteWorkoutPlan(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableWorkoutPlans,
      where: '${WorkoutPlanFields.id} = ?',
      whereArgs: [id],
    );
  }

  // (Anda bisa tambahkan readWorkoutPlan, update, delete sesuai kebutuhan)

  // --- ASSIGN WORKOUT TO PLAN (Fitur 3) ---

  Future<PlanWorkout> assignWorkoutToPlan(PlanWorkout planWorkout) async {
    final db = await instance.database;
    final id = await db.insert(tablePlanWorkouts, planWorkout.toMap());
    return planWorkout.copy(id: id);
  }

  // Mendapatkan semua detail workout dalam sebuah plan
  Future<List<PlanWorkoutViewModel>> getWorkoutsForPlan(int planId) async {
    final db = await instance.database;
    // Query ini menggabungkan tabel plan_workouts dengan tabel workouts
    // untuk mendapatkan nama workout dan detail set/reps
    final result = await db.rawQuery('''
      SELECT
        w.${WorkoutFields.id} as workoutId,
        w.${WorkoutFields.name},
        w.${WorkoutFields.description},
        pw.${PlanWorkoutFields.id} as planWorkoutId,
        pw.${PlanWorkoutFields.targetSets},
        pw.${PlanWorkoutFields.targetRepMin},
        pw.${PlanWorkoutFields.targetRepMax}
      FROM $tablePlanWorkouts as pw
      JOIN $tableWorkouts as w ON pw.${PlanWorkoutFields.workoutId} = w.${WorkoutFields.id}
      WHERE pw.${PlanWorkoutFields.planId} = ?
    ''', [planId]);

    // Mengubah hasil query map menjadi List dari model view kita
    return result.map((json) => PlanWorkoutViewModel.fromMap(json)).toList();
  }
  
  // FUNGSI BARU: Menghapus workout dari plan
  Future<int> removeWorkoutFromPlan(int planWorkoutId) async {
    final db = await instance.database;
    return db.delete(
      tablePlanWorkouts,
      where: '${PlanWorkoutFields.id} = ?',
      whereArgs: [planWorkoutId],
    );
  }

  // FUNGSI BARU: Memperbarui detail workout (set/reps) di plan
  Future<int> updatePlanWorkout(PlanWorkout planWorkout) async {
    final db = await instance.database;
    return db.update(
      tablePlanWorkouts,
      planWorkout.toMap(),
      where: '${PlanWorkoutFields.id} = ?',
      whereArgs: [planWorkout.id],
    );
  }


  // --- LOGGING WORKOUT SESSION (Fitur 4) ---

  // 1. Memulai sesi baru
  Future<WorkoutSession> createWorkoutSession(WorkoutSession session) async {
    final db = await instance.database;
    final id = await db.insert(tableWorkoutSessions, session.toMap());
    return session.copy(id: id);
  }

  // 2. Mencatat satu set
  Future<SessionLog> createSessionLog(SessionLog log) async {
    final db = await instance.database;
    final id = await db.insert(tableSessionLogs, log.toMap());
    return log.copy(id: id);
  }

  // 3. Mendapatkan riwayat sesi (misalnya, untuk halaman history)
  Future<List<Map<String, dynamic>>> getSessionHistory() async {
    final db = await instance.database;
    // Mengambil header sesi dan nama plan-nya
    final result = await db.rawQuery('''
      SELECT
        s.${WorkoutSessionFields.id},
        s.${WorkoutSessionFields.date},
        s.${WorkoutSessionFields.notes},
        p.${WorkoutPlanFields.name} as planName
      FROM $tableWorkoutSessions as s
      LEFT JOIN $tableWorkoutPlans as p ON s.${WorkoutSessionFields.planId} = p.${WorkoutPlanFields.id}
      ORDER BY s.${WorkoutSessionFields.date} DESC
    ''');
    return result;
  }

  // 4. Mendapatkan detail log dari satu sesi
  Future<List<Map<String, dynamic>>> getLogsForSession(int sessionId) async {
    final db = await instance.database;
    final result = await db.rawQuery('''
      SELECT
        l.${SessionLogFields.setNumber},
        l.${SessionLogFields.repsDone},
        l.${SessionLogFields.weight},
        w.${WorkoutFields.name} as workoutName
      FROM $tableSessionLogs as l
      JOIN $tableWorkouts as w ON l.${SessionLogFields.workoutId} = w.${WorkoutFields.id}
      WHERE l.${SessionLogFields.sessionId} = ?
      ORDER BY w.${WorkoutFields.name}, l.${SessionLogFields.setNumber}
    ''', [sessionId]);
    return result;
  }

  Future<List<SessionHistoryViewModel>> readAllSessionsHistory() async {
    final db = await instance.database;

    // Kita menggunakan rawQuery untuk melakukan JOIN
    // Kita menggabungkan tabel session (t1) dengan tabel plan (t2)
    // berdasarkan planId
    final String sql = '''
      SELECT 
        t1.${WorkoutSessionFields.id} as sessionId,
        t1.${WorkoutSessionFields.planId} as planId,
        t1.${WorkoutSessionFields.date} as sessionDate,
        t2.${WorkoutPlanFields.name} as planName
      FROM $tableWorkoutSessions t1
      JOIN $tableWorkoutPlans t2 ON t1.${WorkoutSessionFields.planId} = t2.${WorkoutPlanFields.id}
      ORDER BY t1.${WorkoutSessionFields.date} DESC
    ''';
    
    final result = await db.rawQuery(sql);

    return result.map((json) => SessionHistoryViewModel.fromMap(json)).toList();
  }


  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
